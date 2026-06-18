# doc-quality-check Quick Reference

## When to Use

You want the full pipeline (audit + fix) in one command.

## Usage
```
/doc-quality-check <path> [flags]
```

## Flags
```
--skip-accuracy         Skip accuracy audit phase
--skip-quality          Skip quality audit phase
--audit-only            Skip revision phase (audit only)
--accuracy-only         Run only accuracy audit
--quality-only          Run only quality audit
--parallel              Run accuracy + quality audits concurrently
--dry-run               Preview without modifying files
--since <git-ref>       Incremental mode (changed files only)
--type <cli|terraform|api>  Project type (passed to accuracy audit)
--source <path-or-url>  Source of truth (passed to accuracy audit)
--dimensions <core|comprehensive>  Quality dimensions (passed to quality audit)
```

## Flag Conflicts

- `--skip-accuracy` + `--skip-quality` cannot be combined (nothing to audit)
- `--audit-only` + `--accuracy-only` or `--quality-only` cannot be combined

## Examples

**Full pipeline:**
```
/doc-quality-check docs/
```

**Audits only (no revisions):**
```
/doc-quality-check docs/ --audit-only
```

**Skip accuracy, run quality + revise:**
```
/doc-quality-check docs/ --skip-accuracy
```

**Fast parallel audits:**
```
/doc-quality-check docs/ --parallel
```

**Preview mode:**
```
/doc-quality-check docs/ --dry-run
```

## Pipeline Phases

**Phase 1:** Accuracy audit (doc-accuracy-audit)
**Phase 2:** Quality audit (doc-quality-audit)
**Phase 3:** Apply revisions (doc-quality-revise)

## Common Issues

| Issue | Meaning | Fix |
|-------|---------|-----|
| Report file not found | Audit phase failed | Retry failed phase or skip |
| Pipeline aborted | User cancelled | Resume at failed phase manually |
| Both audits skipped | Invalid flag combo | Remove conflicting flags |

## Output

**Reports:**
- `{project}-accuracy-audit-YYYYMMDD-HHMM-UTC.md`
- `{project}-quality-audit-YYYYMMDD-HHMM-UTC.md`

**Revised docs:** (if not --audit-only)

## See Also

- [SKILL.md](SKILL.md) - Full documentation
- [doc-accuracy-audit](../doc-accuracy-audit/) - Phase 1
- [doc-quality-audit](../doc-quality-audit/) - Phase 2
- [doc-quality-revise](../doc-quality-revise/) - Phase 3
