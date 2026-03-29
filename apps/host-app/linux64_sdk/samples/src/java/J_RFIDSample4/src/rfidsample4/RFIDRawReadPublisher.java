package rfidsample4;

import com.mot.rfid.api3.AntennaInfo;
import com.mot.rfid.api3.Antennas;
import com.mot.rfid.api3.InvalidUsageException;
import com.mot.rfid.api3.OperationFailureException;
import com.mot.rfid.api3.RFIDReader;
import com.mot.rfid.api3.RfidEventsListener;
import com.mot.rfid.api3.RfidReadEvents;
import com.mot.rfid.api3.RfidStatusEvents;
import com.mot.rfid.api3.STATUS_EVENT_TYPE;
import com.mot.rfid.api3.START_TRIGGER_TYPE;
import com.mot.rfid.api3.STOP_TRIGGER_TYPE;
import com.mot.rfid.api3.SYSTEMTIME;
import com.mot.rfid.api3.TAG_EVENT_REPORT_TRIGGER;
import com.mot.rfid.api3.TAG_FIELD;
import com.mot.rfid.api3.TagData;
import com.mot.rfid.api3.TagStorageSettings;
import com.mot.rfid.api3.TRACE_LEVEL;
import com.mot.rfid.api3.TriggerInfo;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicLong;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

public class RFIDRawReadPublisher {

    private final RFIDReader reader = new RFIDReader();
    private final Lock inventoryStopLock = new ReentrantLock();
    private final Condition inventoryStoppedCond = inventoryStopLock.newCondition();
    private final AtomicLong publishCount = new AtomicLong(0L);
    private final AtomicLong filteredCount = new AtomicLong(0L);
    private final AtomicLong publishErrorCount = new AtomicLong(0L);

    private volatile boolean running;
    private volatile boolean readerConnected;
    private volatile boolean inventoryStopped;

    private AppConfig config;
    private MqttClient mqttClient;
    private short[] activeAntennas;

    public static void main(String[] args) throws Exception {
        AppConfig cfg = AppConfig.fromArgs(args);
        RFIDRawReadPublisher app = new RFIDRawReadPublisher();
        app.start(cfg);
    }

    private void start(AppConfig cfg) throws Exception {
        this.config = cfg;

        connectMqtt();
        connectReader();

        Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
            public void run() {
                shutdown();
            }
        }));

        short[] availableAntennas = reader.Config.Antennas.getAvailableAntennas();
        if (availableAntennas == null || availableAntennas.length == 0) {
            throw new IllegalStateException("Reader reported no available antennas");
        }

        activeAntennas = configureEnabledAntennas(availableAntennas);
        if (activeAntennas.length == 0) {
            throw new IllegalStateException("No active antennas found after filtering to configured antennas.");
        }

        reader.Actions.purgeTags();
        TriggerInfo triggerInfo = defaultTriggerInfo();
        AntennaInfo antennaInfo = new AntennaInfo(activeAntennas);

        running = true;
        inventoryStopped = false;
        reader.Actions.Inventory.perform(null, triggerInfo, antennaInfo);
        System.out.println("Inventory started on antennas " + Arrays.toString(activeAntennas));

        long lastLogAt = System.currentTimeMillis();
        long startAt = lastLogAt;
        while (running) {
            Thread.sleep(250L);
            long now = System.currentTimeMillis();
            if ((now - lastLogAt) >= 5000L) {
                System.out.println(
                        "stats published="
                                + publishCount.get()
                                + " filtered="
                                + filteredCount.get()
                                + " publish_errors="
                                + publishErrorCount.get());
                lastLogAt = now;
            }
            if (config.runMs > 0L && (now - startAt) >= config.runMs) {
                shutdown();
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
        storage.setTagFields(new TAG_FIELD[] {
            TAG_FIELD.ANTENNA_ID,
            TAG_FIELD.PEAK_RSSI,
            TAG_FIELD.CHANNEL_INDEX,
            TAG_FIELD.PHASE_INFO,
            TAG_FIELD.TAG_SEEN_COUNT,
            TAG_FIELD.LAST_SEEN_TIME_STAMP
        });
        storage.discardTagsOnInventoryStop(true);
        reader.Config.setTagStorageSettings(storage);
        reader.Config.setTraceLevel(TRACE_LEVEL.TRACE_LEVEL_ERROR);

        System.out.println("Connected reader " + config.host + ":" + config.port);
    }

    private void connectMqtt() throws MqttException {
        String clientId = config.mqttClientId;
        if (clientId == null || clientId.length() == 0) {
            clientId = "rfid-raw-" + UUID.randomUUID().toString();
        }

        mqttClient = new MqttClient(config.mqttBrokerUrl, clientId);
        MqttConnectOptions options = new MqttConnectOptions();
        options.setCleanSession(true);
        options.setAutomaticReconnect(true);
        if (config.mqttUsername != null && config.mqttUsername.length() > 0) {
            options.setUserName(config.mqttUsername);
        }
        if (config.mqttPassword != null && config.mqttPassword.length() > 0) {
            options.setPassword(config.mqttPassword.toCharArray());
        }
        mqttClient.connect(options);
        System.out.println("Connected MQTT " + config.mqttBrokerUrl + " as " + clientId);
    }

    private TriggerInfo defaultTriggerInfo() throws InvalidUsageException {
        TriggerInfo t = new TriggerInfo();
        t.StartTrigger.setTriggerType(START_TRIGGER_TYPE.START_TRIGGER_TYPE_IMMEDIATE);
        t.StopTrigger.setTriggerType(STOP_TRIGGER_TYPE.STOP_TRIGGER_TYPE_IMMEDIATE);
        t.TagEventReportInfo.setReportNewTagEvent(TAG_EVENT_REPORT_TRIGGER.MODERATED);
        t.TagEventReportInfo.setNewTagEventModeratedTimeoutMilliseconds((short) 250);
        t.TagEventReportInfo.setReportTagInvisibleEvent(TAG_EVENT_REPORT_TRIGGER.MODERATED);
        t.TagEventReportInfo.setTagInvisibleEventModeratedTimeoutMilliseconds((short) 250);
        t.TagEventReportInfo.setReportTagBackToVisibilityEvent(TAG_EVENT_REPORT_TRIGGER.MODERATED);
        t.TagEventReportInfo.setTagBackToVisibilityModeratedTimeoutMilliseconds((short) 250);
        t.setTagReportTrigger(1);
        return t;
    }

    private short[] configureEnabledAntennas(short[] available)
            throws InvalidUsageException, OperationFailureException {
        List<Short> enabled = new ArrayList<Short>();
        for (int i = 0; i < available.length; i++) {
            int antennaId = available[i] & 0xFFFF;
            if (!config.enabledAntennaSet.contains(Integer.valueOf(antennaId))) {
                continue;
            }

            Antennas.Config antennaCfg = reader.Config.Antennas.getAntennaConfig(antennaId);
            Short txIndex = config.perAntennaTransmitPowerIndex.get(Integer.valueOf(antennaId));
            if (txIndex != null) {
                antennaCfg.setTransmitPowerIndex(txIndex.shortValue());
                reader.Config.Antennas.setAntennaConfig(antennaId, antennaCfg);
                System.out.println("Applied tx_power_index antenna=" + antennaId + " value=" + txIndex);
            } else {
                System.out.println("No tx_power_index configured for antenna=" + antennaId + ", using reader default.");
            }
            enabled.add(Short.valueOf((short) antennaId));
        }

        short[] active = new short[enabled.size()];
        for (int i = 0; i < enabled.size(); i++) {
            active[i] = enabled.get(i).shortValue();
        }
        return active;
    }

    private void onTags() {
        TagData[] tags = reader.Actions.getReadTags(200);
        if (tags == null || tags.length == 0) {
            return;
        }

        for (int i = 0; i < tags.length; i++) {
            TagData tag = tags[i];
            int antennaId = tag.getAntennaID() & 0xFFFF;
            if (!config.enabledAntennaSet.contains(Integer.valueOf(antennaId))) {
                filteredCount.incrementAndGet();
                continue;
            }

            long tsHostMs = System.currentTimeMillis();
            long tsReaderMs = resolveReaderTimestampMs(tag, tsHostMs);
            short phaseRaw = tag.getPhase();
            double phaseDeg = (180.0 / 32767.0) * (double) phaseRaw;
            String epc = normalizeEpc(tag.getTagID());

            String payload =
                    toJsonPayload(
                            UUID.randomUUID().toString(),
                            config.sourceId,
                            tsHostMs,
                            tsReaderMs,
                            config.readerId,
                            antennaId,
                            epc,
                            tag.getPeakRSSI(),
                            phaseRaw,
                            phaseDeg,
                            tag.getChannelIndex(),
                            tag.getTagSeenCount(),
                            resolveTxPowerIndex(antennaId));

            String topic = "rfid/" + sanitizeTopicToken(config.readerId) + "/antenna/" + antennaId + "/raw-read";
            publish(topic, payload);
        }
    }

    private void publish(String topic, String payload) {
        try {
            ensureMqttConnected();
            MqttMessage message = new MqttMessage(payload.getBytes("UTF-8"));
            message.setQos(1);
            message.setRetained(false);
            mqttClient.publish(topic, message);
            publishCount.incrementAndGet();
        } catch (Exception ex) {
            publishErrorCount.incrementAndGet();
            System.err.println("MQTT publish failed topic=" + topic + " error=" + ex.getMessage());
        }
    }

    private void ensureMqttConnected() throws MqttException {
        if (mqttClient != null && mqttClient.isConnected()) {
            return;
        }
        connectMqtt();
    }

    private short resolveTxPowerIndex(int antennaId) {
        Short configured = config.perAntennaTransmitPowerIndex.get(Integer.valueOf(antennaId));
        if (configured != null) {
            return configured.shortValue();
        }
        try {
            Antennas.Config antennaCfg = reader.Config.Antennas.getAntennaConfig(antennaId);
            return antennaCfg.getTransmitPowerIndex();
        } catch (Exception ex) {
            return (short) 0;
        }
    }

    private long resolveReaderTimestampMs(TagData tag, long fallback) {
        try {
            if (tag != null && tag.SeenTime != null && tag.SeenTime.getUpTime() != null) {
                long upTime = tag.SeenTime.getUpTime().getLastSeenTimeStamp();
                if (upTime > 0L) {
                    return upTime;
                }
            }
        } catch (Exception ex) {
        }

        try {
            SYSTEMTIME st = tag.getTagEventTimeStamp();
            if (st != null && st.Year > 2000) {
                Calendar cal = Calendar.getInstance();
                cal.set(Calendar.YEAR, st.Year);
                cal.set(Calendar.MONTH, st.Month - 1);
                cal.set(Calendar.DAY_OF_MONTH, st.Day);
                cal.set(Calendar.HOUR_OF_DAY, st.Hour);
                cal.set(Calendar.MINUTE, st.Minute);
                cal.set(Calendar.SECOND, st.Second);
                cal.set(Calendar.MILLISECOND, st.Milliseconds);
                return cal.getTimeInMillis();
            }
        } catch (Exception ex) {
        }

        return fallback;
    }

    private String toJsonPayload(
            String msgId,
            String sourceId,
            long tsHostMs,
            long tsReaderMs,
            String readerId,
            int antennaId,
            String epc,
            int rssi,
            int phaseRaw,
            double phaseDeg,
            int channelIndex,
            int tagSeenCount,
            int txPowerIndex) {
        StringBuilder sb = new StringBuilder(320);
        sb.append('{');
        appendJsonField(sb, "msg_id", msgId, true);
        appendJsonField(sb, "source_id", sourceId, true);
        appendJsonNumber(sb, "ts_host_ms", tsHostMs, true);
        appendJsonNumber(sb, "ts_reader_ms", tsReaderMs, true);
        appendJsonField(sb, "reader_id", readerId, true);
        appendJsonNumber(sb, "antenna_id", antennaId, true);
        appendJsonField(sb, "epc", epc, true);
        appendJsonNumber(sb, "rssi", rssi, true);
        appendJsonNumber(sb, "phase_raw", phaseRaw, true);
        appendJsonNumber(sb, "phase_deg", phaseDeg, true);
        appendJsonNumber(sb, "channel_index", channelIndex, true);
        appendJsonNumber(sb, "tag_seen_count", tagSeenCount, true);
        appendJsonNumber(sb, "tx_power_index", txPowerIndex, false);
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

    private void appendJsonNumber(StringBuilder sb, String key, long value, boolean comma) {
        sb.append('"').append(escapeJson(key)).append('"').append(':').append(value);
        if (comma) {
            sb.append(',');
        }
    }

    private void appendJsonNumber(StringBuilder sb, String key, double value, boolean comma) {
        sb.append('"').append(escapeJson(key)).append('"').append(':');
        sb.append(String.format(java.util.Locale.US, "%.3f", value));
        if (comma) {
            sb.append(',');
        }
    }

    private String sanitizeTopicToken(String token) {
        if (token == null || token.length() == 0) {
            return "unknown";
        }
        return token.replace('+', '_').replace('#', '_').replace('/', '_');
    }

    private static String normalizeEpc(String epc) {
        if (epc == null) {
            return "";
        }
        return epc.replaceAll("\\s+", "").toUpperCase();
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

    private void shutdown() {
        if (!running) {
            return;
        }
        running = false;

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

        System.out.println(
                "RFIDRawReadPublisher stopped. published="
                        + publishCount.get()
                        + " filtered="
                        + filteredCount.get()
                        + " publish_errors="
                        + publishErrorCount.get());
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

    private static class AppConfig {
        private String host;
        private int port;
        private String readerId;
        private String sourceId;
        private String mqttBrokerUrl;
        private String mqttClientId;
        private String mqttUsername;
        private String mqttPassword;
        private long runMs;
        private List<Integer> enabledAntennaSet;
        private Map<Integer, Short> perAntennaTransmitPowerIndex;

        private static AppConfig fromArgs(String[] args) {
            if (args.length == 0) {
                File defaultConfig = new File("raw-read-publisher.properties");
                if (defaultConfig.exists() && defaultConfig.isFile()) {
                    return fromConfigFile(defaultConfig.getPath());
                }
                printUsage();
                throw new IllegalArgumentException("No args provided and no raw-read-publisher.properties found");
            }

            if ("--config".equals(args[0])) {
                if (args.length < 2) {
                    throw new IllegalArgumentException("Missing config file path after --config");
                }
                return fromConfigFile(args[1]);
            }

            if (args.length == 1) {
                File configFile = new File(args[0]);
                if (configFile.exists() && configFile.isFile()) {
                    return fromConfigFile(configFile.getPath());
                }
            }

            printUsage();
            throw new IllegalArgumentException("Expected --config <path> or a config file path");
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
            cfg.readerId = getOptional(props, "reader.id", "reader-1");
            cfg.sourceId = getOptional(props, "source.id", "reader1-raw-v1");

            cfg.mqttBrokerUrl = getRequired(props, "mqtt.brokerUrl");
            cfg.mqttClientId = getOptional(props, "mqtt.clientId", "");
            cfg.mqttUsername = getOptional(props, "mqtt.username", "");
            cfg.mqttPassword = getOptional(props, "mqtt.password", "");

            cfg.runMs = parseLong(getOptional(props, "runMs", "0"));

            cfg.enabledAntennaSet = parseAntennaList(getOptional(props, "antennas.enabled", "1,2"));
            if (cfg.enabledAntennaSet.isEmpty()) {
                throw new IllegalArgumentException("antennas.enabled must contain at least one antenna ID");
            }

            cfg.perAntennaTransmitPowerIndex = new HashMap<Integer, Short>();
            String prefix = "antenna.txPowerIndex.";
            for (Object keyObj : props.keySet()) {
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
                    antennaId = Integer.parseInt(antennaPart);
                } catch (NumberFormatException ex) {
                    continue;
                }
                Short txIndex = parseOptionalShort(getOptional(props, key, ""));
                if (txIndex != null) {
                    cfg.perAntennaTransmitPowerIndex.put(Integer.valueOf(antennaId), txIndex);
                }
            }
            return cfg;
        }

        private static List<Integer> parseAntennaList(String value) {
            List<Integer> out = new ArrayList<Integer>();
            if (value == null || value.trim().length() == 0) {
                return out;
            }
            String[] parts = value.split(",");
            for (int i = 0; i < parts.length; i++) {
                String p = parts[i].trim();
                if (p.length() == 0) {
                    continue;
                }
                int antennaId = Integer.parseInt(p);
                Integer boxed = Integer.valueOf(antennaId);
                if (!out.contains(boxed)) {
                    out.add(boxed);
                }
            }
            return out;
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

        private static void printUsage() {
            System.err.println(
                    "Usage: RFIDRawReadPublisher --config /path/to/raw-read-publisher.properties");
        }
    }
}
