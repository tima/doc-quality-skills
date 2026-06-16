# Documentation Quality Audit Skill Design

**Date:** 2026-06-03  
**Skill Name:** doc-quality-audit  
**Purpose:** Audit documentation for tone, style, clarity, and flow - complementary to cli-doc-audit and terraform-provider-audit which focus on technical accuracy

---

## Overview

This skill performs quality audits on technical documentation to identify issues with tone, style, clarity, flow, consistency, completeness, audience appropriateness, and example quality. Unlike the technical audit skills (cli-doc-audit, terraform-provider-audit), which verify that documentation matches implementation, this skill evaluates how effectively documentation communicates to readers.

**Primary Use Cases:**
- Pre-release quality gate: catch documentation quality issues before publishing
- Ongoing maintenance: periodic audits to identify quality drift over time
- Migration/rewrite support: evaluate current state before doc overhaul (secondary)

**Key Principles:**
- Honest, direct constructive criticism: provide clear, actionable feedback without sugar-coating issues
- Standalone operation: does not depend on source code or prior technical audits
- Universal quality checks: applies same dimensions across all doc types
- Evidence-based findings: every issue includes specific quotes and locations
- Zero-hallucination policy: label subjective judgments, state gaps explicitly
- Interactive reporting: summary on screen, detailed report to markdown file
- Designed for global audiences: emphasis on plain language for non-native English speakers

---

## Skill Structure & Workflow

The skill follows a four-phase workflow:

### Phase 1: Context Gathering

Ask user for:
1. **Documentation sources** - URLs, local paths, or mixed
2. **Quality dimensions to audit** - Default to core set (7 dimensions), option to add comprehensive set (+3 dimensions)
3. **Optional additional style guides** - Beyond the embedded baseline, if user has project-specific guides

**Embedded Baseline:**
The skill includes an embedded baseline style guide (distilled from IBM Style, PatternFly UX Writing, Red Hat Technical Writing Style Guide, and industry best practices). This ensures consistent baseline checks across all audits.

If user provides additional style guides, skill uses both embedded baseline + user-provided guides.

### Phase 2: Scope Confirmation

Show what will be audited:
- Document count
- Dimension list (which of the 10 dimensions are active)
- Estimated time based on doc size

Ask for confirmation: "Proceed with full audit, or narrow scope?"

Offer to narrow if dealing with large doc sets (e.g., "audit just the getting-started guides first, expand later").

### Phase 3: Audit Execution

Analyze each document against selected dimensions. Track findings by:
- Dimension (tone, clarity, structure, etc.)
- Severity (critical, moderate, minor)
- Location (file, section, line if available)

Apply strict adherence rules:
- **Zero-Hallucination Policy:** If information unavailable or judgment is subjective, state explicitly
- **Contradiction Flagging:** If conflicting data, present both sides
- **Uncertainty Labeling:** Prefix subjective findings with "Suggestion" vs. "Issue"
- **Ambiguity Stops:** If encountering genuine ambiguity, ask for clarification

### Phase 4: Report Delivery (Interactive)

**Step 1 - Screen Summary:**
Show immediately after audit completes:
- Docs audited count
- Total findings by severity (X critical, X moderate, X minor)
- Breakdown by dimension (e.g., "12 clarity issues, 8 consistency issues")
- Top 3-5 most impactful findings with brief description
- Estimated time to review full report

**Step 2 - User Choice:**
"Save detailed report to file?"
- If yes: generate markdown file with full findings
- If no: user can work from summary, run again later if needed

---

## Quality Dimensions

### Core Dimensions (default, always checked):

1. **Tone/Voice Consistency**
   - Flag shifts between formal/informal, passive/active voice, second-person/third-person
   - Check if tone matches intended audience
   - Verify consistency across document set

2. **Clarity/Readability**
   - Identify jargon without definitions
   - Flag overly complex sentences (25+ words)
   - Spot unclear pronoun references, ambiguous phrasing
   - Flag walls of text without breaks
   - **Emphasis on plain language for global audiences**

3. **Structure/Flow**
   - Check for logical progression
   - Identify missing transitions, orphaned sections
   - Flag poor heading hierarchy
   - Verify clear navigation paths

4. **Consistency**
   - Spot terminology variations (same concept, different names)
   - Flag formatting inconsistencies (code blocks, lists, emphasis)
   - Identify inconsistent example patterns
   - Check consistent capitalization, punctuation

5. **Completeness**
   - Identify missing prerequisites
   - Flag incomplete procedures
   - Spot examples without explanation
   - Find assertions without evidence, dangling references

6. **Audience Appropriateness**
   - Flag assumed knowledge not typical for target audience
   - Spot missing context for beginners
   - Identify over-simplification for advanced users

7. **Example Quality**
   - Check if examples are realistic and complete
   - Verify examples are properly explained
   - Ensure diverse coverage of common use cases

### Comprehensive Add-ons (opt-in):

8. **Accessibility**
   - Alt text for images
   - Clear link text (not "click here")
   - Proper heading structure for screen readers
   - Color-independent information

9. **SEO/Discoverability**
   - Descriptive titles
   - Front-loaded important keywords
   - Clear section headings
   - Searchable terminology

10. **Visual Formatting**
    - Code block language tags
    - Consistent indentation
    - Proper table formatting
    - Appropriate use of callouts/warnings

**Tagging:**
Each finding is tagged with:
- Dimension
- Severity (critical/moderate/minor)
- Location (file, section, line if available)
- Suggested improvement
- Style guide reference (if applicable)

---

## Report Format & Severity Classification

### Severity Levels

**Critical** - Issues that block understanding or cause user confusion
- Contradictory instructions
- Missing essential context
- Broken flow in procedures
- Terminology used before definition
- Sentences exceeding plain language limits (40+ words)

**Moderate** - Issues that reduce effectiveness but don't block understanding
- Inconsistent terminology
- Tone shifts
- Unclear examples
- Poor structure requiring re-reading
- Passive voice where active is appropriate

**Minor** - Polish issues that don't impact comprehension
- Minor formatting inconsistencies
- Stylistic preferences
- Minor readability improvements

### Markdown Report Structure

```markdown
# Documentation Quality Audit: [Project/Tool Name]

## Summary
- Docs audited: X files
- Dimensions checked: [list]
- Total findings: X critical, X moderate, X minor
- Audit date: [timestamp]

## High-Priority Issues
[Top 5-10 findings that should be addressed first, sorted by impact]

## Findings by Dimension

### Tone/Voice Consistency
[Findings grouped by file/section]

### Clarity/Readability
[Findings grouped by file/section]

### Structure/Flow
[Findings grouped by file/section]

[...etc for each dimension audited...]

## Recommendations
[Prioritized action items for doc maintainers]
- High priority: [critical fixes]
- Medium priority: [moderate improvements]
- Low priority: [polish items]

---
**Report Generated By:** Anthropic | Claude Sonnet 4.5 | [Timestamp in MMM-DD-YYYY HH:MM GMT format]
```

### Finding Format

Each finding formatted as:
```markdown
**Issue:** [Clear description of the problem]
**Location:** [File:section or line reference]
**Severity:** [Critical/Moderate/Minor]
**Current Text:** [Quote of problematic text]
**Suggestion:** [How to fix, with example if applicable]
**Style Guide Reference:** [Embedded rule or user-provided guide citation, if applicable]
```

### File Naming

Default file path: current working directory  
Filename pattern: `{project-name}-quality-audit.md`

Before saving: Check if file exists
- If exists: ask user whether to overwrite, create new version, or use different filename

---

## Embedded Baseline Style Guide

The skill includes an embedded baseline style guide organized into four sections. During audit, the skill references these rules when evaluating each dimension. Findings cite specific embedded rules when applicable.

### Section 1: Plain Language for Global Audiences

**Critical for non-native English speakers**

1. Keep sentences under 25 words (40 words absolute maximum)
2. Use simple, common words (avoid "utilize" - use "use", "prior to" - use "before")
3. No idioms or colloquialisms ("kick the tires", "ballpark figure", "hit the ground running")
4. Define acronyms on first use, every time
5. Avoid culturally-specific references
6. Use concrete examples, not abstract concepts
7. Break complex ideas into numbered steps
8. Avoid compound sentences with multiple subordinate clauses
9. No jargon without immediate definition
10. Include "that" in clauses to aid non-English speakers (e.g., "Verify that your directory service is working")
11. Use "this/that/these/those" with nouns for clarity (e.g., "this action", not just "this")
12. No phrasal verbs when single verbs exist (set up -> configure, speed up -> accelerate, fill in -> complete, make sure -> ensure)
13. Avoid Latin abbreviations (e.g., i.e., etc.) - use full English equivalents
14. No contractions (don't, can't, won't)
15. Choose standard subject-verb-object word order to reduce ambiguity

### Section 2: Voice and Grammar Rules

**From IBM Style, PatternFly, Red Hat Style Guide**

1. **Active voice preferred** - Use active voice unless passive is necessary to avoid blaming user or when actor is unknown
2. **Present tense** - Avoid future tense (will) unless absolutely necessary
3. **Second person** - Use "you/your" for instructions, not "the user"
4. **No anthropomorphism** - Don't give human characteristics to products. Avoid verbs: allow, let, permit, enable. Focus on what *users* do, not what *products* do.
5. **Complete sentences** - Always use complete sentences to introduce lists, code blocks, commands, or examples
6. **Parallel structure** - List items must follow same grammatical format (same part of speech, tense, voice)
7. **No causative verbs** - Avoid "have something happen" constructions. Describe actual actions.
8. **Avoid "following" without a noun** - Use "following" with a noun (e.g., "the following interfaces")
9. **Include "that" in clauses** - Makes sentences clearer for translation and non-native speakers
10. **Who/whom/that/which correctly** - "who" for people (subject), "whom" for people (object), "that" for restrictive clauses (no commas), "which" for nonrestrictive clauses (with commas)

### Section 3: Word Usage and Terminology

**Preferred terms and words to avoid**

**Preferred:**
- Add (existing items) vs. Create (new items)
- Edit (not "Modify")
- Remove (take out of list, not deleted) vs. Delete (permanent removal)
- Log in / Log out (verb, two words) vs. Login (noun, one word)
- Configure (not "set up")
- Ensure (not "make sure")
- Use (not "utilize")
- Before (not "prior to")
- Because (not "since" for cause, reserve "since" for time)
- After (not "once" for sequence, reserve "once" for time)
- Although (not "while" for contrast, reserve "while" for time)

**Avoid these words:**
- **Please** - Never use in UI or documentation (extraneous and overly formal)
- **Simply** - Never use (patronizing)
- **Desire** - Replace with "want"
- **Should** - Avoid when possible, replace with "must" for requirements
- **May** - Do not use as synonym for "might"
- **Appears** - Use "opens" for screen elements
- **As** - Never use to mean "because" or "while"
- **Via** - Use "by", "from", or "through" (except for routing data)
- **Will** - Avoid future tense unless absolutely necessary
- **Either-or** - Only for two options, not three or more

### Section 4: Formatting and Structure

**Capitalization:**
- **Sentence case for all headings, titles, and buttons** - Capitalize only first letter of first word and proper nouns
- **Proper nouns remain capitalized** - Product names (React, PatternFly, Red Hat), acronyms
- **Match GUI capitalization** - When referencing UI elements, match exact capitalization as displayed

**Titles and Headings:**
- Use gerunds (-ing) and active verbs for procedures (e.g., "Creating a virtual machine")
- Use nouns for concepts/reference (e.g., "Benefits of bucket policies")
- Avoid "How to" or "Using" prefixes
- Length: 3-12 words (50-80 characters) for search findability
- No colons at end of headings

**Lists:**
- Use complete sentences before lists (not fragments like "Ensure you complete:")
- Numbered lists for sequences/procedures
- Bulleted lists for non-sequential items or single-step procedures
- All list items must be parallel (same grammatical structure)
- Complete sentence items end with periods
- Maximum two levels of nesting (three absolute max)

**Punctuation:**
- **No punctuation on buttons**
- **Oxford comma** - Use in lists of three or more items
- **Exclamation marks** - Use sparingly, only for genuinely exciting or cautionary moments
- **Colons** - Use after introduction to lists, lowercase text following colon unless it's a list item, note, proper noun, or quotation
- **Semicolons** - Use to separate items in series containing commas, or before conjunctive adverbs

**Code and Commands:**
- Code blocks must include language tags (```bash, ```python, etc.)
- Use backticks for inline code, commands, filenames, variables
- Use bold for GUI elements
- Verbs for commands: run, type, enter, issue, or use
- Variables in angle brackets: `<deployment>` or italic monospace

**Links:**
- Provide context before links
- Specify title of destination
- Use "For more information about" (not "on")
- Avoid inline links in body text, prefer "Additional resources" sections

---

## Audit Methodology & Anti-Hallucination

### Zero-Hallucination Policy

- If a quality judgment is subjective or context-dependent, label it as **"Suggestion"** rather than **"Issue"**
- If terminology consistency can't be verified without broader context, state **"Requires manual review across full doc set"**
- If a style rule has exceptions or nuance, include the caveat in the finding
- Never infer, speculate, or bridge gaps with "likely" or "probably"

### Evidence-Based Findings

- Every finding must reference specific text (quote the problematic sentence/phrase)
- Include location (file path, section heading, approximate line if available)
- For embedded style guide violations, cite the specific rule number
- For quality issues without explicit rules, explain the problem clearly with reasoning

### Uncertainty Labeling

- **Critical findings:** Clear violations of readability, consistency, or accuracy that will confuse readers
- **Moderate findings:** Issues that reduce effectiveness but may have contextual justification
- **Minor findings:** Polish/preference items where reasonable people might disagree - always label as suggestions

### Scope Boundaries

**What this skill audits:**
- How docs communicate (tone, clarity, flow, consistency)
- Adherence to plain language principles for global audiences
- User experience with the documentation
- Quality dimensions listed above

**What this skill does NOT audit:**
- Technical accuracy (use cli-doc-audit or terraform-provider-audit)
- Detailed grammar/spelling (those are editor tools)
- Code correctness in examples (technical audit skills handle this)

---

## Handling Multiple Documentation Types

The skill audits CLI docs, Terraform provider docs, API docs, tutorials, and conceptual documentation without requiring users to specify doc type.

### Unified Quality Checks

The same quality dimensions (tone, clarity, structure, consistency, completeness, audience, examples) apply to all doc types. The embedded style guide rules are universal.

### Context-Aware Interpretation

The skill recognizes doc patterns to provide relevant feedback:

- **CLI reference docs:** Examples should show realistic command usage, flags should be explained, error messages should be documented
- **Terraform resource docs:** Attributes should have type/requirement info, HCL examples should be complete and valid
- **API docs:** Parameters should include types/constraints, response examples should be realistic
- **Tutorials/guides:** Steps should be complete and sequential, prerequisites should be stated upfront

### No Special Modes

Rather than asking "what type of doc is this?" upfront, the skill reads content and applies quality checks intelligently:
- Sees bash code blocks -> checks CLI-specific patterns
- Sees HCL code -> checks Terraform patterns
- Sees JSON/YAML -> checks API doc patterns
- Sees numbered procedures -> checks tutorial/guide patterns

**Important:** If the skill cannot determine which doc type or pattern applies, it must stop and ask the user for clarification rather than guessing. The zero-hallucination policy applies to doc type detection as well.

This keeps workflow simple: user points to docs, skill analyzes them - but asks when uncertain.

### Consistent Reporting

All findings use the same format regardless of doc type, making the report easy to scan and act on.

---

## Relationship to Companion Fix Skill

This audit skill only reports findings - it never modifies documentation. A separate companion skill (doc-quality-fix) will handle remediation.

### Audit Output Structure

The markdown report uses structured findings format designed to be machine-readable:

```markdown
**Issue:** [Description]
**Location:** [File:section]
**Severity:** [Critical/Moderate/Minor]
**Current Text:** [Quote]
**Suggestion:** [How to fix]
**Style Guide Reference:** [Rule citation]
```

### Future Fix Skill Capabilities

A companion fix skill could:
1. Read the audit report
2. Parse findings by severity
3. Apply auto-fixes for simple issues:
   - Terminology consistency (replace deprecated terms)
   - Phrasal verb replacement (set up -> configure)
   - Passive-to-active voice conversion
   - Sentence splitting (40+ word sentences)
4. Present complex issues to user for manual review in interview style (one item at a time, not batch)

### Safe Workflow

Keeping audit and fix separate ensures:
- Users review findings before changes
- Prioritization happens before bulk fixes
- Audit reports can be version-controlled
- Changes are deliberate, not automatic

---

## Future Enhancements

### Ansible Content Collections Support

Add Ansible content collections as a supported documentation type. This will require:
- Recognizing Ansible playbook/role documentation patterns
- Checking YAML example quality in Ansible context
- Verifying module documentation completeness
- Applying same quality dimensions to Ansible docs

**Note:** Not included in initial implementation, but design accommodates this expansion.

### Additional Enhancements to Consider

- Integration with doc generation pipelines (CI/CD hooks)
- Trend analysis across multiple audit runs (quality improving/degrading over time)
- Team-specific style guide overlays (per-project customization)
- Automated severity scoring based on doc type and audience

---

## Implementation Notes

### Style Guide Curation

During implementation, we will:
1. Extract the user's formal style guides and identify the 20-30 most critical rules for technical documentation
2. Curate 20-30 universal best practices from Microsoft/Google/industry style guides
3. Combine and organize into the four embedded sections above
4. Format as part of the skill definition for easy reference during audits

### Testing and Validation

The skill should be tested against:
- CLI documentation with known quality issues
- Terraform provider docs (both good and problematic examples)
- Tutorial content with varying readability levels
- Mixed doc sets to verify consistency across types

### Performance Considerations

For large doc sets (50+ files):
- Use parallel subagents to audit document subsets concurrently
- Dispatch subagents with clear scope (e.g., "audit all CLI reference docs", "audit getting-started guides")
- Aggregate subagent findings into unified report
- Manage subagent work to prevent context overflow and ensure consistent quality across all findings
- Show progress during execution as subagents complete
- Provide interim summaries at logical breakpoints

---

## Success Criteria

This skill is successful if:

1. **Pre-release gate:** Teams can run audit before publishing and catch quality issues early
2. **Consistent baseline:** All docs audited against same embedded style guide produce comparable results
3. **Actionable findings:** Every finding includes clear location, specific problem, and suggested fix
4. **Global audience focus:** Plain language violations are reliably flagged
5. **Interactive workflow:** Users can get quick summary or detailed report based on needs
6. **Evidence-based:** No hallucinated issues, all findings reference actual doc content
7. **Complementary:** Works alongside technical audit skills without overlap or conflict

---

## Design Completion

This design is ready for implementation planning.

**Next step:** Invoke writing-plans skill to create detailed implementation plan.
