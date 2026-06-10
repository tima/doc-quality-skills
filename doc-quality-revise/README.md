# doc-quality-revise

Claude Code skill for applying corrections from doc-quality-audit reports using semi-automated workflow.

## Overview

The `doc-quality-revise` skill complements `doc-quality-audit` by applying the corrections identified in audit reports. It uses a transparent, safe workflow:

1. **Parse & Categorize** - Classify findings as auto-revisable or manual review
2. **Preview Auto-Revisions** - Show diff, get user approval before changing anything
3. **Apply Auto-Revisions** - Apply simple replacements automatically (git branch or separate output)
4. **Interactive Manual Workflow** - Walk through complex revisions one-by-one with user guidance

## Features

- Semi-automated: Auto-revise simple issues, guide manual review for complex changes
- Safe workflows: Git branch (preserves main) or separate output (preserves originals)
- Transparent: Diff preview before applying, clear progress tracking throughout
- Zero-hallucination: Asks when unclear rather than guessing
- Error handling: Gracefully handles missing files, text mismatches, ambiguous findings

## Installation

### Option 1: Project-Local Installation

Copy the skill to your project's `.claude/skills/` directory:

```bash
# From within your project directory
mkdir -p .claude/skills
cp ~/projects/doc-quality-revise-skill/SKILL.md .claude/skills/doc-quality-revise.md
```

### Option 2: Global Installation

Copy the skill to your global Claude skills directory:

```bash
mkdir -p ~/.claude/skills
cp ~/projects/doc-quality-revise-skill/SKILL.md ~/.claude/skills/doc-quality-revise.md
```

After installation, reload Claude Code to discover the skill.

## Usage

### Prerequisites

1. Run `doc-quality-audit` on your documentation first to generate an audit report
2. Have the documentation files accessible (local paths)
3. Optionally: use git version control for safest workflow (branch-based)

### Basic Usage

In Claude Code, invoke the skill:

```
/doc-quality-revise
```

Or describe what you want:

```
Apply revisions from doc-quality-audit-report.md to my documentation in ~/projects/my-docs/
```

The skill will guide you through:
1. Providing audit report path and doc root directory
2. Reviewing auto-revision diff preview
3. Approving or rejecting auto-revisions
4. Walking through manual revisions interactively

### Workflow Modes

**Git-controlled documentation:**
- Creates branch `doc-quality-revisions-YYYY-MM-DD`
- Applies revisions on branch
- Commits after each change
- You review and merge when ready

**Non-git documentation:**

Choose output strategy:
- **Separate directory** (`docs-revised/`) - Preserves originals, write revised to new dir
- **Side-by-side files** (`filename-revised.md`) - Easy comparison, rename when ready

### Auto-Revisable vs Manual Review

**Auto-revisable (applied automatically after preview):**
- Word replacements: "utilize" -> "use", "prior to" -> "before"
- Contraction expansions: "don't" -> "do not", "can't" -> "cannot"
- Phrase removals: "simply", "please"
- Phrase replacements: "make sure" -> "ensure"
- Title prefix removal: "# How to X" -> "# X"

**Manual review (interactive, one-by-one):**
- Sentence rewrites (anthropomorphism, passive->active)
- Adding missing content (prerequisites, error codes, examples)
- Structural changes (breaking long sentences, list rewrites)
- Anything requiring judgment or domain knowledge

### Example Session

```
User: Apply revisions from audit-report.md to ~/my-docs/

Skill:
Parsing audit report...
Found 15 findings (8 auto-revisable, 7 manual review)

Preview of Auto-Revisions:

File: cli-doc.md (5 revisions)
--- original
+++ revised
@@ Line 5 @@
-utilize
+use

<...more diffs...>

Approve all? (A/B/C)

User: A

Skill:
Creating branch: doc-quality-revisions-2026-06-03
Applied 8 auto-revisions
Committed.

Starting manual review workflow...

Revision 1 of 7: Anthropomorphism
File: cli-doc.md:15
Current: "The system will automatically handle"
Suggestion: "Terraform automatically deploys"
Options: A/B/C/D

User: A

<...continues for all 7 manual revisions...>

Done! Branch: doc-quality-revisions-2026-06-03
Review with: git diff main
```

## Complementary Skills

- **doc-quality-audit** - Run first to generate audit reports
- **cli-doc-audit** - Audit CLI docs against source code for accuracy
- **terraform-provider-audit** - Audit Terraform provider docs for completeness

## Workflow Integration

Recommended workflow for documentation quality:

1. Run `doc-quality-audit` on your docs
2. Review audit report findings
3. Run `doc-quality-revise` to apply corrections
4. Review revised documentation (git diff or compare output)
5. Merge/replace when satisfied
6. Re-run `doc-quality-audit` to verify improvements (optional)

## Error Handling

The skill handles these errors gracefully:

- **File not found** - Skips revision, tracks in summary
- **Text mismatch** - Offers skip/show-content/fuzzy-match options
- **Uncommitted changes** - Warns, offers stash/abort/proceed options
- **Branch conflicts** - Offers rename/delete/abort options
- **Ambiguous findings** - Asks user to classify rather than guessing
- **Interruption** - Preserves work done so far, allows resume

## License

MIT

## Contributing

This skill is part of the docs-quality-skills project. Issues and improvements welcome.

---

**Generated for:** Claude Code  
**Companion skills:** doc-quality-audit, cli-doc-audit, terraform-provider-audit
