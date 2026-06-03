# Doc Quality Audit Skill

Audit technical documentation for tone, style, clarity, and flow with embedded baseline style guide.

## Features

- 10 quality dimensions (7 core, 3 comprehensive)
- Embedded baseline style guide (IBM, PatternFly, Red Hat)
- Honest, direct constructive criticism
- Evidence-based findings with severity classification
- Interactive report delivery (summary + optional detailed report)
- Subagent-based parallel processing for large doc sets (50+ files)
- Context-aware doc type detection (CLI, Terraform, API, tutorials)

## Installation

Copy `doc-quality-audit.md` to your Claude Code skills directory:

```bash
# For user-wide installation
cp doc-quality-audit.md ~/.claude/skills/

# Or for project-specific installation
cp doc-quality-audit.md .claude/skills/
```

Test documentation files are located in `test-docs/` within this repository.

## Usage

```
/doc-quality-audit
```

Skill will prompt for:
1. Documentation sources (paths or URLs)
2. Quality dimensions (core or comprehensive)
3. Optional additional style guides

## Quality Dimensions

**Core (default):**
1. Tone/Voice Consistency
2. Clarity/Readability (plain language focus)
3. Structure/Flow
4. Consistency
5. Completeness
6. Audience Appropriateness
7. Example Quality

**Comprehensive (+3 more):**
8. Accessibility
9. SEO/Discoverability
10. Visual Formatting

## Output

**Screen summary:** Shows immediately with top 5 issues and findings count

**Full report (optional):** Markdown file with all findings organized by dimension, including:
- Severity (Critical/Moderate/Minor)
- Location (file:section)
- Current text quote
- Suggested fix
- Style guide reference

## Testing

Test with sample docs (from this repository):
```
/doc-quality-audit
```
Provide: `test-docs/sample-cli-doc.md` or `test-docs/sample-terraform-doc.md`

Both test files contain intentional quality issues for validation.

## Complementary Skills

- `cli-doc-audit` - Verifies CLI docs match source code
- `terraform-provider-audit` - Verifies Terraform docs match provider schema

This skill focuses on quality/style, not technical accuracy.
