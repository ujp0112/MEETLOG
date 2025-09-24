package util;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.concurrent.BlockingQueue;
import java.util.concurrent.LinkedBlockingQueue;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

/**
 * 데이터베이스 연결 풀 매니저
 * 효율적인 DB 연결 관리로 성능 최적화
 */
public class ConnectionPoolManager {
    private static ConnectionPoolManager instance;

    // 연결 풀 설정
    private static final int MIN_CONNECTIONS = 5;
    private static final int MAX_CONNECTIONS = 20;
    private static final int CONNECTION_TIMEOUT = 30; // seconds

    // DB 연결 정보 (mybatis-config.xml과 동일)
    private static final String DRIVER = "org.mariadb.jdbc.Driver";
    private static final String URL = "jdbc:mariadb://localhost:3306/meetlog";
    private static final String USERNAME = "root";
    private static final String PASSWORD = "7564";

    private final BlockingQueue<PooledConnection> availableConnections;
    private final AtomicInteger activeConnections;
    private volatile boolean isShutdown = false;

    private ConnectionPoolManager() {
        this.availableConnections = new LinkedBlockingQueue<>(MAX_CONNECTIONS);
        this.activeConnections = new AtomicInteger(0);

        // 드라이버 로드
        try {
            Class.forName(DRIVER);
        } catch (ClassNotFoundException e) {
            throw new RuntimeException("Failed to load database driver", e);
        }

        // 초기 연결 생성
        initializePool();
    }

    public static synchronized ConnectionPoolManager getInstance() {
        if (instance == null) {
            instance = new ConnectionPoolManager();
        }
        return instance;
    }

    /**
     * 연결 풀 초기화
     */
    private void initializePool() {
        for (int i = 0; i < MIN_CONNECTIONS; i++) {
            try {
                PooledConnection pooledConn = createPooledConnection();
                availableConnections.offer(pooledConn);
            } catch (SQLException e) {
                System.err.println("Failed to create initial connection: " + e.getMessage());
            }
        }
    }

    /**
     * 연결 풀에서 연결 가져오기
     */
    public Connection getConnection() throws SQLException {
        if (isShutdown) {
            throw new SQLException("Connection pool is shutdown");
        }

        try {
            // 사용 가능한 연결 확인
            PooledConnection pooledConn = availableConnections.poll(CONNECTION_TIMEOUT, TimeUnit.SECONDS);

            if (pooledConn == null || !pooledConn.isValid()) {
                // 새 연결 생성 (최대 연결 수 제한)
                if (activeConnections.get() < MAX_CONNECTIONS) {
                    pooledConn = createPooledConnection();
                } else {
                    throw new SQLException("Maximum connections reached: " + MAX_CONNECTIONS);
                }
            }

            pooledConn.setInUse(true);
            activeConnections.incrementAndGet();
            return pooledConn;

        } catch (InterruptedException e) {
            Thread.currentThread().interrupt();
            throw new SQLException("Connection request interrupted", e);
        }
    }

    /**
     * 연결 풀에 연결 반환
     */
    public void releaseConnection(Connection connection) {
        if (connection instanceof PooledConnection) {
            PooledConnection pooledConn = (PooledConnection) connection;

            if (pooledConn.isValid() && !isShutdown) {
                pooledConn.setInUse(false);
                pooledConn.resetConnection();
                availableConnections.offer(pooledConn);
            } else {
                pooledConn.closePhysicalConnection();
            }

            activeConnections.decrementAndGet();
        }
    }

    /**
     * 새로운 풀링 연결 생성
     */
    private PooledConnection createPooledConnection() throws SQLException {
        Connection physicalConnection = DriverManager.getConnection(URL, USERNAME, PASSWORD);

        // 연결 설정
        physicalConnection.setAutoCommit(false);

        return new PooledConnection(physicalConnection, this);
    }

    /**
     * 연결 풀 상태 정보
     */
    public PoolStats getStats() {
        return new PoolStats(
            availableConnections.size(),
            activeConnections.get(),
            MAX_CONNECTIONS
        );
    }

    /**
     * 연결 풀 정리
     */
    public void shutdown() {
        isShutdown = true;

        // 모든 대기 중인 연결 닫기
        PooledConnection conn;
        while ((conn = availableConnections.poll()) != null) {
            conn.closePhysicalConnection();
        }
    }

    /**
     * 풀링된 연결 래퍼 클래스
     */
    private static class PooledConnection implements Connection {
        private final Connection physicalConnection;
        private final ConnectionPoolManager pool;
        private boolean inUse;
        private long lastUsed;

        public PooledConnection(Connection physicalConnection, ConnectionPoolManager pool) {
            this.physicalConnection = physicalConnection;
            this.pool = pool;
            this.inUse = false;
            this.lastUsed = System.currentTimeMillis();
        }

        public boolean isValid() {
            try {
                return physicalConnection != null &&
                       !physicalConnection.isClosed() &&
                       physicalConnection.isValid(5);
            } catch (SQLException e) {
                return false;
            }
        }

        public void setInUse(boolean inUse) {
            this.inUse = inUse;
            if (inUse) {
                this.lastUsed = System.currentTimeMillis();
            }
        }

        public void resetConnection() {
            try {
                if (!physicalConnection.getAutoCommit()) {
                    physicalConnection.rollback();
                }
                physicalConnection.clearWarnings();
            } catch (SQLException e) {
                // 연결 리셋 실패는 로그만 남기고 계속 진행
                System.err.println("Failed to reset connection: " + e.getMessage());
            }
        }

        public void closePhysicalConnection() {
            try {
                physicalConnection.close();
            } catch (SQLException e) {
                System.err.println("Failed to close physical connection: " + e.getMessage());
            }
        }

        @Override
        public void close() throws SQLException {
            // 실제 연결을 닫지 않고 풀에 반환
            pool.releaseConnection(this);
        }

        // Connection 인터페이스 메서드 위임
        @Override
        public java.sql.Statement createStatement() throws SQLException {
            return physicalConnection.createStatement();
        }

        @Override
        public java.sql.PreparedStatement prepareStatement(String sql) throws SQLException {
            return physicalConnection.prepareStatement(sql);
        }

        @Override
        public java.sql.CallableStatement prepareCall(String sql) throws SQLException {
            return physicalConnection.prepareCall(sql);
        }

        @Override
        public String nativeSQL(String sql) throws SQLException {
            return physicalConnection.nativeSQL(sql);
        }

        @Override
        public void setAutoCommit(boolean autoCommit) throws SQLException {
            physicalConnection.setAutoCommit(autoCommit);
        }

        @Override
        public boolean getAutoCommit() throws SQLException {
            return physicalConnection.getAutoCommit();
        }

        @Override
        public void commit() throws SQLException {
            physicalConnection.commit();
        }

        @Override
        public void rollback() throws SQLException {
            physicalConnection.rollback();
        }

        @Override
        public boolean isClosed() throws SQLException {
            return physicalConnection.isClosed();
        }

        @Override
        public java.sql.DatabaseMetaData getMetaData() throws SQLException {
            return physicalConnection.getMetaData();
        }

        @Override
        public void setReadOnly(boolean readOnly) throws SQLException {
            physicalConnection.setReadOnly(readOnly);
        }

        @Override
        public boolean isReadOnly() throws SQLException {
            return physicalConnection.isReadOnly();
        }

        @Override
        public void setCatalog(String catalog) throws SQLException {
            physicalConnection.setCatalog(catalog);
        }

        @Override
        public String getCatalog() throws SQLException {
            return physicalConnection.getCatalog();
        }

        @Override
        public void setTransactionIsolation(int level) throws SQLException {
            physicalConnection.setTransactionIsolation(level);
        }

        @Override
        public int getTransactionIsolation() throws SQLException {
            return physicalConnection.getTransactionIsolation();
        }

        @Override
        public java.sql.SQLWarning getWarnings() throws SQLException {
            return physicalConnection.getWarnings();
        }

        @Override
        public void clearWarnings() throws SQLException {
            physicalConnection.clearWarnings();
        }

        @Override
        public java.sql.Statement createStatement(int resultSetType, int resultSetConcurrency) throws SQLException {
            return physicalConnection.createStatement(resultSetType, resultSetConcurrency);
        }

        @Override
        public java.sql.PreparedStatement prepareStatement(String sql, int resultSetType, int resultSetConcurrency) throws SQLException {
            return physicalConnection.prepareStatement(sql, resultSetType, resultSetConcurrency);
        }

        @Override
        public java.sql.CallableStatement prepareCall(String sql, int resultSetType, int resultSetConcurrency) throws SQLException {
            return physicalConnection.prepareCall(sql, resultSetType, resultSetConcurrency);
        }

        @Override
        public java.util.Map<String, Class<?>> getTypeMap() throws SQLException {
            return physicalConnection.getTypeMap();
        }

        @Override
        public void setTypeMap(java.util.Map<String, Class<?>> map) throws SQLException {
            physicalConnection.setTypeMap(map);
        }

        @Override
        public void setHoldability(int holdability) throws SQLException {
            physicalConnection.setHoldability(holdability);
        }

        @Override
        public int getHoldability() throws SQLException {
            return physicalConnection.getHoldability();
        }

        @Override
        public java.sql.Savepoint setSavepoint() throws SQLException {
            return physicalConnection.setSavepoint();
        }

        @Override
        public java.sql.Savepoint setSavepoint(String name) throws SQLException {
            return physicalConnection.setSavepoint(name);
        }

        @Override
        public void rollback(java.sql.Savepoint savepoint) throws SQLException {
            physicalConnection.rollback(savepoint);
        }

        @Override
        public void releaseSavepoint(java.sql.Savepoint savepoint) throws SQLException {
            physicalConnection.releaseSavepoint(savepoint);
        }

        @Override
        public java.sql.Statement createStatement(int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException {
            return physicalConnection.createStatement(resultSetType, resultSetConcurrency, resultSetHoldability);
        }

        @Override
        public java.sql.PreparedStatement prepareStatement(String sql, int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException {
            return physicalConnection.prepareStatement(sql, resultSetType, resultSetConcurrency, resultSetHoldability);
        }

        @Override
        public java.sql.CallableStatement prepareCall(String sql, int resultSetType, int resultSetConcurrency, int resultSetHoldability) throws SQLException {
            return physicalConnection.prepareCall(sql, resultSetType, resultSetConcurrency, resultSetHoldability);
        }

        @Override
        public java.sql.PreparedStatement prepareStatement(String sql, int autoGeneratedKeys) throws SQLException {
            return physicalConnection.prepareStatement(sql, autoGeneratedKeys);
        }

        @Override
        public java.sql.PreparedStatement prepareStatement(String sql, int[] columnIndexes) throws SQLException {
            return physicalConnection.prepareStatement(sql, columnIndexes);
        }

        @Override
        public java.sql.PreparedStatement prepareStatement(String sql, String[] columnNames) throws SQLException {
            return physicalConnection.prepareStatement(sql, columnNames);
        }

        @Override
        public java.sql.Clob createClob() throws SQLException {
            return physicalConnection.createClob();
        }

        @Override
        public java.sql.Blob createBlob() throws SQLException {
            return physicalConnection.createBlob();
        }

        @Override
        public java.sql.NClob createNClob() throws SQLException {
            return physicalConnection.createNClob();
        }

        @Override
        public java.sql.SQLXML createSQLXML() throws SQLException {
            return physicalConnection.createSQLXML();
        }

        @Override
        public boolean isValid(int timeout) throws SQLException {
            return physicalConnection.isValid(timeout);
        }

        @Override
        public void setClientInfo(String name, String value) throws java.sql.SQLClientInfoException {
            physicalConnection.setClientInfo(name, value);
        }

        @Override
        public void setClientInfo(java.util.Properties properties) throws java.sql.SQLClientInfoException {
            physicalConnection.setClientInfo(properties);
        }

        @Override
        public String getClientInfo(String name) throws SQLException {
            return physicalConnection.getClientInfo(name);
        }

        @Override
        public java.util.Properties getClientInfo() throws SQLException {
            return physicalConnection.getClientInfo();
        }

        @Override
        public java.sql.Array createArrayOf(String typeName, Object[] elements) throws SQLException {
            return physicalConnection.createArrayOf(typeName, elements);
        }

        @Override
        public java.sql.Struct createStruct(String typeName, Object[] attributes) throws SQLException {
            return physicalConnection.createStruct(typeName, attributes);
        }

        @Override
        public void setSchema(String schema) throws SQLException {
            physicalConnection.setSchema(schema);
        }

        @Override
        public String getSchema() throws SQLException {
            return physicalConnection.getSchema();
        }

        @Override
        public void abort(java.util.concurrent.Executor executor) throws SQLException {
            physicalConnection.abort(executor);
        }

        @Override
        public void setNetworkTimeout(java.util.concurrent.Executor executor, int milliseconds) throws SQLException {
            physicalConnection.setNetworkTimeout(executor, milliseconds);
        }

        @Override
        public int getNetworkTimeout() throws SQLException {
            return physicalConnection.getNetworkTimeout();
        }

        @Override
        public <T> T unwrap(Class<T> iface) throws SQLException {
            return physicalConnection.unwrap(iface);
        }

        @Override
        public boolean isWrapperFor(Class<?> iface) throws SQLException {
            return physicalConnection.isWrapperFor(iface);
        }
    }

    /**
     * 연결 풀 통계
     */
    public static class PoolStats {
        private final int availableConnections;
        private final int activeConnections;
        private final int maxConnections;

        public PoolStats(int availableConnections, int activeConnections, int maxConnections) {
            this.availableConnections = availableConnections;
            this.activeConnections = activeConnections;
            this.maxConnections = maxConnections;
        }

        public int getAvailableConnections() {
            return availableConnections;
        }

        public int getActiveConnections() {
            return activeConnections;
        }

        public int getMaxConnections() {
            return maxConnections;
        }

        public int getTotalConnections() {
            return availableConnections + activeConnections;
        }

        public double getUsagePercentage() {
            return (double) activeConnections / maxConnections * 100;
        }

        @Override
        public String toString() {
            return String.format("PoolStats{available=%d, active=%d, max=%d, usage=%.1f%%}",
                availableConnections, activeConnections, maxConnections, getUsagePercentage());
        }
    }
}