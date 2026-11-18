# SQL Server to PostgreSQL migration checklist

A phase-by-phase checklist for moving a production SQL Server database to PostgreSQL, written for the person who has to sign off the cutover.

Each item is a question with an owner and evidence. If an answer is unclear, that phase is not finished.

- [CHECKLIST.md](CHECKLIST.md): the checklist, six phases.
- [queries/postgresql.sql](queries/postgresql.sql): checks to run on PostgreSQL during and after the migration.
- [queries/sqlserver.sql](queries/sqlserver.sql): inventory and reconciliation queries for the source.

## How to use it

1. Copy `CHECKLIST.md` into your migration repository or ticket system.
2. Put a name and a date next to every item. An item with no owner is not in progress.
3. Attach the evidence: a query result, a rehearsal log, a signed decision.
4. Do not approve the cutover while phases 3 to 5 have open items.

## Background reading

- [Production Migration Notes](https://datrick.com/production-migration-notes): the reasoning behind each phase.
- [Data type mapping](https://datrick.com/sql-server-to-postgresql-data-type-mapping): which mappings change behavior.
- [T-SQL to PL/pgSQL conversion](https://datrick.com/t-sql-to-plpgsql-stored-procedure-conversion): what causes rework in procedural code.
- [Migration tools](https://datrick.com/sql-server-to-postgresql-migration-tools): what each tool does and what none of them cover.

## Contributing

Issues and pull requests are welcome. Keep items phrased as questions that a non-specialist can ask and a specialist can answer with evidence.

## License

Text: CC BY 4.0. SQL: MIT. Maintained by [Datrick](https://datrick.com/sql-server-to-postgresql-migration).
