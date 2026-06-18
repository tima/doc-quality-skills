# doc-quality-revise Quick Reference

## When to Use

You have an audit report and want to apply fixes.

## Usage
```
/doc-quality-revise [flags]
```

## Flags
```
--accuracy-report <path>    Path to accuracy audit report
--quality-report <path>     Path to quality audit report
--auto-approve              Auto-accept all simple revisions
--interactive-only          Skip auto-revisions, manual only
--dry-run                   Preview without applying changes
```

## Examples

**Auto-discover reports:**
```
/doc-quality-revise
```

**Explicit report paths:**
```
/doc-quality-revise --quality-report my-audit.md
```

**Batch mode (no confirmations):**
```
/doc-quality-revise --auto-approve
```

**Manual review only:**
```
/doc-quality-revise --interactive-only
```

**Preview without changes:**
```
/doc-quality-revise --dry-run
```

## Flag Conflicts

`--auto-approve` and `--interactive-only` cannot be combined.

## Revision Categories

**Auto-revisable (simple):**
- Contractions (don't → do not)
- Word replacements (utilize → use)
- Formatting fixes

**Manual review (complex):**
- Rewrites
- Missing content
- Structural changes

## Common Issues

| Issue | Meaning | Fix |
|-------|---------|-----|
| TEXT_NOT_FOUND | Text changed since audit | Re-run audit or manual fix |
| FILE_READ_ERROR | Can't access file | Check permissions |
| No audit reports found | Auto-discovery failed | Use explicit --*-report flags |

## Output

**Git workflow:** Creates branch, commits per revision

**Non-git workflow:**
- Separate directory (`<doc-root>-revised/`)
- Side-by-side files (`filename-revised.md`)

## See Also

- [SKILL.md](SKILL.md) - Full documentation
- [doc-quality-audit](../doc-quality-audit/) - Generate audit reports
- [doc-accuracy-audit](../doc-accuracy-audit/) - Accuracy reports
