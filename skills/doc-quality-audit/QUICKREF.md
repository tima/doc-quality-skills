# doc-quality-audit Quick Reference

## When to Use

Docs need style, tone, clarity, or readability review.

## Usage
```
/doc-quality-audit <path> [flags]
```

## Flags
```
--output <filename>     Override default report filename
--dry-run               Show report without saving
--since <git-ref>       Audit only files changed since ref
--dimensions <core|comprehensive>  Skip dimension prompt
--style-guide <path>    Additional style guide (skip prompt)
```

## Examples

**Basic quality audit:**
```
/doc-quality-audit docs/
```

**Custom output:**
```
/doc-quality-audit docs/ --output quality-report.md
```

**Incremental (changed files only):**
```
/doc-quality-audit docs/ --since HEAD~1
```

**Dry run (preview only):**
```
/doc-quality-audit docs/ --dry-run
```

## Quality Dimensions

**Default (7 dimensions):**
- Tone/Voice Consistency
- Clarity/Readability
- Structure/Flow
- Consistency
- Completeness
- Audience Appropriateness
- Example Quality

**Comprehensive mode adds 3 more:**
- Accessibility
- SEO/Discoverability
- Visual Formatting

Skill prompts for mode selection at start.

## Common Issues

| Issue | Meaning | Fix |
|-------|---------|-----|
| File not found | Path incorrect | Verify documentation path |
| Parse error | Malformed markdown | Check file syntax |
| No issues found | Clean docs or skipped | Review scope confirmation |

## Output

**Filename:** `{project}-quality-audit-YYYYMMDD-HHMM-UTC.md`

**Location:** Current directory

**Contains:**
- Issues by severity (Critical/Moderate/Minor)
- Findings by dimension
- Recommendations

## See Also

- [SKILL.md](SKILL.md) - Full documentation
- [style-guide.md](style-guide.md) - Baseline style rules
- [doc-accuracy-audit](../doc-accuracy-audit/) - Accuracy audit
- [doc-quality-revise](../doc-quality-revise/) - Apply fixes
