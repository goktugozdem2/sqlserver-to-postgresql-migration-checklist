-- SQL Server inventory and reconciliation queries. Read-only.

-- 1. Database sizes.
SELECT d.name, SUM(mf.size) * 8 / 1024 AS size_mb
FROM   sys.master_files mf
JOIN   sys.databases d ON d.database_id = mf.database_id
GROUP  BY d.name
ORDER  BY size_mb DESC;

-- 2. Procedural code to convert, by type.
SELECT type_desc, COUNT(*) AS objects
FROM   sys.objects
WHERE  type IN ('P', 'FN', 'IF', 'TF', 'TR', 'V')
AND    is_ms_shipped = 0
GROUP  BY type_desc
ORDER  BY objects DESC;

-- 3. Procedures with no cached execution since the last restart (candidates for retirement; confirm over a full business cycle).
SELECT s.name AS schema_name, p.name AS procedure_name
FROM   sys.procedures p
JOIN   sys.schemas s ON s.schema_id = p.schema_id
LEFT   JOIN sys.dm_exec_procedure_stats ps
       ON ps.object_id = p.object_id AND ps.database_id = DB_ID()
WHERE  ps.object_id IS NULL
ORDER  BY 1, 2;

-- 4. Columns whose type needs a mapping decision.
SELECT TABLE_SCHEMA, TABLE_NAME, COLUMN_NAME, DATA_TYPE
FROM   INFORMATION_SCHEMA.COLUMNS
WHERE  DATA_TYPE IN ('datetime2', 'datetimeoffset', 'money', 'smallmoney', 'bit', 'tinyint',
                     'timestamp', 'sql_variant', 'hierarchyid', 'geography', 'geometry', 'xml')
ORDER  BY DATA_TYPE, TABLE_SCHEMA, TABLE_NAME;

-- 5. Tables without a primary key (these complicate change capture).
SELECT s.name AS schema_name, t.name AS table_name
FROM   sys.tables t
JOIN   sys.schemas s ON s.schema_id = t.schema_id
WHERE  OBJECTPROPERTY(t.object_id, 'TableHasPrimaryKey') = 0
ORDER  BY 1, 2;

-- 6. Database collation (case sensitivity decision).
SELECT name, collation_name FROM sys.databases WHERE name = DB_NAME();

-- 7. Agent jobs to rehome.
SELECT name, enabled FROM msdb.dbo.sysjobs ORDER BY name;

-- 8. Linked servers.
SELECT name, product, provider FROM sys.servers WHERE is_linked = 1;

-- 9. Reconciliation template. Run the equivalent on PostgreSQL and compare.
-- SELECT COUNT_BIG(*), SUM(Total), MIN(CreatedAt), MAX(CreatedAt), COUNT(DISTINCT LOWER(CustomerEmail))
-- FROM   dbo.Orders;
