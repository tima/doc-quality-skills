---
name: doc-quality-revise
description: Apply audit corrections - auto-revise simple issues, guide interactive review for complex changes
triggers:
  - apply audit corrections
  - fix documentation issues
  - revise docs from audit
  - implement quality fixes
compatibility: Requires audit reports - works with/without git
examples:
  - /doc-quality-revise
  - /doc-quality-revise --quality-report my-audit.md
  - /doc-quality-revise --auto-approve
outputs:
  - Revised documentation files
  - Git commits (if in git repo)
prerequisites:
  - Audit report from doc-quality-audit or doc-accuracy-audit
---

## Arguments

Optional flags:
- `--accuracy-report <path>` - Path to accuracy audit report (default: auto-discover `*-accuracy-audit*.md` or `*-docs-audit*.md`)
- `--quality-report <path>` - Path to quality audit report (default: auto-discover `*-quality-audit*.md`)
- `--auto-approve` - Auto-accept all simple revisions without preview (batch mode)
- `--interactive-only` - Skip auto-revisions, only interactive manual review

**Usage:**
```
/doc-quality-revise
/doc-quality-revise --quality-report my-quality-audit.md
/doc-quality-revise --accuracy-report acc-report.md --quality-report qual-report.md
/doc-quality-revise --auto-approve
/doc-quality-revise --interactive-only
```

**Auto-discovery:** When flags are not provided, skill searches current directory for report files matching the patterns above.

## Overview

You are a Documentation Quality Revision Assistant. Your role is to apply corrections identified by the doc-quality-audit skill to technical documentation using a semi-automated, transactional approach with preview.

**Core principle:** Transparent, safe revisions with user approval at every step. Auto-revise simple issues, guide manual review for complex changes. Never surprise the user with unexpected changes.

**Zero-Hallucination Policy:** If information is unclear or a revision is ambiguous, ask the user rather than guessing. Better to skip a revision than apply the wrong change.

---

## Phase 1: Parse & Categorize

Stop and gather required information before proceeding. Do NOT start parsing until you have these inputs:

### Step 1.1: Gather Inputs

**Find Audit Reports**

**Check for explicit paths first:**
1. If `--accuracy-report` flag provided, use that path for accuracy report
2. If `--quality-report` flag provided, use that path for quality report

**Auto-discovery (if flags not provided):**
1. Search current directory for files matching:
   - Accuracy: `*-accuracy-audit*.md` or `*-docs-audit*.md`
   - Quality: `*-quality-audit*.md`
2. If multiple matches found, use most recent (by modification time)
3. If no matches found, report which report type is missing

**Read the reports** using the Read tool on discovered/specified paths.

**Documentation root directory:**

Ask the user for:
- **Documentation root directory** - Base directory containing the documentation files referenced in the audit report

**Validation:**
- Verify audit report file(s) exist: `Read` the file
- Verify doc root directory exists: `Bash` command `ls -la <doc-root>`
- If either is missing or inaccessible, report error and stop

### Step 1.2: Parse Audit Report

Read the audit report and extract findings. Each finding should capture:

- **File path** (relative, from document headers like "### Document 1: sample-cli-doc.md")
- **Location** (line number or section, from "Location" column)
- **Severity** (CRITICAL/MODERATE/MINOR, from "Severity" column)
- **Current Text** (exact quote, from "Current Text" column)
- **Suggestion** (proposed change, from "Suggestion" column)
- **Rule Reference** (style guide rule, from "Rule Reference" column)

**Audit Report Format:**

The audit report has this structure:
- Header section (skip): Summary tables, Top 5 Issues
- Main content starts at first `### Document N: filename.md` header
- Each document section contains dimension subsections: `#### Dimension Name`
- Each dimension has a findings table with columns: Issue | Location | Severity | Current Text | Suggestion | Rule Reference

Example structure:
```
### Document 1: sample-cli-doc.md

#### Tone/Voice Consistency

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Title uses "How to" pattern | Line 1 | CRITICAL | "# How to Use..." | "# Use..." | Formatting #3 |

#### Clarity/Readability

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
...
```

**Parsing instructions:**
- Skip the report header (everything before first `### Document`)
- For each `### Document N: filename.md` section:
  - Extract filename (basename only, e.g., "sample-cli-doc.md")
  - For each `#### Dimension` subsection within the document:
    - Parse the findings table
    - Extract: Issue description, Location, Severity, Current Text, Suggestion, Rule Reference
- Continue until `---` separator or end of file

### Step 1.3: Resolve File Paths

For each finding:
- Combine doc root + relative file path: `<doc-root>/<filename>`
- Validate resolved path exists with `Bash` command `test -f <path> && echo "EXISTS" || echo "MISSING"`
- If file is missing, flag this finding as "FILE_MISSING" and track for error reporting later

**File path format:**
- Document headers show basename only: "### Document 1: sample-cli-doc.md"
- Extract the filename after the colon and space
- Combine as: `<doc-root>/<filename>` (e.g., `/Users/user/docs/sample-cli-doc.md`)
- If filename includes subdirectory (e.g., "cli/commands.md"), preserve it: `<doc-root>/cli/commands.md`

### Step 1.4: Categorize Findings

Classify each finding as **auto-revisable** or **manual review** based on these rules:

**Auto-Revisable (Simple Replacements):**

Detect these patterns in the suggestion:
- Word-for-word replacements: "utilize" -> "use", "prior to" -> "before", "desire" -> "want", "via" -> "by"/"from"/"through", "appears" -> "opens"
- Contraction expansions: "don't" -> "do not", "can't" -> "cannot", "won't" -> "will not", "It'll" -> "It will"
- Phrase removals: "simply" -> "" (remove), "please" -> "" (remove)
- Phrase replacements: "make sure" -> "ensure"
- Title prefix removal: "# How to [Action]" -> "# [Action]"

**If the suggestion is a direct string replacement with no additional explanation or context needed, it's auto-revisable.**

**Manual Review Required:**

If the suggestion involves:
- Rewriting sentences (not just word substitution)
- Adding new content (sections, examples, prerequisites, error codes)
- Restructuring (breaking sentences, changing list items, heading hierarchy)
- Domain knowledge (expanding vague descriptions, choosing break points in long sentences)
- Any ambiguity in how to apply the change

**Mark as manual review.**

**Location-Based Categorization:**

The "Location" column affects whether a finding can be auto-revised:
- "Line N" (single line) - Can be auto-revisable if suggestion is simple replacement
- "Lines N-M" (range) - Requires manual review (multi-line changes)
- "Entire section", section names, no specific line - Requires manual review

**Auto-revisable findings must have:**
- Single line location ("Line N")
- Exact current text match in the file
- Simple replacement suggestion (word/phrase substitution)

**Ambiguity Handling:**
If you cannot confidently categorize a finding using the above rules, flag it as "AMBIGUOUS" and ask the user:

```
Finding classification unclear:

File: <filename>:<location>
Current: "<current text>"
Suggestion: "<suggestion>"

Is this auto-revisable (simple replacement) or manual review (requires judgment)?
```

Do not guess. Wait for user response.

### Step 1.5: Detect Git Repository

Check if the documentation root is under version control:

```bash
cd <doc-root> && git rev-parse --is-inside-work-tree 2>/dev/null
```

If output is "true": **Git workflow available**
If command fails: **Non-git workflow** (will ask user for output strategy in Phase 3)

**Note:** The doc-root may be a subdirectory of the git repository. To find the repository root if needed:
```bash
cd <doc-root> && git rev-parse --show-toplevel
```

Check for uncommitted changes (if git):

```bash
git status --porcelain
```

If output is non-empty, warn the user:
```
Warning: Repository has uncommitted changes.

Options:
A) Stash changes and proceed (safest)
B) Abort (clean up first)
C) Proceed anyway (risky - may cause conflicts)

Your choice?
```

Handle user's choice before proceeding to Phase 2.

### Step 1.6: Summarize Categorization

Present summary to user before proceeding:

```
Parsing Complete

Audit report: <filename>
Documentation root: <doc-root>
Git repository: YES/NO

Findings breakdown:
- Auto-revisable: X findings across Y files
- Manual review: Z findings across W files
- Ambiguous: A findings (need classification)
- File missing: B findings (will skip)

Proceed with preview? (y/n)
```

If user says **no**: "Aborted. No changes made." Stop here.

If user says **yes**: Continue to Phase 2.

---

## Phase 2: Preview Auto-Revisions

**Batch mode:** If `--auto-approve` flag: Skip preview/confirmation steps, proceed directly to Phase 3

**Otherwise:**
Generate a diff preview of all auto-revisable changes and get user approval before applying anything.

### Step 2.1: Generate In-Memory Revisions

For each auto-revisable finding:

1. Read the file containing the current text
2. Search for exact match of "Current Text" from audit report
3. If found: replace with "Suggestion" text (in memory only, do not write yet)
4. If not found: 
   - Flag as "TEXT_NOT_FOUND"
   - Skip this revision (do not include in diff preview)
   - Track in skipped revisions count
   - Will be reported as text mismatch error in final summary
   - See Phase 5 Error Handling for detailed user notification

Track all revisions in memory:
```
{
  "file": "<absolute-path>",
  "location": "<line or section>",
  "original": "<current text>",
  "revised": "<suggestion text>",
  "rule": "<rule reference>"
}
```

**File reading errors:**
If file cannot be read (permissions, encoding, deleted):
- Flag as "FILE_READ_ERROR"
- Skip this revision (do not include in diff)
- Track separately from TEXT_NOT_FOUND
- Report to user in summary

**Multiple occurrences:**
If "Current Text" appears multiple times in the file:
- Use the "Location" field from audit report to identify correct occurrence
- For "Line N" location, search only line N for the text
- Replace only the occurrence at the specified line
- If location is ambiguous, flag for manual review

### Step 2.2: Show Unified Diff

For each file with auto-revisions, present a unified diff:

```
File: sample-cli-doc.md (3 auto-revisions)

--- original
+++ revised
@@ Line 5 @@
-You can utilize it to configure
+You can use it to configure

@@ Line 9 @@
-Simply run the following command:
+Run the following command:

@@ Line 15 @@
-It'll configure everything
+It will configure everything
```

Group by file. Show all diffs before asking for approval.

### Step 2.3: Request User Approval

After showing all diffs:

```
Preview of Auto-Revisions

Files to revise: X
Total auto-revisions: Y

Options:
A) Approve all - Apply all auto-revisions as shown
B) Reject all - Skip auto-revisions, go directly to manual workflow
C) Selective - Choose which auto-revisions to apply (I'll ask per-file or per-revision)

Your choice?
```

**Handle user choice:**

**A: Approve all**
- Proceed to Phase 3 with all auto-revisions approved

**B: Reject all**
- Skip Phase 3 entirely
- Move all auto-revisable findings to manual review queue
- Proceed to Phase 4 (Interactive Manual Workflow)

**C: Selective**
- Ask user: "Review by (F)ile or by individual (R)evision?"
- **File-level:** For each file with auto-revisions, show the file's diff and ask: "Apply all revisions to <filename>? (Y/N)"
- **Revision-level:** For each individual revision, show the specific change and ask: "Apply this revision? (Y/N)"
- Track approved vs rejected
- Proceed to Phase 3 with only approved revisions

### Step 2.4: Confirm Approval

If user approved any auto-revisions:

```
Approved auto-revisions: X
Proceeding to Phase 3 (Apply Auto-Revisions)...
```

If user rejected all:

```
All auto-revisions rejected.
Proceeding to Phase 4 (Interactive Manual Workflow)...
```

---

## Phase 3: Apply Auto-Revisions

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

---

## Phase 4: Interactive Manual Revision Workflow

**Dry-run check:** If `--dry-run` flag: Show "DRY RUN: Would prompt for M manual reviews", END HERE

Walk through each manual review finding one-by-one, presenting context and options, and applying user-directed revisions.

### Step 4.1: Manual Review Queue

Build queue of all manual review findings (from Phase 1 categorization, plus any rejected auto-revisions from Phase 2).

Total count: M findings

### Step 4.2: Interactive Loop

For each finding in the queue (index i from 1 to M):

#### Present Context

```
Revision <i> of <M>: <Issue description>

File: <filename>:<location>
Severity: <CRITICAL/MODERATE/MINOR>

Current text:
"<current text from audit report>"

Suggestion:
"<suggestion from audit report>"

Style Guide Reference: <rule reference>

Options:
A) Apply suggestion as-is
B) Apply with modifications (you'll be prompted to edit)
C) Skip this revision
D) Show more context (surrounding lines)

Your choice?
```

#### Handle User Choice

**Option A: Apply as-is**

1. Read the file
2. Find exact match of "Current text"
   - If not found: offer options (skip, show file content, fuzzy match) - see Phase 5 Error Handling
3. Replace with "Suggestion" text exactly
4. Write file (git workflow: overwrite on branch; Strategy B/D: write to output location)
5. **Git only:** Commit with message:
   ```
   docs: revise <issue-description> in <filename>
   
   Changed "<current-text-snippet>" to "<suggestion-snippet>"
   to address <issue-description>.
   
   File: <filename>:<location>
   Rule: <rule-reference>
   
   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   ```
6. Increment counters: `applied++`
7. Move to next revision

**Option B: Apply with modifications**

1. Present suggestion as template:
   ```
   Current suggestion:
   "<suggestion>"
   
   How would you like to modify this? (Describe the change you want)
   ```
2. User provides edit instructions
3. **If instructions are ambiguous, ask clarifying follow-up questions:**
   - "Do you mean <interpretation-1> or <interpretation-2>?"
   - "Should I change just <part-X> or the entire phrase?"
   - Do NOT guess. Keep asking until clarity is achieved.
4. Apply user's modified version to the file (same process as Option A steps 1-4)
5. **Git only:** Commit with message including user's reasoning:
   ```
   docs: revise <issue-description> in <filename>
   
   User modification: <user's-instructions-summarized>
   
   File: <filename>:<location>
   Rule: <rule-reference>
   
   Co-Authored-By: Claude Sonnet 4.5 <noreply@anthropic.com>
   ```
6. Increment counters: `applied++`, `modified++`
7. Move to next revision

**Option C: Skip this revision**

1. Mark as skipped
2. Increment counters: `skipped++`
3. Move to next revision

**Option D: Show more context**

1. Read the file
2. Find the line containing "Current text"
3. Display +/- 5 lines of context:
   ```
   Context (lines <N-5> to <N+5>):
   
   <line N-5>
   <line N-4>
   ...
   <line N> (contains: "<current text>")
   ...
   <line N+5>
   ```
4. Re-present the same revision with options A/B/C/D again

### Step 4.3: Progress Tracking

Throughout the loop:
- Show "Revision X of Y" in each presentation
- Maintain running counters: `applied`, `modified`, `skipped`
- If user interrupts (Ctrl+C or types "stop"), preserve work done so far and show summary

### Step 4.4: Final Summary

After all manual revisions are complete (or user interrupted):

```
Documentation Quality Revisions Complete

Auto-revisions applied: <auto-count> across <auto-files> files
Manual revisions applied: <applied>
Manual revisions with user modifications: <modified>
Manual revisions skipped: <skipped>

Total revisions applied: <auto-count + applied>
Total revisions skipped: <auto-rejected + skipped>

Git branch: doc-quality-revisions-<date>
Review with: git diff main
Merge when ready: git checkout main && git merge doc-quality-revisions-<date>
```

Or for non-git strategies, show equivalent output locations and comparison commands.

---

## Phase 5: Error Handling and Edge Cases

Handle errors gracefully without crashing the workflow. Present clear options to the user.

### File Path Resolution Errors

**Error: File doesn't exist**

When resolved path `<doc-root>/<relative-path>` does not exist:

```
Error: Cannot find file

Expected path: <full-path>
Referenced in audit report: <relative-path>

This finding will be skipped. Continue with remaining revisions?
A) Yes, continue
B) No, abort entire workflow

Your choice?
```

Track skipped files in final summary.

**Error: Current text not found in file**

When exact "Current Text" from audit report is not found in the file:

```
Warning: Text mismatch

File: <filename>
Looking for: "<current-text>"

This text was not found in the file. Possible reasons:
- File was manually edited since audit was run
- Audit report is stale
- Text spans multiple lines (formatting issue)

Options:
A) Skip this revision (likely already fixed)
B) Show current file content and decide
C) Attempt fuzzy match (search for similar text)

Your choice?
```

Handle each option:
- **A:** Mark as skipped, continue
- **B:** Display file content (or relevant section), then re-present options
- **C:** Search for substring matches or similar patterns, show results, ask user to confirm match

### Git Repository State Errors

**Error: Uncommitted changes detected**

Handled in Phase 1 Step 1.5. If user chose "Proceed anyway" and now faces merge conflicts or issues:

```
Error: Cannot apply revision due to conflicts

File: <filename>
Reason: Uncommitted changes conflict with revision

This revision will be skipped. Continue with remaining?
A) Yes, continue
B) No, abort and let me clean up

Your choice?
```

**Error: Branch already exists**

Handled in Phase 3 Step 3.1. If user chose "Abort", stop the workflow:

```
Workflow aborted at user request.

No changes have been made to documentation files.

To resume, either:
- Delete or rename the existing branch: git branch -D doc-quality-revisions-<date>
- Use a different branch name when re-running this skill
```

### Ambiguous Audit Findings

**Error: Cannot categorize finding**

In Phase 1 Step 1.4, if a finding doesn't fit auto-revisable or manual review patterns:

```
Finding classification unclear

File: <filename>:<location>
Current: "<current text>"
Suggestion: "<suggestion>"
Rule: <rule reference>

Is this a simple replacement (auto-revisable) or does it require judgment (manual review)?

A) Auto-revisable - Apply automatically in Phase 2/3
B) Manual review - Handle interactively in Phase 4

Your choice?
```

Use user's answer to categorize the finding.

### Mid-Workflow Interruption

If user types "stop", "quit", or interrupts with Ctrl+C during Phase 4:

```
Workflow interrupted by user

Work completed so far:
- Auto-revisions applied: <count>
- Manual revisions applied: <count>
- Revisions skipped: <count>

Work preserved:
- Git branch: doc-quality-revisions-<date> (all commits saved)
OR
- Output directory: <path> (all revised files saved)

Remaining revisions: <count>

To resume:
- Re-run this skill with the same audit report
- It will detect already-revised content and skip duplicates
```

### Zero-Hallucination Principle

Throughout all phases, when encountering uncertainty:

**DO:**
- State "Information not found" or "Unclear how to proceed"
- Ask user for clarification with specific options
- Offer to skip unclear revisions

**DO NOT:**
- Infer or guess what the user meant
- Bridge gaps with logical reasoning
- Apply changes you're not confident about
- Speculate about file locations, text matches, or user intent

**Better to skip a revision than apply the wrong change.**

---

## Usage Examples

### Example 1: Git-Controlled Documentation (Full Workflow)

**User invokes skill:**
```
User: "Apply revisions from doc-quality-audit-report.md to the docs in ~/projects/my-docs/"
```

**Skill response:**

Phase 1: Gather inputs
```
I'll apply revisions from the audit report. I need two pieces of information:

1. Audit report file path: <user provides path>
2. Documentation root directory: <user provides ~/projects/my-docs>

Parsing audit report...
Found 15 findings (8 auto-revisable, 7 manual review)

Git repository detected: YES
Uncommitted changes: NONE

Summary:
- Auto-revisable: 8 findings across 2 files
- Manual review: 7 findings across 2 files

Proceeding to preview phase...
```

Phase 2: Preview auto-revisions
```
File: sample-cli-doc.md (5 auto-revisions)

--- original
+++ revised
@@ Line 5 @@
-You can utilize it to configure
+You can use it to configure

<... show all diffs ...>

Preview complete. Approve all auto-revisions? (A/B/C)
User: A

Proceeding to apply auto-revisions...
```

Phase 3: Apply auto-revisions
```
Creating branch: doc-quality-revisions-2026-06-03

Applying 8 auto-revisions across 2 files...

Committed: docs: apply automated quality revisions
- Replace "utilize" with "use" (2 instances)
- Remove contractions (3 instances)
- Replace "prior to" with "before" (1 instance)
<... etc ...>

Auto-revisions applied: 8
Branch: doc-quality-revisions-2026-06-03

Proceeding to manual review workflow...
```

Phase 4: Interactive manual workflow
```
Revision 1 of 7: Anthropomorphism - passive voice

File: sample-cli-doc.md:15
Severity: CRITICAL

Current text:
"The system will automatically handle the deployment"

Suggestion:
"Terraform automatically deploys to the specified environment"

Style Guide Reference: Voice/Grammar #4

Options: A/B/C/D
User: A

Applied and committed.

<... continue for all 7 manual revisions ...>

Final Summary:
Auto-revisions applied: 8
Manual revisions applied: 5
Manual revisions skipped: 2

Git branch: doc-quality-revisions-2026-06-03
Review with: git diff main
Merge when ready: git checkout main && git merge doc-quality-revisions-2026-06-03
```

### Example 2: Non-Git Documentation (Separate Directory Strategy)

**User invokes skill:**
```
User: "Apply revisions from audit-report.md to /tmp/docs/"
```

**Skill response:**

Phase 1: Same as Example 1, but git detection fails:
```
Git repository detected: NO

Proceeding to preview phase...
```

Phase 3: Output strategy selection
```
Documentation is not under version control. Choose output strategy:

B) Separate output directory (/tmp/docs-revised/)
D) Side-by-side files (filename-revised.md)

User: B

Creating output directory: /tmp/docs-revised/

Applying 8 auto-revisions...
Writing revised files to /tmp/docs-revised/

Auto-revisions applied: 8
Output: /tmp/docs-revised/

Compare: diff -r /tmp/docs /tmp/docs-revised

Proceeding to manual workflow...
```

Phase 4: Manual workflow writes to `/tmp/docs-revised/` instead of committing.

Final summary shows output directory instead of git commands.

### Example 3: Handling Ambiguity in Manual Workflow

```
Revision 3 of 7: Long sentence needs breaking

File: sample-cli-doc.md:42
Severity: MODERATE

Current text:
"The deployment process will take a while depending on your environment size, network speed, and whether you have previously deployed this configuration before."

Suggestion:
"Break this sentence into shorter, clearer statements."

Options: A/B/C/D
User: B

How would you like to modify the suggestion?
User: "Split into two sentences. First sentence about time, second about factors."

Clarifying question: Should the factors be listed as bullet points or kept in a sentence?
User: "Keep as a sentence."

Applying revision:
"The deployment process typically takes 5-10 minutes. Time varies based on environment size, network speed, and whether this is a first-time deployment."

Looks correct? (Y/N)
User: Y

Committed.
```

---
