# Phase 5: Error Handling and Edge Cases

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

In Phase 1 Step 1.4, if a finding doesn't clearly match auto-revisable criteria: default to manual review. No prompt needed -- the finding will appear in the Phase 4 interactive queue. See Step 1.4.

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

Follow the canonical policy in [CONFIG.md](../../../CONFIG.md#zero-hallucination-policy). In the revision context specifically: ask the user for clarification with specific options, and offer to skip unclear revisions rather than guessing.
