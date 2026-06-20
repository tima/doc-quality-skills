# Phase 1: Parse & Categorize

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

**Config file check:** Follow config loading procedure in [CONFIG.md](../../../CONFIG.md#loading-doc-qualityyml). This skill uses fields: rules.contractions, rules.word_replacements, rules.skip_rules, output.path

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
If a finding doesn't clearly match auto-revisable criteria, default to manual review. Do not prompt the user for classification. Better to review interactively than to auto-apply a questionable change.

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

### Step 1.6: Validate Flags and Summarize

**Flag validation:**
If `auto_approve` AND `interactive_only`: Error "Cannot combine --auto-approve with --interactive-only. Choose one mode."

Present summary to user before proceeding:

```
Parsing Complete

Audit report: <filename>
Documentation root: <doc-root>
Git repository: YES/NO

Findings breakdown:
- Auto-revisable: X findings across Y files
- Manual review: Z findings across W files
- File missing: B findings (will skip)

Proceed with preview? (y/n)
```

If user says **no**: "Aborted. No changes made." Stop here.

If user says **yes**: Continue to Phase 2.
