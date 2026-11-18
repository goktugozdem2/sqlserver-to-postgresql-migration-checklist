# Checklist

Format: `- [ ] question` then owner, date, evidence link.

## 1. Assessment

- [ ] Inventory of databases with size, growth and peak write volume.
- [ ] Count of stored procedures, functions, triggers and Agent jobs. Unused ones marked.
- [ ] SQL Server features in use with no direct PostgreSQL equivalent are listed: linked servers, CLR, Service Broker, SSIS, SSRS, cross-database queries.
- [ ] Every connecting application, report and integration has a named owner.
- [ ] Recovery time and recovery point objectives for the new platform are agreed in writing.
- [ ] Target PostgreSQL version, hosting model and extensions are decided.

## 2. Conversion

- [ ] Every data type mapping that changes behavior is recorded with its reason (datetime precision, datetimeoffset, bit, money, rowversion).
- [ ] Case sensitivity is decided per column: citext, nondeterministic collation, or lower() index.
- [ ] Unique indexes that rely on single-NULL behavior are identified.
- [ ] Each procedure is classified: mechanical, redesign, or retire.
- [ ] Procedures that return multiple result sets, commit inside loops, or continue after errors are flagged.
- [ ] Application queries, including ORM-generated ones, are tested against PostgreSQL.
- [ ] Scheduled jobs have a new home (pg_cron or external scheduler) with alerting.
- [ ] Identity columns are converted and sequences are set past the migrated maximum.

## 3. Validation in QA

- [ ] Reconciliation is scripted and repeatable: row counts, aggregates, sampled row comparison.
- [ ] Replication has been interrupted on purpose and rebuilt without risk to the source.
- [ ] Tables that cannot replicate cleanly are listed, each with a handling decision.
- [ ] Performance is measured under representative load.
- [ ] Stop thresholds for lag, errors and mismatches are written down, each with an evidence owner.
- [ ] Monitoring and alert routes are tested end to end in QA.

## 4. Cutover

- [ ] One named cutover owner decides between resume and rollback.
- [ ] Anyone responsible for a critical control can call a pause.
- [ ] The order for stopping writers, jobs and integrations is documented and rehearsed.
- [ ] Final sync and validation steps have expected durations.
- [ ] Business communication has an owner and a template.

## 5. Rollback

- [ ] Rollback before the first write is rehearsed.
- [ ] Rollback after the first write is rehearsed, with real write traffic on PostgreSQL.
- [ ] The mechanism that captures post-cutover changes exists before the application opens (logical slot, audit columns, or a signed decision to accept loss).
- [ ] Applying changes back to SQL Server is tested: identity values, precision, triggers, table order.
- [ ] Measured time from rollback decision to validated service fits the agreed limit.
- [ ] Accepted data loss is stated and signed.
- [ ] A date or condition closes the rollback path.

## 6. First ninety days

- [ ] Alerts cover dead tuples, transaction age, XID age, connection saturation, replication lag and inactive slots.
- [ ] Maintenance jobs inherited from SQL Server are each reviewed: keep, replace, retire.
- [ ] A connection pooler is in place or its absence is a recorded decision.
- [ ] The operations team has performed a point-in-time recovery and recorded the duration.
- [ ] pg_stat_statements is enabled and reviewed on a schedule.
- [ ] Migration leftovers are removed: replication slots, foreign data wrappers, temporary users.
- [ ] Configuration changes have an owner and a log.
- [ ] The old platform has a retirement date and conditions.
