# SQL foundations — the `publications` database

Eighty-nine queries against the classic `publications` schema (authors, titles,
publishers, sales, employees, royalty schedules), working up from `SELECT` to
multi-table joins.

Every query in this repository has been **executed against the real database**
and the headline answers checked against expected values. Nothing here is
written-but-untested.

## What it covers

| File | Topic |
|---|---|
| `01_select_as_distinct.sql` | `SELECT`, column aliases, `DISTINCT` |
| `02_where_and_or_not.sql` | `WHERE`, boolean logic, operator precedence |
| `03_order_limit_aggregates.sql` | `ORDER BY`, `LIMIT`, `MIN/MAX/COUNT/AVG/SUM` |
| `04_aggregates_in_context.sql` | aggregates answering business questions |
| `05_like_wildcards.sql` | `LIKE`, `%` and `_` |
| `06_in_between.sql` | `IN`, `NOT IN`, `BETWEEN` |
| `07_group_by_having.sql` | `GROUP BY`, `HAVING`, execution order |
| `08_combined_filters.sql` | all filter stages in single queries |
| `09_joins.sql` | aliases, `INNER` vs `LEFT JOIN` |
| `10_case.sql` | `CASE`, including `CASE` over an aggregate |
| `11_joins_in_anger.sql` | chained joins, junction tables, royalty tiers |

## The parts worth reading

The comments carry the reasoning, not just the syntax. A few that come up
repeatedly in real work:

**Aggregates and NULL.** In `07`, one `GROUP BY` returns `COUNT(*) = 3` next to
an average computed over **two** rows, because the third price is `NULL` and
`AVG` skips NULLs rather than treating them as zero. `COUNT(*)` and `AVG(col)`
can run over different numbers of rows in the same result.

**`BETWEEN` on datetimes.** In `06`, `'1994-09-13'` becomes midnight on that
day. Every order in this dataset happens to be timestamped `00:00:00`, so the
boundary works — but an order placed at 14:30 that day would be silently
dropped. The half-open form is included alongside.

**`MAX()` gives a value, not a row.** Several exercises ask *which* record holds
the maximum; that is `ORDER BY ... DESC LIMIT 1`, not `MAX()`.

**`LEFT` vs `INNER`.** In `09`, the same two tables and the same `ON` clause
return 6 rows or 1, depending only on the join type — and two discount rows
never appear at all, because their `stor_id` is `NULL` and `NULL` never equals
anything.

## Running it

The queries are MySQL 8 and run as-is in Workbench or the `mysql` CLI against a
schema named `publications`.

To check them without installing MySQL, convert a dump to SQLite and run the
verifier:

```bash
python3 tools/mysql2sqlite.py publications_dump.sql publications.db
python3 tools/verify.py
```

`verify.py` executes every statement and reports failures by file and line. It
translates the handful of constructs SQLite spells differently — chiefly
`CONCAT()` — and splits statements with a parser that ignores semicolons inside
comments and string literals, which a naive `split(';')` gets wrong.

The dataset itself is not included: it is course-provided material.
