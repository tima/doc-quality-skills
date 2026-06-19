# doc-quality-check

Orchestrates the complete documentation quality pipeline in a single command: accuracy audit, quality audit, then apply revisions. Reports are timestamped so each run preserves its own audit history. Any phase can be skipped or run in isolation via flags.

## What it runs

1. `/doc-accuracy-audit` — cross-references docs against source of truth
2. `/doc-quality-audit` — evaluates tone, style, clarity, and plain language
3. `/doc-quality-revise` — applies corrections interactively from both reports

Requires `doc-accuracy-audit`, `doc-quality-audit`, and `doc-quality-revise` to be installed.

## Invocation

```
/doc-quality-check path/to/docs
/doc-quality-check path/to/docs --audit-only
/doc-quality-check path/to/docs --skip-accuracy
/doc-quality-check path/to/docs --quality-only
/doc-quality-check path/to/docs --parallel
/doc-quality-check path/to/docs --dry-run
/doc-quality-check path/to/docs --since HEAD~3 --type cli --source https://github.com/org/repo
```

`--parallel` runs accuracy and quality audits concurrently for faster turnaround on large doc sets.

## Input

- Path to documentation files or directory
- All flags accepted by the individual skills (`--type`, `--source`, `--dimensions`, `--since`, `--dry-run`) are forwarded to the appropriate phase

## Output

- `{project}-accuracy-audit-YYYYMMDD-HHMM-UTC.md` (Phase 1)
- `{project}-quality-audit-YYYYMMDD-HHMM-UTC.md` (Phase 2)
- Revised documentation files (Phase 3, unless `--audit-only`)
