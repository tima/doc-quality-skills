# Phase 4: Interactive Manual Revision

**Dry-run check:** If `--dry-run` flag: Show "DRY RUN: Would prompt for M manual reviews", END HERE

Walk through each manual review finding one-by-one, presenting context and options, and applying user-directed revisions.

### Step 4.1: Manual Review Queue

Build queue of all manual review findings (from Phase 1 categorization, plus any rejected auto-revisions from Phase 2).

Total count: M findings

**Batch options (present before entering interactive loop):**

```
Manual Revisions: M findings

Options:
A) Review one-by-one (interactive)
B) Apply all suggestions as-is (batch approve)
C) Skip all manual revisions
D) Filter by severity (review only CRITICAL, skip rest)

Your choice?
```

- Option A: enter interactive loop below
- Option B: apply all suggestions without prompting, commit each, skip to Step 4.4
- Option C: skip entire Phase 4, go to Step 4.4 summary
- Option D: filter queue to CRITICAL only, enter interactive loop with reduced set

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
E) Apply all remaining as-is (batch approve rest)

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
4. Re-present the same revision with options A/B/C/D/E again

**Option E: Apply all remaining**

1. Apply current revision as-is (same as Option A)
2. For all remaining revisions in queue: apply suggestion as-is without prompting
3. Commit each revision (git workflow) or write to output location
4. Skip to Step 4.4 summary

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
