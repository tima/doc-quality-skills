# Usage Examples

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
