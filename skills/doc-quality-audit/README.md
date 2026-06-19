# doc-quality-audit

Audits documentation for intrinsic quality: tone, style, clarity, and plain language compliance. It evaluates docs against an embedded baseline style guide distilled from IBM Style, PatternFly UX Writing, and Red Hat Technical Writing standards. Findings are evidence-based — every issue is tied to a specific quote and style rule — and annotated with severity and confidence level.

## What it checks

- **Core dimensions (default):** Tone/voice consistency, clarity/readability, structure/flow, consistency, completeness, audience appropriateness, example quality
- **Comprehensive mode (optional):** Adds accessibility, SEO/discoverability, and visual formatting

Sentences over 40 words are flagged Critical; tone shifts, passive voice, and unclear examples are Moderate; polish issues are Minor suggestions.

## Invocation

```
/doc-quality-audit path/to/docs
/doc-quality-audit path/to/docs --dimensions comprehensive
/doc-quality-audit path/to/docs --output custom-report.md
/doc-quality-audit path/to/docs --dry-run
/doc-quality-audit path/to/docs --since HEAD~3
/doc-quality-audit path/to/docs --style-guide path/to/extra-guide.md
```

## Input

- Documentation files or URLs to audit
- Optional: `--dimensions core|comprehensive` to control audit depth
- Optional: additional project-specific style guide files

## Output

Timestamped Markdown report: `{project-name}-quality-audit-YYYYMMDD-HHMM-UTC.md`

Report contains a summary (critical/moderate/minor counts), top issues, findings organized by dimension and file, and a prioritized recommendations section. Compatible as input to `doc-quality-revise`.
