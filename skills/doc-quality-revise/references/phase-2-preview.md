# Phase 2: Preview Auto-Revisions

**Batch mode:** If `--auto-approve` flag: Skip preview/confirmation steps, proceed directly to Phase 3

**Otherwise:**
Generate a diff preview of all auto-revisable changes and get user approval before applying anything.

### Step 2.1: Generate In-Memory Revisions

For each auto-revisable finding:

1. Read the file containing the current text
2. Search for exact match of "Current Text" from audit report
3. If found: replace with "Suggestion" text (in memory only, do not write yet)
4. If not found:
   - **Attempt fuzzy match:**
     - Extract ±20 lines around reported location using Bash: `sed -n 'start,end p' file`
     - For each line, compute word overlap with "Current Text": tokenize both, count common words / total words
     - If any candidate >80% similar:
       - Show: `TEXT_NOT_FOUND: "{original}" - Did you mean: "{candidate}" (line X, 85% match)? (y/n)`
       - If yes: use candidate as "Current Text", proceed with revision
       - If no: skip as below
     - If no good match (all <80%):
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
