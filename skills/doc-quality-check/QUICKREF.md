# doc-quality-check Quick Reference

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
```

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
