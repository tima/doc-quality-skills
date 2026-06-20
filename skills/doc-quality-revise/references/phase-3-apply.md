# Phase 3: Apply Auto-Revisions

**Skip check:** If `--interactive-only` flag: Skip this phase entirely, jump to Phase 4

**Dry-run check:** If `--dry-run` flag: Show "DRY RUN: Would apply X auto-revisions to Y files", skip all writes, jump to Phase 4

Apply approved auto-revisions using git branch workflow (if available) or chosen output strategy (if not).

**Batch mode:** If `--auto-approve` flag: Skip preview/confirmation in Phase 2, proceed directly to applying all auto-revisions

### Step 3.1: Determine Output Strategy

**If Git repository detected (from Phase 1):**

Generate branch name: `doc-quality-revisions-<YYYY-MM-DD>`

Check if branch already exists:
```bash
git rev-parse --verify doc-quality-revisions-<date>
```

If exists, offer options:
```
Branch `doc-quality-revisions-<date>` already exists.

Options:
A) Use different name (enter custom branch name)
B) Delete existing branch (WARNING: data loss if unmerged)
C) Abort (stop here, let user handle manually)

Your choice?
```

Create branch:
```bash
git checkout -b doc-quality-revisions-<date>
```

**If NOT a git repository:**

Ask user for output strategy:
```
Documentation is not under version control. Choose output strategy:

B) Separate output directory (e.g., <doc-root>-revised/) - Preserves originals
D) Side-by-side files (e.g., filename-revised.md) - Easy comparison

Your choice?
```

Track chosen strategy for use in Step 3.3.

### Step 3.2: Apply Revisions to Files

For each file with approved auto-revisions:

1. Read the current file content
2. Apply all revisions for this file (replace "Current Text" with "Suggestion")
3. **Git workflow:** Write revised content back to the same file path (overwrites original on branch)
4. **Strategy B (separate directory):** Write revised content to `<doc-root>-revised/<relative-path>` (preserve directory structure)
5. **Strategy D (side-by-side):** Write revised content to `<filename-without-ext>-revised.md` in same directory

Verify each write succeeds before proceeding.

### Step 3.3: Commit Auto-Revisions (Git only)

If using git workflow, create a single commit for all auto-revisions:

Build commit message:
```
docs: apply automated quality revisions

- Replace "utilize" with "use" (<count> instances)
- Remove contractions (<count> instances)
- Replace "prior to" with "before" (<count> instances)
- Remove "make sure", use "ensure" (<count> instances)
- Remove "simply" (<count> instances)
- Remove "please" (<count> instances)
- Remove "How to" title prefixes (<count> instances)

Applied via doc-quality-revise skill

Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
```

Commit:
```bash
git add <all-revised-files>
git commit -m "<commit-message-above>"
```

### Step 3.4: Show Summary

Present summary of what was applied:

**Git workflow:**
```
Auto-Revisions Applied

Files revised: X
Total revisions: Y

Git branch: doc-quality-revisions-<date>
Commit: <sha>

Review changes:
  git diff main

Merge when ready:
  git checkout main && git merge doc-quality-revisions-<date>
```

**Strategy B (separate directory):**
```
Auto-Revisions Applied

Files revised: X
Total revisions: Y

Output directory: <doc-root>-revised/

Compare changes:
  diff -r <doc-root> <doc-root>-revised

Replace originals when ready:
  cp -r <doc-root>-revised/* <doc-root>/
```

**Strategy D (side-by-side):**
```
Auto-Revisions Applied

Files revised: X
Total revisions: Y

Revised files created alongside originals:
- sample-cli-doc-revised.md
- sample-terraform-doc-revised.md

Compare each file:
  diff sample-cli-doc.md sample-cli-doc-revised.md

Replace when ready:
  mv sample-cli-doc-revised.md sample-cli-doc.md
```

Proceed to Phase 4 if there are manual review findings. Otherwise, show final summary and end.
