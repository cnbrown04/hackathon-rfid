import com.mot.rfid.api3.*;
import com.mot.rfid.api3.Antennas.Config;
import com.mot.rfid.api3.Antennas.SingulationControl;
import com.mot.rfid.api3.PreFilters.PreFilter;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.concurrent.locks.Condition;
import java.util.concurrent.locks.Lock;
import java.util.concurrent.locks.ReentrantLock;

/**
 * Inventory with pre-filters matching RFIDSample4.AddPreFilter / PreFilterDlg apply flow.
 *
 * <p>Gen2 pre-filter with SELECT only affects which tags have SL asserted; inventory must use
 * <b>state-aware singulation</b> with {@link SL_FLAG#SL_FLAG_ASSERTED} so only those tags reply.
 * That pairing is configured in {@link SingulationDlg} in J_RFIDHostSample1 — we apply the same
 * defaults here when using SELECT-style actions (0 or 1), unless {@code --no-sl-singulation} is
 * passed.
 *
 * <p><b>Post-filter:</b> {@code RFIDBase.startRead} passes a non-null {@link PostFilter} into
 * {@code Inventory.perform(postFilter, ...)}. That filters <em>which tag reports</em> the reader sends.
 * Air-side pre-filters alone are not always enough on every firmware; we build the same {@link PostFilter}
 * as {@code PostFilterDialog} (pattern A + mask, {@link FILTER_MATCH_PATTERN#A}) unless you pass
 * {@code --no-post-filter}.
 *
 * <p><b>TX power:</b> optional {@code --tx-power-index=N} (same index as AntennaConfigDlg /
 * RFIDSample4 {@code setTransmitPowerIndex}). Run {@code HOST PORT --list-tx-power} to print the table.
 *
 * <p>Compile/run: prefilter-read/run.sh
 */
public class PrefilterRead {

    private final RFIDReader reader = new RFIDReader();
    private final Lock inventoryStopLock = new ReentrantLock();
    private final Condition inventoryStopped = inventoryStopLock.newCondition();
    private volatile boolean inventoryComplete;

    public static void main(String[] args) throws Exception {
        List<String> argList = new ArrayList<>(Arrays.asList(args));
        boolean applySlSingulation = !argList.remove("--no-sl-singulation");
        boolean usePostFilter = !argList.remove("--no-post-filter");
        boolean listTxPower = argList.remove("--list-tx-power");

        Integer txPowerIndex = null;
        for (int i = argList.size() - 1; i >= 0; i--) {
            String s = argList.get(i);
            if (s.startsWith("--tx-power-index=")) {
                txPowerIndex = Integer.parseInt(s.substring("--tx-power-index=".length()));
                argList.remove(i);
            }
        }

        String[] argv = argList.toArray(new String[0]);

        if (listTxPower) {
            if (argv.length != 2) {
                System.err.println("Usage: PrefilterRead HOST PORT --list-tx-power");
                System.err.println("  Prints transmit power table: index → centidBm (use index with --tx-power-index=).");
                System.exit(2);
            }
            listTransmitPowerTable(argv[0], Integer.parseInt(argv[1]));
            return;
        }

        if (argv.length < 6) {
            System.err.println(
                    "Usage: PrefilterRead HOST PORT MEM_BANK BIT_OFFSET PATTERN_HEX PATTERN_BITS [STATE_ACTION] [RUN_MS] [options]");
            System.err.println(
                    "  MEM_BANK: 1=EPC 2=TID 3=USER | STATE_ACTION 0-5 (default 1=SELECT) | RUN_MS default 10000");
            System.err.println(
                    "  Options: --no-sl-singulation  --no-post-filter  --tx-power-index=N");
            System.err.println(
                    "  --tx-power-index=N: set same transmit power index on all antennas (AntennaConfigDlg / RFIDSample4).");
            System.err.println("  HOST PORT --list-tx-power: print power index table for this reader.");
            System.exit(2);
        }

        String host = argv[0];
        int port = Integer.parseInt(argv[1]);
        int memBankIndex = Integer.parseInt(argv[2]);
        int bitOffset = Integer.parseInt(argv[3]);
        String patternHex = argv[4].replaceAll("\\s+", "");
        int patternBits = Integer.parseInt(argv[5]);
        int stateAction = argv.length > 6 ? Integer.parseInt(argv[6]) : 1;
        long runMs = argv.length > 7 ? Long.parseLong(argv[7]) : 10_000L;

        PrefilterRead app = new PrefilterRead();
        app.run(
                host,
                port,
                memBankIndex,
                bitOffset,
                patternHex,
                patternBits,
                stateAction,
                runMs,
                applySlSingulation,
                usePostFilter,
                txPowerIndex);
    }

    /** Print ReaderCapabilities.getTransmitPowerLevelValues() after connect (AntennaConfigDlg combo data). */
    private static void listTransmitPowerTable(String host, int port) throws Exception {
        RFIDReader r = new RFIDReader();
        r.setHostName(host);
        r.setPort(port);
        try {
            r.connect();
        } catch (OperationFailureException ex) {
            System.err.println("Connect failed: " + ex.getStatusDescription() + " | " + ex.getVendorMessage());
            System.exit(1);
            return;
        }
        try {
            int[] levels = r.ReaderCapabilities.getTransmitPowerLevelValues();
            System.out.println("Transmit power index → value (reader table; use index with --tx-power-index=N)");
            for (int i = 0; i < levels.length; i++) {
                System.out.println("  " + i + "\t" + levels[i]);
            }
        } finally {
            r.disconnect();
        }
    }

    /** RFIDSample4 SetAntennaConfig / AntennaConfigDlg: same {@link Config#setTransmitPowerIndex} on every antenna. */
    private void applyTransmitPowerIndex(short[] antennas, int index)
            throws InvalidUsageException, OperationFailureException {
        int[] levels = reader.ReaderCapabilities.getTransmitPowerLevelValues();
        if (index < 0 || index >= levels.length) {
            throw new IllegalArgumentException(
                    "tx-power-index " + index + " out of range [0," + (levels.length - 1) + "] — run with --list-tx-power");
        }
        for (short ant : antennas) {
            int antennaId = ant & 0xFFFF;
            Config antennaConfig = reader.Config.Antennas.getAntennaConfig(antennaId);
            antennaConfig.setTransmitPowerIndex((short) index);
            reader.Config.Antennas.setAntennaConfig(antennaId, antennaConfig);
        }
        System.err.println(
                "TransmitPowerIndex="
                        + index
                        + " (table value "
                        + levels[index]
                        + ") on antennas "
                        + Arrays.toString(antennas));
    }

    private void run(
            String host,
            int port,
            int memBankIndex,
            int bitOffset,
            String patternHex,
            int patternBits,
            int stateAction,
            long runMs,
            boolean applySlSingulation,
            boolean usePostFilter,
            Integer txPowerIndex)
            throws Exception {

        reader.setHostName(host);
        reader.setPort(port);
        try {
            reader.connect();
        } catch (OperationFailureException ex) {
            System.err.println(
                    "Connect failed to "
                            + host
                            + ":"
                            + port
                            + " — "
                            + ex.getStatusDescription()
                            + (ex.getVendorMessage() != null && !ex.getVendorMessage().isEmpty()
                                    ? (" | " + ex.getVendorMessage())
                                    : ""));
            System.err.println(
                    "Check reader power/IP, API port (often 5084), firewall, and that no other app holds the connection.");
            System.exit(1);
            return;
        } catch (InvalidUsageException ex) {
            String detail = ex.getInfo();
            if (detail == null || detail.isEmpty()) {
                detail = ex.getVendorMessage();
            }
            System.err.println("Connect failed (invalid usage): " + detail);
            System.exit(1);
            return;
        }

        reader.Events.setInventoryStartEvent(true);
        reader.Events.setInventoryStopEvent(true);
        reader.Events.setTagReadEvent(true);
        reader.Events.setAttachTagDataWithReadEvent(false);
        reader.Events.addEventsListener(new EventsHandler());

        TagStorageSettings tagStorageSettings = reader.Config.getTagStorageSettings();
        tagStorageSettings.discardTagsOnInventoryStop(true);
        reader.Config.setTagStorageSettings(tagStorageSettings);

        reader.Config.setTraceLevel(TRACE_LEVEL.TRACE_LEVEL_ERROR);

        short[] availableAntennas = reader.Config.Antennas.getAvailableAntennas();
        if (availableAntennas == null || availableAntennas.length == 0) {
            throw new IllegalStateException("Reader reported no available antennas");
        }

        if (txPowerIndex != null) {
            applyTransmitPowerIndex(availableAntennas, txPowerIndex);
        }

        int maxPreFilters = reader.ReaderCapabilities.getMaxNumPreFilters();
        if (availableAntennas.length > maxPreFilters) {
            throw new IllegalStateException(
                    "Reader has "
                            + availableAntennas.length
                            + " antennas but MaxNumPreFilters="
                            + maxPreFilters
                            + " — cannot attach one pre-filter per antenna");
        }

        byte[] patternBytes = hexStringToByteArray(patternHex);
        if (patternBits != patternBytes.length * 8) {
            System.err.println(
                    "Note: PATTERN_BITS ("
                            + patternBits
                            + ") != hex byte length*8 ("
                            + (patternBytes.length * 8)
                            + "); using your PATTERN_BITS as in RFIDSample4.");
        }

        MEMORY_BANK memoryBank = MEMORY_BANK.GetMemoryBankValue(memBankIndex);
        STATE_UNAWARE_ACTION unawareAction = stateUnawareAction(stateAction);

        // RFIDSample4.AddPreFilter + PreFilterDlg jButtonApply: deleteAll, then add each filter
        reader.Actions.PreFilters.deleteAll();
        PreFilters factory = new PreFilters();
        for (short antennaId : availableAntennas) {
            PreFilter preFilter = factory.new PreFilter();
            preFilter.setAntennaID(antennaId);
            preFilter.setMemoryBank(memoryBank);
            preFilter.setBitOffset(bitOffset);
            preFilter.setTagPattern(Arrays.copyOf(patternBytes, patternBytes.length));
            preFilter.setTagPatternBitCount(patternBits);
            preFilter.setFilterAction(FILTER_ACTION.FILTER_ACTION_STATE_UNAWARE);
            preFilter.StateUnawareAction.setStateUnawareAction(unawareAction);
            reader.Actions.PreFilters.add(preFilter);
        }

        int nPf = reader.Actions.PreFilters.length();
        System.err.println("PreFilters.length() after add: " + nPf + " (expected " + availableAntennas.length + ")");

        // J_RFIDHostSample1 SingulationDlg: SELECT pre-filter + inventory only matching tags needs
        // performStateAwareSingulationAction + SL_FLAG_ASSERTED (inventory state A is default in UI).
        if (applySlSingulation && slSingulationRecommended(stateAction)) {
            if (!reader.ReaderCapabilities.isTagInventoryStateAwareSingulationSupported()) {
                System.err.println(
                        "WARNING: Reader does not report state-aware singulation support — "
                                + "pre-filter may not narrow inventory. Try firmware / reader model.");
            } else {
                applySlAssertedSingulation(availableAntennas);
                System.err.println(
                        "Applied state-aware singulation: SL_ASSERTED, INVENTORY_STATE_A on antennas "
                                + Arrays.toString(availableAntennas)
                                + " (same as SingulationDlg with State Aware + ASSERTED).");
            }
        } else if (slSingulationRecommended(stateAction)) {
            System.err.println(
                    "WARNING: --no-sl-singulation — inventory may report all tags; "
                            + "RFIDSample4 console app also does not set singulation unless you configure it.");
        }

        // RFIDBase.startRead clears tag buffer before inventory
        reader.Actions.purgeTags();

        AntennaInfo antennaInfo = new AntennaInfo(availableAntennas);
        TriggerInfo triggerInfo = defaultTriggerInfo();

        PostFilter postFilter = null;
        if (usePostFilter) {
            postFilter = buildPostFilter(memoryBank, bitOffset, patternBytes, patternBits);
            System.err.println(
                    "PostFilter enabled (RFIDBase.startRead / PostFilterDialog): pattern A + mask, FILTER_MATCH_PATTERN.A.");
        } else {
            System.err.println(
                    "WARNING: --no-post-filter — reader may report every singulated tag even if pre-filter/singulation mismatch.");
        }

        System.out.println(
                "Connected to "
                        + host
                        + ":"
                        + port
                        + " — antennas "
                        + Arrays.toString(availableAntennas)
                        + " — filtered inventory "
                        + runMs
                        + " ms");

        inventoryComplete = false;
        reader.Actions.Inventory.perform(postFilter, triggerInfo, antennaInfo);

        long deadline = System.currentTimeMillis() + runMs;
        while (System.currentTimeMillis() < deadline) {
            Thread.sleep(200);
        }

        reader.Actions.Inventory.stop();

        inventoryStopLock.lock();
        try {
            if (!inventoryComplete) {
                inventoryStopped.awaitNanos(2_000_000_000L);
            }
        } finally {
            inventoryStopLock.unlock();
        }

        reader.disconnect();
        System.out.println("Done.");
    }

    /** SELECT / SELECT_NOT_UNSELECT assert SL on match — pair with SL_ASSERTED inventory (SingulationDlg). */
    private static boolean slSingulationRecommended(int stateAction) {
        return stateAction == 0 || stateAction == 1;
    }

    /** Same fields as PostFilterDialog.jButtonApplyActionPerformed for pattern A, FILTER_MATCH_PATTERN.A. */
    private static PostFilter buildPostFilter(
            MEMORY_BANK memoryBank, int bitOffset, byte[] patternBytes, int patternBits) {
        PostFilter postFilter = new PostFilter();
        TagPatternBase tagPatternA = new TagPatternBase();
        tagPatternA.setMemoryBank(memoryBank);
        tagPatternA.setBitOffset(bitOffset);
        tagPatternA.setTagPattern(Arrays.copyOf(patternBytes, patternBytes.length));
        byte[] maskBytes = new byte[patternBytes.length];
        Arrays.fill(maskBytes, (byte) 0xFF);
        tagPatternA.setTagMask(maskBytes);
        tagPatternA.setTagPatternBitCount(patternBits);
        tagPatternA.setTagMaskBitCount(patternBits);
        postFilter.TagPatternA = tagPatternA;
        postFilter.setPostFilterMatchPattern(FILTER_MATCH_PATTERN.A);
        return postFilter;
    }

    private void applySlAssertedSingulation(short[] antennas)
            throws InvalidUsageException, OperationFailureException {
        for (short ant : antennas) {
            int antennaId = ant & 0xFFFF;
            SingulationControl sc = reader.Config.Antennas.getSingulationControl(antennaId);
            sc.Action.setPerformStateAwareSingulationAction(true);
            sc.Action.setInventoryState(INVENTORY_STATE.INVENTORY_STATE_A);
            sc.Action.setSLFlag(SL_FLAG.SL_FLAG_ASSERTED);
            reader.Config.Antennas.setSingulationControl(antennaId, sc);
        }
    }

    private static TriggerInfo defaultTriggerInfo() throws InvalidUsageException {
        TriggerInfo triggerInfo = new TriggerInfo();
        triggerInfo.StartTrigger.setTriggerType(START_TRIGGER_TYPE.START_TRIGGER_TYPE_IMMEDIATE);
        triggerInfo.StopTrigger.setTriggerType(STOP_TRIGGER_TYPE.STOP_TRIGGER_TYPE_IMMEDIATE);
        triggerInfo.TagEventReportInfo.setReportNewTagEvent(TAG_EVENT_REPORT_TRIGGER.MODERATED);
        triggerInfo.TagEventReportInfo.setNewTagEventModeratedTimeoutMilliseconds((short) 500);
        triggerInfo.TagEventReportInfo.setReportTagInvisibleEvent(TAG_EVENT_REPORT_TRIGGER.MODERATED);
        triggerInfo.TagEventReportInfo.setTagInvisibleEventModeratedTimeoutMilliseconds((short) 500);
        triggerInfo.TagEventReportInfo.setReportTagBackToVisibilityEvent(TAG_EVENT_REPORT_TRIGGER.MODERATED);
        triggerInfo.TagEventReportInfo.setTagBackToVisibilityModeratedTimeoutMilliseconds((short) 500);
        triggerInfo.setTagReportTrigger(1);
        return triggerInfo;
    }

    private void onTags() {
        TagData[] tags = reader.Actions.getReadTags(100);
        if (tags == null) {
            return;
        }
        for (TagData tag : tags) {
            System.out.println(
                    "Tag: "
                            + tag.getTagID()
                            + "  antenna="
                            + tag.getAntennaID()
                            + "  rssi="
                            + tag.getPeakRSSI());
        }
    }

    private class EventsHandler implements RfidEventsListener {
        @Override
        public void eventReadNotify(RfidReadEvents rre) {
            onTags();
        }

        @Override
        public void eventStatusNotify(RfidStatusEvents rse) {
            STATUS_EVENT_TYPE t = rse.StatusEventData.getStatusEventType();
            if (t == STATUS_EVENT_TYPE.INVENTORY_STOP_EVENT) {
                inventoryStopLock.lock();
                try {
                    inventoryComplete = true;
                    inventoryStopped.signalAll();
                } finally {
                    inventoryStopLock.unlock();
                }
            }
        }
    }

    private static STATE_UNAWARE_ACTION stateUnawareAction(int action) throws InvalidUsageException {
        switch (action) {
            case 0:
                return STATE_UNAWARE_ACTION.STATE_UNAWARE_ACTION_SELECT_NOT_UNSELECT;
            case 1:
                return STATE_UNAWARE_ACTION.STATE_UNAWARE_ACTION_SELECT;
            case 2:
                return STATE_UNAWARE_ACTION.STATE_UNAWARE_ACTION_NOT_UNSELECT;
            case 3:
                return STATE_UNAWARE_ACTION.STATE_UNAWARE_ACTION_UNSELECT;
            case 4:
                return STATE_UNAWARE_ACTION.STATE_UNAWARE_ACTION_UNSELECT_NOT_SELECT;
            case 5:
                return STATE_UNAWARE_ACTION.STATE_UNAWARE_ACTION_NOT_SELECT;
            default:
                throw new InvalidUsageException(
                        "InvalidUsageException", "Valid range of StateUnawareAction [0,5]");
        }
    }

    /** Same as RFIDSample4.hexStringToByteArray */
    private static byte[] hexStringToByteArray(String s) {
        if ((s.length() & 1) != 0) {
            throw new IllegalArgumentException("Pattern hex must have an even number of characters");
        }
        int len = s.length();
        byte[] data = new byte[len / 2];
        for (int i = 0; i < len; i += 2) {
            data[i / 2] =
                    (byte)
                            ((Character.digit(s.charAt(i), 16) << 4)
                                    + Character.digit(s.charAt(i + 1), 16));
        }
        return data;
    }
}
