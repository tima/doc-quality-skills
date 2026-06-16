# Baseline Style Guide

Distilled from IBM Style, PatternFly UX Writing, Red Hat Technical Writing Style Guide, and industry best practices. Reference these rules when auditing documentation. Cite rule numbers in findings (e.g., "Violates Plain Language rule #1: sentence exceeds 25 words").

## Section 1: Plain Language for Global Audiences

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

## Section 2: Voice and Grammar Rules

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

## Section 3: Word Usage and Terminology

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

## Section 4: Formatting and Structure

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
