package rfidsample4;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;
import java.sql.Timestamp;
import java.util.UUID;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.eclipse.paho.client.mqttv3.IMqttDeliveryToken;
import org.eclipse.paho.client.mqttv3.MqttCallback;
import org.eclipse.paho.client.mqttv3.MqttClient;
import org.eclipse.paho.client.mqttv3.MqttConnectOptions;
import org.eclipse.paho.client.mqttv3.MqttException;
import org.eclipse.paho.client.mqttv3.MqttMessage;

public class RFIDTourEventSubscriber implements MqttCallback {

    private static final String LOCALIZE_READER_ID = "localize";
    private static final boolean LOG_EACH_INSERT = parseBoolean(System.getenv("LOG_EACH_INSERT"));
    private static final long STATS_LOG_INTERVAL_MS = parseLongEnv("STATS_LOG_INTERVAL_MS", 5000L);

    private static final String CREATE_TABLE_SQL =
            "CREATE TABLE IF NOT EXISTS tour_event ("
                    + "id BIGSERIAL PRIMARY KEY,"
                    + "event_id UUID NOT NULL UNIQUE,"
                    + "event_type TEXT NOT NULL,"
                    + "event_ts TIMESTAMPTZ NOT NULL,"
                    + "site_id TEXT,"
                    + "reader_id TEXT,"
                    + "antenna_id INTEGER,"
                    + "tour_id TEXT,"
                    + "epc TEXT,"
                    + "window_start_epoch_sec BIGINT,"
                    + "window_end_epoch_sec BIGINT,"
                    + "read_count_60s BIGINT,"
                    + "unique_tag_count_60s BIGINT,"
                    + "avg_rssi_60s DOUBLE PRECISION,"
                    + "baseline_read_count DOUBLE PRECISION,"
                    + "baseline_avg_rssi DOUBLE PRECISION,"
                    + "count_drop_pct DOUBLE PRECISION,"
                    + "rssi_drop_db DOUBLE PRECISION,"
                    + "threshold_count_drop_pct DOUBLE PRECISION,"
                    + "threshold_rssi_drop_db DOUBLE PRECISION,"
                    + "consecutive_checks_required INTEGER,"
                    + "created_at TIMESTAMPTZ NOT NULL DEFAULT NOW()"
                    + ")";

    private static final String MIGRATE_TABLE_SQL =
            "ALTER TABLE tour_event "
                    + "ADD COLUMN IF NOT EXISTS epc TEXT, "
                    + "DROP COLUMN IF EXISTS epc_list_csv, "
                    + "DROP COLUMN IF EXISTS payload";

    private static final String CREATE_LOCALIZE_TABLE_SQL =
            "CREATE TABLE IF NOT EXISTS localize ("
                    + "event_ts TIMESTAMPTZ NOT NULL,"
                    + "antenna_id INTEGER NOT NULL,"
                    + "epc TEXT NOT NULL,"
                    + "avg_rssi DOUBLE PRECISION,"
                    + "read_count BIGINT"
                    + ")";

    private static final String INSERT_SQL =
            "INSERT INTO tour_event ("
                    + "event_id,event_type,event_ts,site_id,reader_id,antenna_id,tour_id,epc,"
                    + "window_start_epoch_sec,window_end_epoch_sec,read_count_60s,unique_tag_count_60s,"
                    + "avg_rssi_60s,baseline_read_count,baseline_avg_rssi,count_drop_pct,rssi_drop_db,"
                    + "threshold_count_drop_pct,threshold_rssi_drop_db,consecutive_checks_required"
                    + ") VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?) "
                    + "ON CONFLICT (event_id) DO NOTHING";

    private static final String INSERT_LOCALIZE_SQL =
            "INSERT INTO localize (event_ts, antenna_id, epc, avg_rssi, read_count) VALUES (?,?,?,?,?)";

    private final String mqttBrokerUrl;
    private final String mqttTopic;
    private final String mqttClientId;
    private final String mqttUsername;
    private final String mqttPassword;

    private final String pgUrl;
    private final String pgUser;
    private final String pgPassword;
    private final boolean autoCreateTable;

    private MqttClient mqttClient;
    private Connection pgConnection;
    private PreparedStatement insertStatement;
    private PreparedStatement insertLocalizeStatement;
    private long insertedCount;
    private long insertErrorCount;
    private long lastStatsLogMs;

    public RFIDTourEventSubscriber(
            String mqttBrokerUrl,
            String mqttTopic,
            String mqttClientId,
            String mqttUsername,
            String mqttPassword,
            String pgUrl,
            String pgUser,
            String pgPassword,
            boolean autoCreateTable) {
        this.mqttBrokerUrl = mqttBrokerUrl;
        this.mqttTopic = mqttTopic;
        this.mqttClientId = mqttClientId;
        this.mqttUsername = mqttUsername;
        this.mqttPassword = mqttPassword;
        this.pgUrl = pgUrl;
        this.pgUser = pgUser;
        this.pgPassword = pgPassword;
        this.autoCreateTable = autoCreateTable;
    }

    public static void main(String[] args) throws Exception {
        if (args.length < 3) {
            printUsage();
            System.exit(2);
            return;
        }

        String mqttBrokerUrl = args[0];
        String mqttTopic = args[1];
        String pgUrl = args[2];
        String pgUser = args.length > 3 ? args[3] : "";
        String pgPassword = args.length > 4 ? args[4] : "";

        boolean autoCreateTable = args.length > 5 ? parseBoolean(args[5]) : true;
        String mqttClientId = args.length > 6 ? args[6] : "rfid-tour-event-subscriber-" + UUID.randomUUID().toString();
        String mqttUsername = args.length > 7 ? args[7] : "";
        String mqttPassword = args.length > 8 ? args[8] : "";

        final RFIDTourEventSubscriber app =
                new RFIDTourEventSubscriber(
                        mqttBrokerUrl,
                        mqttTopic,
                        mqttClientId,
                        mqttUsername,
                        mqttPassword,
                        pgUrl,
                        pgUser,
                        pgPassword,
                        autoCreateTable);

        Runtime.getRuntime().addShutdownHook(new Thread(new Runnable() {
            public void run() {
                app.shutdown();
            }
        }));

        app.start();
        while (true) {
            Thread.sleep(1000L);
        }
    }

    private static void printUsage() {
        System.err.println(
                "Usage: RFIDTourEventSubscriber MQTT_BROKER_URL MQTT_TOPIC PG_URL_OR_URI [PG_USER] [PG_PASSWORD] "
                        + "[AUTO_CREATE_TABLE] [MQTT_CLIENT_ID] [MQTT_USER] [MQTT_PASS]");
        System.err.println("Example MQTT_TOPIC: rfid/+/+/+/tour/+/transition");
        System.err.println("Example PG_URL: jdbc:postgresql://127.0.0.1:5432/rfid");
        System.err.println("Or embed credentials in PG_URL_OR_URI and omit PG_USER/PG_PASSWORD.");
    }

    private static boolean parseBoolean(String value) {
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

    public void start() throws Exception {
        Class.forName("org.postgresql.Driver");
        if (pgUser != null && pgUser.length() > 0) {
            pgConnection = DriverManager.getConnection(pgUrl, pgUser, pgPassword);
        } else {
            pgConnection = DriverManager.getConnection(pgUrl);
        }
        pgConnection.setAutoCommit(true);

        if (autoCreateTable) {
            Statement st = null;
            try {
                st = pgConnection.createStatement();
                st.execute(CREATE_TABLE_SQL);
                st.execute(MIGRATE_TABLE_SQL);
                st.execute(CREATE_LOCALIZE_TABLE_SQL);
            } finally {
                closeQuietly(st);
            }
            System.out.println("Ensured tables tour_event and localize exist.");
        }

        insertStatement = pgConnection.prepareStatement(INSERT_SQL);
        insertLocalizeStatement = pgConnection.prepareStatement(INSERT_LOCALIZE_SQL);

        mqttClient = new MqttClient(mqttBrokerUrl, mqttClientId);
        mqttClient.setCallback(this);

        MqttConnectOptions options = new MqttConnectOptions();
        options.setCleanSession(true);
        options.setAutomaticReconnect(true);
        if (mqttUsername != null && mqttUsername.length() > 0) {
            options.setUserName(mqttUsername);
        }
        if (mqttPassword != null && mqttPassword.length() > 0) {
            options.setPassword(mqttPassword.toCharArray());
        }

        mqttClient.connect(options);
        mqttClient.subscribe(mqttTopic, 1);

        System.out.println("Connected MQTT " + mqttBrokerUrl + " clientId=" + mqttClientId);
        System.out.println("Subscribed MQTT topic " + mqttTopic);
        System.out.println("Connected PostgreSQL " + pgUrl);
    }

    public void shutdown() {
        try {
            if (mqttClient != null && mqttClient.isConnected()) {
                mqttClient.disconnect();
            }
        } catch (Exception ex) {
        }

        closeQuietly(insertStatement);
        closeQuietly(insertLocalizeStatement);
        closeQuietly(pgConnection);
    }

    public void connectionLost(Throwable cause) {
        System.err.println("MQTT connection lost: " + (cause == null ? "unknown" : cause.getMessage()));
    }

    public void messageArrived(String topic, MqttMessage message) {
        String payload = new String(message.getPayload());
        try {
            String targetTable = insertEvent(topic, payload);
            insertedCount++;
            if (LOG_EACH_INSERT) {
                System.out.println("Inserted event into " + targetTable + " from topic " + topic);
            }
        } catch (Exception ex) {
            insertErrorCount++;
            System.err.println("Insert failed for topic " + topic + ": " + ex.getMessage());
        } finally {
            maybeLogStats();
        }
    }

    private void maybeLogStats() {
        long nowMs = System.currentTimeMillis();
        if (lastStatsLogMs == 0L) {
            lastStatsLogMs = nowMs;
            return;
        }
        if (nowMs - lastStatsLogMs < STATS_LOG_INTERVAL_MS) {
            return;
        }
        System.out.println(
                "subscriber stats inserted=" + insertedCount + " errors=" + insertErrorCount + " topic=" + mqttTopic);
        lastStatsLogMs = nowMs;
    }

    public void deliveryComplete(IMqttDeliveryToken token) {
    }

    private String insertEvent(String topic, String payload) throws SQLException {
        String payloadReaderId = normalizeReaderId(jsonString(payload, "reader_id"));
        String topicReaderId = normalizeReaderId(readerIdFromTopic(topic));
        String readerId = payloadReaderId.length() > 0 ? payloadReaderId : topicReaderId;
        Timestamp eventTs = parseEventTs(defaultString(jsonString(payload, "event_ts"), null));

        if (LOCALIZE_READER_ID.equals(readerId) || LOCALIZE_READER_ID.equals(topicReaderId)) {
            Integer antennaId = jsonInteger(payload, "antenna_id");
            String epc = jsonString(payload, "epc");
            Double avgRssi = jsonDouble(payload, "avg_rssi_60s");
            Long readCount = jsonLong(payload, "read_count_60s");
            insertLocalizeEvent(eventTs, antennaId, epc, avgRssi, readCount);
            return "localize";
        }

        String eventId = jsonString(payload, "event_id");
        if (eventId == null || eventId.length() == 0) {
            throw new SQLException("Missing required event_id in payload");
        }

        String eventType = defaultString(jsonString(payload, "event_type"), "TOUR_GROUP_DEPARTING");

        insertStatement.setObject(1, UUID.fromString(eventId));
        insertStatement.setString(2, eventType);
        insertStatement.setTimestamp(3, eventTs);
        insertStatement.setString(4, jsonString(payload, "site_id"));
        insertStatement.setString(5, readerId);
        setIntegerOrNull(insertStatement, 6, jsonInteger(payload, "antenna_id"));
        insertStatement.setString(7, jsonString(payload, "tour_id"));
        insertStatement.setString(8, jsonString(payload, "epc"));
        setLongOrNull(insertStatement, 9, jsonLong(payload, "window_start_epoch_sec"));
        setLongOrNull(insertStatement, 10, jsonLong(payload, "window_end_epoch_sec"));
        setLongOrNull(insertStatement, 11, jsonLong(payload, "read_count_60s"));
        setLongOrNull(insertStatement, 12, jsonLong(payload, "unique_tag_count_60s"));
        setDoubleOrNull(insertStatement, 13, jsonDouble(payload, "avg_rssi_60s"));
        setDoubleOrNull(insertStatement, 14, jsonDouble(payload, "baseline_read_count"));
        setDoubleOrNull(insertStatement, 15, jsonDouble(payload, "baseline_avg_rssi"));
        setDoubleOrNull(insertStatement, 16, jsonDouble(payload, "count_drop_pct"));
        setDoubleOrNull(insertStatement, 17, jsonDouble(payload, "rssi_drop_db"));
        setDoubleOrNull(insertStatement, 18, jsonDouble(payload, "threshold_count_drop_pct"));
        setDoubleOrNull(insertStatement, 19, jsonDouble(payload, "threshold_rssi_drop_db"));
        setIntegerOrNull(insertStatement, 20, jsonInteger(payload, "consecutive_checks_required"));
        insertStatement.executeUpdate();
        return "tour_event";
    }

    private static String readerIdFromTopic(String topic) {
        if (topic == null) {
            return "";
        }
        String[] parts = topic.split("/");
        if (parts.length >= 3) {
            return parts[2];
        }
        return "";
    }

    private static String normalizeReaderId(String value) {
        if (value == null) {
            return "";
        }
        return value.trim().toLowerCase();
    }

    private void insertLocalizeEvent(
            Timestamp eventTs,
            Integer antennaId,
            String epc,
            Double avgRssi,
            Long readCount)
            throws SQLException {
        if (antennaId == null) {
            throw new SQLException("Missing required antenna_id for localize event");
        }
        if (epc == null || epc.length() == 0) {
            throw new SQLException("Missing required epc for localize event");
        }

        insertLocalizeStatement.setTimestamp(1, eventTs);
        insertLocalizeStatement.setInt(2, antennaId.intValue());
        insertLocalizeStatement.setString(3, epc);
        setDoubleOrNull(insertLocalizeStatement, 4, avgRssi);
        setLongOrNull(insertLocalizeStatement, 5, readCount);
        insertLocalizeStatement.executeUpdate();
    }

    private static void setIntegerOrNull(PreparedStatement ps, int idx, Integer value) throws SQLException {
        if (value == null) {
            ps.setNull(idx, java.sql.Types.INTEGER);
        } else {
            ps.setInt(idx, value.intValue());
        }
    }

    private static void setLongOrNull(PreparedStatement ps, int idx, Long value) throws SQLException {
        if (value == null) {
            ps.setNull(idx, java.sql.Types.BIGINT);
        } else {
            ps.setLong(idx, value.longValue());
        }
    }

    private static void setDoubleOrNull(PreparedStatement ps, int idx, Double value) throws SQLException {
        if (value == null) {
            ps.setNull(idx, java.sql.Types.DOUBLE);
        } else {
            ps.setDouble(idx, value.doubleValue());
        }
    }

    private static Timestamp parseEventTs(String value) {
        if (value == null || value.length() == 0) {
            return new Timestamp(System.currentTimeMillis());
        }
        try {
            long epochMillis = Long.parseLong(value);
            return new Timestamp(epochMillis);
        } catch (NumberFormatException nfe) {
            return new Timestamp(System.currentTimeMillis());
        }
    }

    private static String defaultString(String value, String defaultValue) {
        return value == null ? defaultValue : value;
    }

    private static String jsonString(String json, String key) {
        String raw = jsonRawValue(json, key);
        if (raw == null) {
            return null;
        }
        raw = raw.trim();
        if (raw.length() >= 2 && raw.charAt(0) == '"' && raw.charAt(raw.length() - 1) == '"') {
            String value = raw.substring(1, raw.length() - 1);
            return value.replace("\\\"", "\"").replace("\\\\", "\\");
        }
        if ("null".equals(raw)) {
            return null;
        }
        return raw;
    }

    private static Integer jsonInteger(String json, String key) {
        String raw = jsonRawValue(json, key);
        if (raw == null) {
            return null;
        }
        try {
            return Integer.valueOf(Integer.parseInt(stripQuotes(raw)));
        } catch (Exception ex) {
            return null;
        }
    }

    private static Long jsonLong(String json, String key) {
        String raw = jsonRawValue(json, key);
        if (raw == null) {
            return null;
        }
        try {
            return Long.valueOf(Long.parseLong(stripQuotes(raw)));
        } catch (Exception ex) {
            return null;
        }
    }

    private static Double jsonDouble(String json, String key) {
        String raw = jsonRawValue(json, key);
        if (raw == null) {
            return null;
        }
        try {
            return Double.valueOf(Double.parseDouble(stripQuotes(raw)));
        } catch (Exception ex) {
            return null;
        }
    }

    private static String stripQuotes(String value) {
        String v = value == null ? null : value.trim();
        if (v == null) {
            return null;
        }
        if (v.length() >= 2 && v.charAt(0) == '"' && v.charAt(v.length() - 1) == '"') {
            return v.substring(1, v.length() - 1);
        }
        return v;
    }

    private static String jsonRawValue(String json, String key) {
        Pattern p = Pattern.compile("\\\"" + Pattern.quote(key) + "\\\"\\s*:\\s*(\\\"(?:\\\\.|[^\\\"])*\\\"|-?\\d+(?:\\.\\d+)?|null|true|false)");
        Matcher m = p.matcher(json);
        if (m.find()) {
            return m.group(1);
        }
        return null;
    }

    private static void closeQuietly(Statement st) {
        if (st == null) {
            return;
        }
        try {
            st.close();
        } catch (Exception ex) {
        }
    }

    private static void closeQuietly(Connection conn) {
        if (conn == null) {
            return;
        }
        try {
            conn.close();
        } catch (Exception ex) {
        }
    }

    private static long parseLongEnv(String key, long defaultValue) {
        String raw = System.getenv(key);
        if (raw == null || raw.trim().length() == 0) {
            return defaultValue;
        }
        try {
            return Long.parseLong(raw.trim());
        } catch (Exception ex) {
            return defaultValue;
        }
    }
}
