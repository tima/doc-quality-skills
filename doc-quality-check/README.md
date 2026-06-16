# doc-quality-check

> Part of the [doc-quality-skills](../) family. See the [family README](../README.md) for the complete pipeline.

Pipeline orchestrator that runs the complete documentation quality workflow: accuracy audit → quality audit → apply revisions.

## What It Does

Coordinates three skills in sequence:
1. **doc-accuracy-audit** - Verify docs match source of truth (CLI code, Terraform schema, OpenAPI spec)
2. **doc-quality-audit** - Evaluate style, tone, clarity, plain language compliance
3. **doc-quality-revise** - Apply corrections interactively

All reports are timestamped (YYYYMMDD-HHMM format) to preserve audit history.

## Installation

See [../INSTALL.md](../INSTALL.md) for detailed instructions.

**Quick install:**

```bash
ln -sf ~/projects/doc-quality-skills/doc-quality-check ~/.claude/skills/doc-quality-check
```

## Usage

Invoke from Claude Code:

```
/doc-quality-check path/to/docs
```

Or describe your intent naturally:
- "run the doc quality pipeline on docs/api/"
- "check documentation quality for my CLI"
- "audit and fix docs in docs/terraform/"

## Options

**Phase control:**
- `--skip-accuracy` - Skip accuracy audit, run quality → revise
- `--skip-quality` - Skip quality audit, run accuracy → revise
- `--audit-only` - Run both audits, skip revision phase
- `--accuracy-only` - Run only accuracy audit
- `--quality-only` - Run only quality audit

## Examples

Full pipeline:
```
/doc-quality-check docs/api/
```

Audit without applying fixes:
```
/doc-quality-check docs/api/ --audit-only
```

Quality check only:
```
/doc-quality-check docs/terraform/ --quality-only
```

## Output

Reports are timestamped and saved to current directory:
- `{project}-accuracy-audit-{timestamp}.md`
- `{project}-quality-audit-{timestamp}.md`

Example:
```
api-accuracy-audit-20260615-1430.md
api-quality-audit-20260615-1430.md
```

## Error Recovery

If a phase fails, you'll be offered options:
- Retry the failed phase
- Skip that phase and continue
- Abort the pipeline

Completed work (audit reports) is always preserved.

## Related Skills

- **doc-accuracy-audit** - Standalone accuracy audit
- **doc-quality-audit** - Standalone quality audit
- **doc-quality-revise** - Standalone revision application
