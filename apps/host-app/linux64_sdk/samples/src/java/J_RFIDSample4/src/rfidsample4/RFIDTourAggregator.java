package rfidsample4;

import com.mot.rfid.api3.AntennaInfo;
import com.mot.rfid.api3.Antennas;
import com.mot.rfid.api3.FILTER_ACTION;
import com.mot.rfid.api3.InvalidUsageException;
import com.mot.rfid.api3.INVENTORY_STATE;
import com.mot.rfid.api3.MEMORY_BANK;
import com.mot.rfid.api3.OperationFailureException;
import com.mot.rfid.api3.PreFilters;
import com.mot.rfid.api3.PreFilters.PreFilter;
import com.mot.rfid.api3.RFIDReader;
import com.mot.rfid.api3.RfidEventsListener;
import com.mot.rfid.api3.RfidReadEvents;
import com.mot.rfid.api3.RfidStatusEvents;
import com.mot.rfid.api3.SL_FLAG;
import com.mot.rfid.api3.START_TRIGGER_TYPE;
import com.mot.rfid.api3.STATE_UNAWARE_ACTION;
import com.mot.rfid.api3.STATUS_EVENT_TYPE;
import com.mot.rfid.api3.STOP_TRIGGER_TYPE;
import com.mot.rfid.api3.TAG_EVENT_REPORT_TRIGGER;
import com.mot.rfid.api3.TagData;
import com.mot.rfid.api3.TagStorageSettings;
import com.mot.rfid.api3.TRACE_LEVEL;
import com.mot.rfid.api3.TriggerInfo;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.ConcurrentHashMap;
import java.util.concurrent.Executors;
import java.util.concurrent.ScheduledExecutorService;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

public class RFIDTourAggregator {

    private static final List<String> FALLBACK_EPCS = Arrays.asList(
            "E28069950000500CA794A479",
            "E28069950000400CA7917C78",
            "E28069950000400CA791C478");

    private final RFIDReader reader = new RFIDReader();
    private final Lock inventoryStopLock = new ReentrantLock();
    private final Condition inventoryStoppedCond = inventoryStopLock.newCondition();

    private volatile boolean inventoryStopped;
    private volatile boolean running;
    private volatile boolean readerConnected;

    private final ConcurrentHashMap<AggregationKey, RollingAggregation> aggregations =
            new ConcurrentHashMap<AggregationKey, RollingAggregation>();
    private final Map<String, String> epcToTour = new ConcurrentHashMap<String, String>();

    private ScheduledExecutorService evaluator;
    private MqttClient mqttClient;

    private AppConfig config;

    public static void main(String[] args) throws Exception {
        AppConfig cfg = AppConfig.fromArgs(args);
        RFIDTourAggregator app = new RFIDTourAggregator();
        app.start(cfg);
    }

    private void start(AppConfig cfg) throws Exception {
        this.config = cfg;
        loadEpcTourMap(cfg.epcMapCsv, cfg.defaultTourId);

        if (epcToTour.isEmpty()) {
            throw new IllegalStateException("No EPC mappings available. Provide CSV or fallback EPCs.");
        }

        connectMqtt();
        connectReader();

        Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
            public void run() {
                shutdown();
            }
        }));

        short[] antennas = reader.Config.Antennas.getAvailableAntennas();
        if (antennas == null || antennas.length == 0) {
            throw new IllegalStateException("Reader reported no available antennas");
        }

        short[] activeAntennas = applyAntennaPowerConfig(antennas);
        if (activeAntennas.length == 0) {
            throw new IllegalStateException(
                    "No antennas enabled. Set antenna.txPowerIndex.<id> in config for at least one available antenna.");
        }

        applyPrefixPrefilterAndSingulation(activeAntennas);

        reader.Actions.purgeTags();
        TriggerInfo triggerInfo = defaultTriggerInfo();
        AntennaInfo antennaInfo = new AntennaInfo(activeAntennas);

        running = true;
        evaluator = Executors.newSingleThreadScheduledExecutor();
        evaluator.scheduleAtFixedRate(new Runnable() {
            public void run() {
                evaluateAndPublish();
            }
        }, config.checkSeconds, config.checkSeconds, TimeUnit.SECONDS);

        inventoryStopped = false;
        reader.Actions.Inventory.perform(null, triggerInfo, antennaInfo);
        System.out.println("Inventory started on antennas " + Arrays.toString(activeAntennas));
        System.out.println("Mapped EPC count: " + epcToTour.size());

        if (config.runMs > 0) {
            long deadline = System.currentTimeMillis() + config.runMs;
            while (running && System.currentTimeMillis() < deadline) {
                Thread.sleep(250L);
            }
            shutdown();
        } else {
            while (running) {
                Thread.sleep(250L);
            }
        }
    }

    private void connectReader() throws InvalidUsageException, OperationFailureException {
        reader.setHostName(config.host);
        reader.setPort(config.port);
        reader.connect();
        readerConnected = true;

        reader.Events.setInventoryStartEvent(true);
        reader.Events.setInventoryStopEvent(true);
        reader.Events.setTagReadEvent(true);
        reader.Events.setAttachTagDataWithReadEvent(false);
        reader.Events.setBufferFullEvent(true);
        reader.Events.setBufferFullWarningEvent(true);
        reader.Events.addEventsListener(new EventsHandler());

        TagStorageSettings storage = reader.Config.getTagStorageSettings();
        storage.discardTagsOnInventoryStop(true);
        reader.Config.setTagStorageSettings(storage);
        reader.Config.setTraceLevel(TRACE_LEVEL.TRACE_LEVEL_ERROR);

        System.out.println("Connected reader " + config.host + ":" + config.port);
    }

    private void connectMqtt() throws MqttException {
        String clientId = config.mqttClientId;
        if (clientId == null || clientId.length() == 0) {
            clientId = "rfid-tour-" + UUID.randomUUID().toString();
        }

        mqttClient = new MqttClient(config.mqttBrokerUrl, clientId);
        MqttConnectOptions options = new MqttConnectOptions();
        options.setCleanSession(true);
        if (config.mqttUsername != null && config.mqttUsername.length() > 0) {
            options.setUserName(config.mqttUsername);
        }
        if (config.mqttPassword != null && config.mqttPassword.length() > 0) {
            options.setPassword(config.mqttPassword.toCharArray());
        }
        mqttClient.connect(options);
        System.out.println("Connected MQTT " + config.mqttBrokerUrl + " as " + clientId);
    }

    private void applyPrefixPrefilterAndSingulation(short[] antennas)
            throws InvalidUsageException, OperationFailureException {
        String commonHexPrefix = findCommonHexPrefix(epcToTour.keySet());
        if (commonHexPrefix.length() < 2) {
            System.out.println("No common EPC prefix found across mapped EPCs; skipping hardware prefilter.");
            return;
        }

        int evenPrefixChars = commonHexPrefix.length() - (commonHexPrefix.length() % 2);
        if (evenPrefixChars < 2) {
            System.out.println("Common prefix too short for hardware prefilter; skipping.");
            return;
        }

        String patternHex = commonHexPrefix.substring(0, evenPrefixChars);
        byte[] pattern = hexStringToByteArray(patternHex);
        int patternBits = patternHex.length() * 4;

        int maxPreFilters = reader.ReaderCapabilities.getMaxNumPreFilters();
        if (antennas.length > maxPreFilters) {
            throw new IllegalStateException(
                    "Reader has "
                            + antennas.length
                            + " antennas but MaxNumPreFilters="
                            + maxPreFilters
                            + ".");
        }

        reader.Actions.PreFilters.deleteAll();
        PreFilters factory = new PreFilters();

        for (int i = 0; i < antennas.length; i++) {
            short antennaId = antennas[i];
            PreFilter pf = factory.new PreFilter();
            pf.setAntennaID(antennaId);
            pf.setMemoryBank(MEMORY_BANK.MEMORY_BANK_EPC);
            pf.setBitOffset(32);
            pf.setTagPattern(Arrays.copyOf(pattern, pattern.length));
            pf.setTagPatternBitCount(patternBits);
            pf.setFilterAction(FILTER_ACTION.FILTER_ACTION_STATE_UNAWARE);
            pf.StateUnawareAction.setStateUnawareAction(STATE_UNAWARE_ACTION.STATE_UNAWARE_ACTION_SELECT);
            reader.Actions.PreFilters.add(pf);
        }

        if (reader.ReaderCapabilities.isTagInventoryStateAwareSingulationSupported()) {
            for (int i = 0; i < antennas.length; i++) {
                int ant = antennas[i] & 0xFFFF;
                Antennas.SingulationControl sc = reader.Config.Antennas.getSingulationControl(ant);
                sc.Action.setPerformStateAwareSingulationAction(true);
                sc.Action.setInventoryState(INVENTORY_STATE.INVENTORY_STATE_A);
                sc.Action.setSLFlag(SL_FLAG.SL_FLAG_ASSERTED);
                reader.Config.Antennas.setSingulationControl(ant, sc);
            }
        }

        System.out.println(
                "Applied hardware prefilter common EPC prefix="
                        + patternHex
                        + " ("
                        + patternBits
                        + " bits) on antennas "
                        + Arrays.toString(antennas));
    }

    private TriggerInfo defaultTriggerInfo() throws InvalidUsageException {
        TriggerInfo t = new TriggerInfo();
        t.StartTrigger.setTriggerType(START_TRIGGER_TYPE.START_TRIGGER_TYPE_IMMEDIATE);
        t.StopTrigger.setTriggerType(STOP_TRIGGER_TYPE.STOP_TRIGGER_TYPE_IMMEDIATE);
        t.TagEventReportInfo.setReportNewTagEvent(TAG_EVENT_REPORT_TRIGGER.MODERATED);
        t.TagEventReportInfo.setNewTagEventModeratedTimeoutMilliseconds((short) 500);
        t.TagEventReportInfo.setReportTagInvisibleEvent(TAG_EVENT_REPORT_TRIGGER.MODERATED);
        t.TagEventReportInfo.setTagInvisibleEventModeratedTimeoutMilliseconds((short) 500);
        t.TagEventReportInfo.setReportTagBackToVisibilityEvent(TAG_EVENT_REPORT_TRIGGER.MODERATED);
        t.TagEventReportInfo.setTagBackToVisibilityModeratedTimeoutMilliseconds((short) 500);
        t.setTagReportTrigger(1);
        return t;
    }

    private short[] applyAntennaPowerConfig(short[] antennas)
            throws InvalidUsageException, OperationFailureException {
        List<Short> enabled = new ArrayList<Short>();
        for (int i = 0; i < antennas.length; i++) {
            int antennaId = antennas[i] & 0xFFFF;
            Short txIndex = config.perAntennaTransmitPowerIndex.get(Integer.valueOf(antennaId));
            if (txIndex == null) {
                System.out.println(
                        "Disabled antenna "
                                + antennaId
                                + ": no antenna.txPowerIndex."
                                + antennaId
                                + " configured.");
                continue;
            }
            Antennas.Config cfg = reader.Config.Antennas.getAntennaConfig(antennaId);
            cfg.setTransmitPowerIndex(txIndex.shortValue());
            reader.Config.Antennas.setAntennaConfig(antennaId, cfg);
            System.out.println(
                    "Applied per-antenna transmitPowerIndex antenna="
                            + antennaId
                            + " value="
                            + txIndex);
            enabled.add(Short.valueOf((short) antennaId));
        }

        short[] active = new short[enabled.size()];
        for (int i = 0; i < enabled.size(); i++) {
            active[i] = enabled.get(i).shortValue();
        }
        return active;
    }

    private void onTags() {
        TagData[] tags = reader.Actions.getReadTags(100);
        if (tags == null || tags.length == 0) {
            return;
        }

        long nowSec = System.currentTimeMillis() / 1000L;
        int mappedReads = 0;
        int ignoredReads = 0;
        for (int i = 0; i < tags.length; i++) {
            TagData tag = tags[i];
            String epc = normalizeEpc(tag.getTagID());
            String tourId = epcToTour.get(epc);
            if (tourId == null) {
                ignoredReads++;
                if (config.logUnknownReads) {
                    System.out.println(
                            "DEBUG_READ ignored_unmapped epc="
                                    + epc
                                    + " antenna="
                                    + (tag.getAntennaID() & 0xFFFF)
                                    + " rssi="
                                    + tag.getPeakRSSI());
                }
                continue;
            }

            int antennaId = tag.getAntennaID() & 0xFFFF;
            int rssi = tag.getPeakRSSI();
            mappedReads++;

            if (config.logReads) {
                System.out.println(
                        "DEBUG_READ matched epc="
                                + epc
                                + " antenna="
                                + antennaId
                                + " rssi="
                                + rssi
                                + " tour_id="
                                + tourId);
            }

            AggregationKey key = new AggregationKey(config.siteId, config.readerId, antennaId, tourId);
            RollingAggregation agg = aggregations.get(key);
            if (agg == null) {
                RollingAggregation created = new RollingAggregation();
                RollingAggregation prior = aggregations.putIfAbsent(key, created);
                agg = prior == null ? created : prior;
            }
            agg.record(epc, rssi, nowSec, config.windowSeconds);
        }

        if (config.logReads && mappedReads == 0 && ignoredReads > 0) {
            System.out.println("DEBUG_READ batch had only ignored EPCs count=" + ignoredReads);
        }
    }

    private void evaluateAndPublish() {
        try {
            long nowSec = System.currentTimeMillis() / 1000L;
            Iterator<Map.Entry<AggregationKey, RollingAggregation>> it = aggregations.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry<AggregationKey, RollingAggregation> entry = it.next();
                AggregationKey key = entry.getKey();
                RollingAggregation agg = entry.getValue();

                Evaluation eval = agg.evaluate(
                        nowSec,
                        config.windowSeconds,
                        config.secondsSinceLastRead,
                        config.minDwellSeconds);

                if (eval.shouldEmit) {
                    publishEvent(key, eval);
                }

                if (eval.isIdle) {
                    it.remove();
                }
            }
        } catch (Exception ex) {
            System.err.println("Evaluator error: " + ex.getMessage());
        }
    }

    private void publishEvent(AggregationKey key, Evaluation eval) {
        try {
            ensureMqttConnected();
            String topic =
                    config.mqttTopicRoot
                            + "/"
                            + sanitizeTopicToken(key.siteId)
                            + "/"
                            + sanitizeTopicToken(key.readerId)
                            + "/"
                            + key.antennaId
                            + "/tour/"
                            + sanitizeTopicToken(key.tourId)
                            + "/transition";

            String payload = toJsonPayload(key, eval);
            MqttMessage message = new MqttMessage(payload.getBytes("UTF-8"));
            message.setQos(1);
            message.setRetained(false);
            mqttClient.publish(topic, message);

            System.out.println("Published event topic=" + topic + " payload=" + payload);
        } catch (Exception ex) {
            System.err.println("MQTT publish failed: " + ex.getMessage());
        }
    }

    private void ensureMqttConnected() throws MqttException {
        if (mqttClient != null && mqttClient.isConnected()) {
            return;
        }
        connectMqtt();
    }

    private String toJsonPayload(AggregationKey key, Evaluation eval) {
        StringBuilder sb = new StringBuilder(512);
        sb.append('{');
        appendJsonField(sb, "event_id", UUID.randomUUID().toString(), true);
        appendJsonField(sb, "event_type", "TOUR_GROUP_DEPARTING", true);
        appendJsonField(sb, "event_ts", String.valueOf(System.currentTimeMillis()), true);
        appendJsonField(sb, "site_id", key.siteId, true);
        appendJsonField(sb, "reader_id", key.readerId, true);
        appendJsonNumber(sb, "antenna_id", key.antennaId, true);
        appendJsonField(sb, "tour_id", key.tourId, true);
        appendJsonField(sb, "epc", eval.epc, true);
        appendJsonNumber(sb, "window_start_epoch_sec", eval.windowStartSec, true);
        appendJsonNumber(sb, "window_end_epoch_sec", eval.windowEndSec, true);
        appendJsonNumber(sb, "read_count_60s", eval.windowReadCount, true);
        appendJsonNumber(sb, "unique_tag_count_60s", eval.uniqueTagCount, true);
        appendJsonNumber(sb, "avg_rssi_60s", eval.windowAvgRssi, true);
        appendJsonNumber(sb, "baseline_read_count", eval.baselineReadCount, true);
        appendJsonNumber(sb, "baseline_avg_rssi", eval.baselineAvgRssi, true);
        appendJsonNumber(sb, "count_drop_pct", eval.countDropPct, true);
        appendJsonNumber(sb, "rssi_drop_db", eval.rssiDropDb, true);
        appendJsonNumber(sb, "seconds_since_last_read", eval.secondsSinceLastRead, true);
        appendJsonNumber(sb, "threshold_seconds_since_last_read", config.secondsSinceLastRead, true);
        appendJsonNumber(sb, "dwell_seconds", eval.dwellSeconds, true);
        appendJsonNumber(sb, "min_dwell_seconds", eval.minDwellSeconds, true);
        appendJsonNumber(sb, "consecutive_checks_required", 1, false);
        sb.append('}');
        return sb.toString();
    }

    private void appendJsonField(StringBuilder sb, String key, String value, boolean comma) {
        sb.append('"').append(escapeJson(key)).append('"').append(':');
        sb.append('"').append(escapeJson(value)).append('"');
        if (comma) {
            sb.append(',');
        }
    }

    private void appendJsonNumber(StringBuilder sb, String key, double value, boolean comma) {
        sb.append('"').append(escapeJson(key)).append('"').append(':');
        sb.append(round(value));
        if (comma) {
            sb.append(',');
        }
    }

    private void appendJsonNumber(StringBuilder sb, String key, long value, boolean comma) {
        sb.append('"').append(escapeJson(key)).append('"').append(':');
        sb.append(value);
        if (comma) {
            sb.append(',');
        }
    }

    private String round(double value) {
        if (Double.isNaN(value) || Double.isInfinite(value)) {
            return "0";
        }
        return String.format(java.util.Locale.US, "%.3f", value);
    }

    private String escapeJson(String input) {
        if (input == null) {
            return "";
        }
        StringBuilder out = new StringBuilder(input.length() + 8);
        for (int i = 0; i < input.length(); i++) {
            char c = input.charAt(i);
            if (c == '\\' || c == '"') {
                out.append('\\').append(c);
            } else if (c == '\n') {
                out.append("\\n");
            } else if (c == '\r') {
                out.append("\\r");
            } else if (c == '\t') {
                out.append("\\t");
            } else {
                out.append(c);
            }
        }
        return out.toString();
    }

    private String sanitizeTopicToken(String token) {
        if (token == null || token.length() == 0) {
            return "unknown";
        }
        return token.replace('+', '_').replace('#', '_').replace('/', '_');
    }

    private void loadEpcTourMap(String csvPath, String defaultTourId) throws IOException {
        epcToTour.clear();

        if (csvPath != null && csvPath.length() > 0) {
            File f = new File(csvPath);
            if (f.exists() && f.isFile()) {
                BufferedReader br = null;
                try {
                    br = new BufferedReader(new FileReader(f));
                    String line;
                    while ((line = br.readLine()) != null) {
                        line = line.trim();
                        if (line.length() == 0 || line.startsWith("#")) {
                            continue;
                        }
                        String[] parts = line.split(",");
                        if (parts.length < 2) {
                            continue;
                        }
                        String epc = normalizeEpc(parts[0]);
                        String tourId = parts[1].trim();
                        if (epc.length() == 0 || tourId.length() == 0) {
                            continue;
                        }
                        epcToTour.put(epc, tourId);
                    }
                } finally {
                    if (br != null) {
                        br.close();
                    }
                }
            }
        }

        if (epcToTour.isEmpty()) {
            for (int i = 0; i < FALLBACK_EPCS.size(); i++) {
                epcToTour.put(normalizeEpc(FALLBACK_EPCS.get(i)), defaultTourId);
            }
            System.out.println("Using fallback EPC map with default tour_id=" + defaultTourId);
        }
    }

    private String findCommonHexPrefix(Iterable<String> epcs) {
        String prefix = null;
        Iterator<String> it = epcs.iterator();
        while (it.hasNext()) {
            String epc = normalizeEpc(it.next());
            if (prefix == null) {
                prefix = epc;
            } else {
                int max = Math.min(prefix.length(), epc.length());
                int idx = 0;
                while (idx < max && prefix.charAt(idx) == epc.charAt(idx)) {
                    idx++;
                }
                prefix = prefix.substring(0, idx);
            }
            if (prefix.length() == 0) {
                break;
            }
        }
        if (prefix == null) {
            return "";
        }
        return prefix;
    }

    private static String normalizeEpc(String epc) {
        if (epc == null) {
            return "";
        }
        return epc.replaceAll("\\s+", "").toUpperCase();
    }

    private static byte[] hexStringToByteArray(String s) {
        if ((s.length() & 1) != 0) {
            throw new IllegalArgumentException("Hex string must have even number of characters");
        }
        byte[] out = new byte[s.length() / 2];
        for (int i = 0; i < s.length(); i += 2) {
            int hi = Character.digit(s.charAt(i), 16);
            int lo = Character.digit(s.charAt(i + 1), 16);
            if (hi < 0 || lo < 0) {
                throw new IllegalArgumentException("Invalid hex at position " + i);
            }
            out[i / 2] = (byte) ((hi << 4) + lo);
        }
        return out;
    }

    private void shutdown() {
        if (!running) {
            return;
        }
        running = false;

        if (evaluator != null) {
            evaluator.shutdownNow();
        }

        if (readerConnected) {
            try {
                reader.Actions.Inventory.stop();
            } catch (Exception ex) {
            }

            inventoryStopLock.lock();
            try {
                if (!inventoryStopped) {
                    inventoryStoppedCond.awaitNanos(2000000000L);
                }
            } catch (InterruptedException ie) {
                Thread.currentThread().interrupt();
            } finally {
                inventoryStopLock.unlock();
            }

            try {
                reader.disconnect();
            } catch (Exception ex) {
            }
        }

        if (mqttClient != null) {
            try {
                if (mqttClient.isConnected()) {
                    mqttClient.disconnect();
                }
                mqttClient.close();
            } catch (Exception ex) {
            }
        }
        System.out.println("RFIDTourAggregator stopped.");
    }

    private class EventsHandler implements RfidEventsListener {

        public void eventReadNotify(RfidReadEvents rre) {
            onTags();
        }

        public void eventStatusNotify(RfidStatusEvents rse) {
            STATUS_EVENT_TYPE type = rse.StatusEventData.getStatusEventType();
            if (type == STATUS_EVENT_TYPE.INVENTORY_STOP_EVENT) {
                inventoryStopLock.lock();
                try {
                    inventoryStopped = true;
                    inventoryStoppedCond.signalAll();
                } finally {
                    inventoryStopLock.unlock();
                }
            }
        }
    }

    private static class AggregationKey {
        private final String siteId;
        private final String readerId;
        private final int antennaId;
        private final String tourId;

        private AggregationKey(String siteId, String readerId, int antennaId, String tourId) {
            this.siteId = siteId;
            this.readerId = readerId;
            this.antennaId = antennaId;
            this.tourId = tourId;
        }

        public int hashCode() {
            int result = 17;
            result = 31 * result + siteId.hashCode();
            result = 31 * result + readerId.hashCode();
            result = 31 * result + antennaId;
            result = 31 * result + tourId.hashCode();
            return result;
        }

        public boolean equals(Object obj) {
            if (this == obj) {
                return true;
            }
            if (!(obj instanceof AggregationKey)) {
                return false;
            }
            AggregationKey other = (AggregationKey) obj;
            return antennaId == other.antennaId
                    && siteId.equals(other.siteId)
                    && readerId.equals(other.readerId)
                    && tourId.equals(other.tourId);
        }
    }

    private static class Bucket {
        private final long epochSec;
        private long readCount;
        private long rssiSum;

        private Bucket(long epochSec) {
            this.epochSec = epochSec;
        }
    }

    private static class Evaluation {
        private boolean shouldEmit;
        private boolean isIdle;
        private String epc;
        private long windowStartSec;
        private long windowEndSec;
        private long windowReadCount;
        private long uniqueTagCount;
        private double windowAvgRssi;
        private double baselineReadCount;
        private double baselineAvgRssi;
        private double countDropPct;
        private double rssiDropDb;
        private long secondsSinceLastRead;
        private long dwellSeconds;
        private long minDwellSeconds;
    }

    private static class RollingAggregation {
        private final LinkedList<Bucket> buckets = new LinkedList<Bucket>();
        private final Map<String, Long> tagLastSeenSec = new HashMap<String, Long>();
        private double baselineReadCount = -1.0;
        private double baselineAvgRssi = -999.0;
        private boolean emittedForCurrentIdle;
        private long firstSeenSec = -1L;

        public synchronized void record(String epc, int rssi, long nowSec, int windowSeconds) {
            pruneOld(nowSec, windowSeconds);
            if (firstSeenSec < 0L) {
                firstSeenSec = nowSec;
            }

            Bucket bucket;
            if (buckets.isEmpty() || buckets.getLast().epochSec != nowSec) {
                bucket = new Bucket(nowSec);
                buckets.add(bucket);
            } else {
                bucket = buckets.getLast();
            }

            bucket.readCount++;
            bucket.rssiSum += rssi;
            tagLastSeenSec.put(epc, new Long(nowSec));
            emittedForCurrentIdle = false;
        }

        public synchronized Evaluation evaluate(
                long nowSec,
                int windowSeconds,
                int secondsSinceLastRead,
                int minDwellSeconds) {
            pruneOld(nowSec, windowSeconds);
            cleanupTagSet(nowSec - windowSeconds + 1);

            long windowReads = 0L;
            long rssiSum = 0L;
            for (int i = 0; i < buckets.size(); i++) {
                Bucket b = buckets.get(i);
                windowReads += b.readCount;
                rssiSum += b.rssiSum;
            }

            double avgRssi = windowReads > 0 ? ((double) rssiSum / (double) windowReads) : -120.0;

            if (baselineReadCount < 0.0) {
                baselineReadCount = windowReads;
            }
            if (baselineAvgRssi < -300.0) {
                baselineAvgRssi = avgRssi;
            }

            double countDropPct = 0.0;
            if (baselineReadCount > 0.0) {
                countDropPct = ((baselineReadCount - (double) windowReads) / baselineReadCount) * 100.0;
            }
            double rssiDropDb = baselineAvgRssi - avgRssi;
            long dwellSeconds = firstSeenSec > 0L ? (nowSec - firstSeenSec + 1L) : 0L;
            boolean dwellGateMet = dwellSeconds >= minDwellSeconds;
            long lastSeen = lastSeenSec();
            long secondsSinceLastReadActual = lastSeen > 0L ? (nowSec - lastSeen) : nowSec;

            boolean shouldEmit =
                    dwellGateMet
                            && secondsSinceLastReadActual >= secondsSinceLastRead
                            && !emittedForCurrentIdle;

            Evaluation eval = new Evaluation();
            List<String> epcs = new ArrayList<String>(tagLastSeenSec.keySet());
            Collections.sort(epcs);
            eval.windowEndSec = nowSec;
            eval.windowStartSec = nowSec - windowSeconds + 1;
            eval.windowReadCount = windowReads;
            eval.uniqueTagCount = tagLastSeenSec.size();
            eval.epc = epcs.isEmpty() ? "" : (String) epcs.get(0);
            eval.windowAvgRssi = avgRssi;
            eval.baselineReadCount = baselineReadCount;
            eval.baselineAvgRssi = baselineAvgRssi;
            eval.countDropPct = countDropPct;
            eval.rssiDropDb = rssiDropDb;
            eval.secondsSinceLastRead = secondsSinceLastReadActual;
            eval.dwellSeconds = dwellSeconds;
            eval.minDwellSeconds = minDwellSeconds;
            eval.isIdle = windowReads == 0L && (nowSec - lastSeen) > windowSeconds;
            eval.shouldEmit = shouldEmit;
            if (shouldEmit) {
                emittedForCurrentIdle = true;
            }

            double alpha = 0.10;
            baselineReadCount = baselineReadCount * (1.0 - alpha) + ((double) windowReads) * alpha;
            if (windowReads > 0) {
                baselineAvgRssi = baselineAvgRssi * (1.0 - alpha) + avgRssi * alpha;
            }

            return eval;
        }

        private long lastSeenSec() {
            if (buckets.isEmpty()) {
                return 0L;
            }
            return buckets.getLast().epochSec;
        }

        private void pruneOld(long nowSec, int windowSeconds) {
            long cutoff = nowSec - windowSeconds + 1;
            while (!buckets.isEmpty() && buckets.getFirst().epochSec < cutoff) {
                buckets.removeFirst();
            }
        }

        private void cleanupTagSet(long cutoffSec) {
            Iterator<Map.Entry<String, Long>> it = tagLastSeenSec.entrySet().iterator();
            while (it.hasNext()) {
                Map.Entry<String, Long> e = it.next();
                if (e.getValue().longValue() < cutoffSec) {
                    it.remove();
                }
            }
        }
    }

    private static class AppConfig {
        private String host;
        private int port;
        private String epcMapCsv;
        private String defaultTourId;
        private long runMs;

        private String siteId;
        private String readerId;

        private int windowSeconds;
        private int checkSeconds;
        private int secondsSinceLastRead;
        private int minDwellSeconds;

        private String mqttBrokerUrl;
        private String mqttClientId;
        private String mqttTopicRoot;
        private String mqttUsername;
        private String mqttPassword;
        private boolean logReads;
        private boolean logUnknownReads;
        private Map<Integer, Short> perAntennaTransmitPowerIndex;

        private static AppConfig fromArgs(String[] args) {
            if (args.length == 0) {
                File defaultConfig = new File("tour-aggregator.properties");
                if (defaultConfig.exists() && defaultConfig.isFile()) {
                    return fromConfigFile(defaultConfig.getPath());
                }
                printUsage();
                throw new IllegalArgumentException("No args provided and no tour-aggregator.properties found");
            }

            if ("--config".equals(args[0])) {
                if (args.length < 2) {
                    printUsage();
                    throw new IllegalArgumentException("Missing config file path after --config");
                }
                return fromConfigFile(args[1]);
            }

            if (args.length == 1) {
                File cfgFile = new File(args[0]);
                if (cfgFile.exists() && cfgFile.isFile()) {
                    return fromConfigFile(cfgFile.getPath());
                }
            }

            if (args.length < 5) {
                printUsage();
                throw new IllegalArgumentException("Expected at least 5 arguments");
            }

            AppConfig cfg = new AppConfig();
            cfg.host = args[0];
            cfg.port = Integer.parseInt(args[1]);
            cfg.mqttBrokerUrl = args[2];
            cfg.mqttTopicRoot = args[3];
            cfg.epcMapCsv = args[4];

            cfg.defaultTourId = args.length > 5 ? args[5] : "tour-default";
            cfg.runMs = args.length > 6 ? Long.parseLong(args[6]) : 0L;

            cfg.secondsSinceLastRead = args.length > 7 ? Integer.parseInt(args[7]) : 5;
            cfg.minDwellSeconds = args.length > 8 ? Integer.parseInt(args[8]) : 0;

            cfg.windowSeconds = args.length > 9 ? Integer.parseInt(args[9]) : 60;
            cfg.checkSeconds = args.length > 10 ? Integer.parseInt(args[10]) : 1;

            cfg.siteId = args.length > 11 ? args[11] : "rfid-lab";
            cfg.readerId = args.length > 12 ? args[12] : (cfg.host + ":" + cfg.port);
            cfg.mqttClientId = args.length > 13 ? args[13] : "";
            cfg.mqttUsername = args.length > 14 ? args[14] : "";
            cfg.mqttPassword = args.length > 15 ? args[15] : "";
            cfg.logReads = args.length > 16 && parseBooleanArg(args[16]);
            cfg.logUnknownReads = args.length > 17 && parseBooleanArg(args[17]);
            cfg.perAntennaTransmitPowerIndex = new HashMap<Integer, Short>();

            return cfg;
        }

        private static AppConfig fromConfigFile(String path) {
            Properties props = new Properties();
            FileInputStream in = null;
            try {
                in = new FileInputStream(path);
                props.load(in);
            } catch (Exception ex) {
                throw new IllegalArgumentException("Failed to load config file " + path + ": " + ex.getMessage());
            } finally {
                if (in != null) {
                    try {
                        in.close();
                    } catch (IOException ioe) {
                    }
                }
            }

            AppConfig cfg = new AppConfig();
            cfg.host = getRequired(props, "host");
            cfg.port = parseInt(getOptional(props, "port", "5084"));
            cfg.mqttBrokerUrl = getRequired(props, "mqtt.brokerUrl");
            cfg.mqttTopicRoot = getOptional(props, "mqtt.topicRoot", "rfid");
            cfg.epcMapCsv = getRequired(props, "epc.mapCsv");
            cfg.defaultTourId = getOptional(props, "defaultTourId", "tour-default");
            cfg.runMs = parseLong(getOptional(props, "runMs", "0"));

            cfg.secondsSinceLastRead = parseInt(getOptional(props, "trigger.secondsSinceLastRead", "5"));
            cfg.minDwellSeconds = parseInt(getOptional(props, "trigger.minDwellSeconds", "20"));

            cfg.windowSeconds = parseInt(getOptional(props, "window.seconds", "60"));
            cfg.checkSeconds = parseInt(getOptional(props, "window.checkSeconds", "1"));

            cfg.siteId = getOptional(props, "siteId", "rfid-lab");
            cfg.readerId = getOptional(props, "readerId", cfg.host + ":" + cfg.port);

            cfg.mqttClientId = getOptional(props, "mqtt.clientId", "");
            cfg.mqttUsername = getOptional(props, "mqtt.username", "");
            cfg.mqttPassword = getOptional(props, "mqtt.password", "");

            cfg.logReads = parseBooleanArg(getOptional(props, "debug.logReads", "false"));
            cfg.logUnknownReads = parseBooleanArg(getOptional(props, "debug.logUnknownReads", "false"));

            cfg.perAntennaTransmitPowerIndex = new HashMap<Integer, Short>();
            String prefix = "antenna.txPowerIndex.";
            Iterator<?> names = props.keySet().iterator();
            while (names.hasNext()) {
                Object keyObj = names.next();
                String key = keyObj == null ? "" : keyObj.toString();
                if (!key.startsWith(prefix)) {
                    continue;
                }
                String antennaPart = key.substring(prefix.length()).trim();
                if (antennaPart.length() == 0) {
                    continue;
                }
                int antennaId;
                try {
                    antennaId = parseInt(antennaPart);
                } catch (NumberFormatException nfe) {
                    continue;
                }
                String value = getOptional(props, key, "");
                Short txIndex = parseOptionalShort(value);
                if (txIndex != null) {
                    cfg.perAntennaTransmitPowerIndex.put(Integer.valueOf(antennaId), txIndex);
                }
            }
            return cfg;
        }

        private static String getRequired(Properties props, String key) {
            String value = props.getProperty(key);
            if (value == null || value.trim().length() == 0) {
                throw new IllegalArgumentException("Missing required config key: " + key);
            }
            return value.trim();
        }

        private static String getOptional(Properties props, String key, String defaultValue) {
            String value = props.getProperty(key);
            if (value == null) {
                return defaultValue;
            }
            return value.trim();
        }

        private static int parseInt(String value) {
            return Integer.parseInt(value);
        }

        private static long parseLong(String value) {
            return Long.parseLong(value);
        }

        private static double parseDouble(String value) {
            return Double.parseDouble(value);
        }

        private static Short parseOptionalShort(String value) {
            if (value == null) {
                return null;
            }
            String v = value.trim();
            if (v.length() == 0) {
                return null;
            }
            return Short.valueOf(Short.parseShort(v));
        }

        private static boolean parseBooleanArg(String value) {
            if (value == null) {
                return false;
            }
            String v = value.trim().toLowerCase();
            return "1".equals(v)
                    || "true".equals(v)
                    || "t".equals(v)
                    || "yes".equals(v)
                    || "y".equals(v)
                    || "on".equals(v);
        }

        private static void printUsage() {
            System.err.println(
                    "Usage: RFIDTourAggregator HOST PORT MQTT_BROKER_URL MQTT_TOPIC_ROOT EPC_TOUR_CSV "
                            + "[DEFAULT_TOUR_ID] [RUN_MS] [SECONDS_SINCE_LAST_READ] [MIN_DWELL_SEC] [WINDOW_SEC] [CHECK_SEC] [SITE_ID] [READER_ID] [MQTT_CLIENT_ID] [MQTT_USER] [MQTT_PASS] "
                            + "[LOG_READS] [LOG_UNKNOWN_READS]");
            System.err.println("Config mode: RFIDTourAggregator --config /path/to/tour-aggregator.properties");
            System.err.println("  Exact EPC matching only. Unknown EPCs are ignored.");
            System.err.println("  CSV format: EPC,TOUR_ID");
            System.err.println("  If CSV is missing/empty, built-in fallback EPCs are used.");
            System.err.println("  LOG_READS/LOG_UNKNOWN_READS accepted true|false|1|0|yes|no.");
        }
    }
}
