-- PostgreSQL checks for a migration. Read-only unless marked.

-- 1. Dead rows and last vacuum, per table.
SELECT relname, n_live_tup, n_dead_tup, last_autovacuum, last_autoanalyze
FROM   pg_stat_user_tables
ORDER  BY n_dead_tup DESC
LIMIT  20;

-- 2. Distance to transaction ID wraparound, per database.
SELECT datname, age(datfrozenxid) AS xid_age
FROM   pg_database
ORDER  BY xid_age DESC;

-- 3. Oldest open transactions (these hold back vacuum).
SELECT pid, usename, application_name, state, now() - xact_start AS xact_age
FROM   pg_stat_activity
WHERE  xact_start IS NOT NULL
ORDER  BY xact_start
LIMIT  10;

-- 4. Connection states.
SELECT state, count(*)
FROM   pg_stat_activity
WHERE  backend_type = 'client backend'
GROUP  BY state
ORDER  BY count(*) DESC;

-- 5. Streaming replication lag in bytes.
SELECT application_name, state,
       pg_wal_lsn_diff(pg_current_wal_lsn(), replay_lsn) AS replay_lag_bytes
FROM   pg_stat_replication;

-- 6. Replication slots and the WAL they retain.
SELECT slot_name, active,
       pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) AS retained_wal
FROM   pg_replication_slots;

-- 7. Sequences behind their table maximum (edit names; run per identity column).
-- SELECT max(order_id) FROM orders;
-- SELECT last_value FROM orders_order_id_seq;

-- 8. Rollback capture slot. WRITES: creates a slot. Requires wal_level = logical.
-- Create before the application is opened on PostgreSQL. Drop when the rollback path closes.
-- SELECT pg_create_logical_replication_slot('rollback_capture', 'test_decoding');
-- SELECT lsn, xid, data FROM pg_logical_slot_peek_changes('rollback_capture', NULL, NULL) LIMIT 20;
-- SELECT pg_drop_replication_slot('rollback_capture');

-- 9. Reconciliation template. Run the equivalent on SQL Server and compare.
-- SELECT count(*), sum(total), min(created_at), max(created_at), count(DISTINCT lower(customer_email))
-- FROM   orders;
