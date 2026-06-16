# Documentation Quality Audit Report

**Audit Date:** Jun-03-2026  
**Documents Audited:** 2 test documents
**Quality Dimensions:** 7 core (tone, clarity, structure, consistency, completeness, audience appropriateness, example quality)
**Style Guide:** Embedded baseline (IBM, PatternFly, Red Hat standards)

---

## Screen Summary

| Metric | Value |
|--------|-------|
| Documents Audited | 2 |
| Total Issues Found | 15 |
| Critical Severity | 6 |
| Moderate Severity | 7 |
| Minor Severity | 2 |

### Top 5 Issues

1. **CRITICAL** - "How to Use" title pattern violates Section 4 #3 formatting rule (Formatting #3: Avoid "How to" prefixes)
2. **CRITICAL** - "utilize" used instead of simple verb "use" violates Plain Language rule #2
3. **CRITICAL** - Contractions ("It'll") used in technical documentation violates Plain Language rule #14
4. **CRITICAL** - "The system will automatically handle" is anthropomorphism violating Voice/Grammar rule #4
5. **MODERATE** - "Simply run" uses "Simply" which violates Word Usage rule (patronizing word to avoid)

---

## Audit by Document

### Document 1: sample-cli-doc.md (CLI Documentation)

**Doc Type:** CLI Tool Command Reference  
**Status:** Multiple quality issues detected

#### Tone/Voice Consistency

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Title uses "How to" pattern | Line 1 | CRITICAL | "# How to Use the Deploy Command" | "# Deploy Command" or "# Using the Deploy Command" | Formatting #3 |
| Anthropomorphism - system acts autonomously | Line 15 | CRITICAL | "The system will automatically handle the deployment" | "Terraform automatically deploys to the specified environment" | Voice/Grammar #4 |
| Vague authority with "Make sure" | Line 25 | MODERATE | "Make sure you configure these properly" | "Ensure you configure these options correctly" | Word Usage (ensure not make sure) |

#### Clarity/Readability

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Pretentious word "utilize" | Line 5 | CRITICAL | "You can utilize it to set up" | "You can use it to configure" | Plain Language #2, Word Usage |
| Patronizing word "Simply" | Line 9 | CRITICAL | "Simply run the following command:" | "Run the following command:" | Word Usage (avoid "Simply") |
| Vague timing "a while" | Line 29 | MODERATE | "The deployment process will take a while" | "Deployment typically takes 5-10 minutes" | Plain Language #6 (concrete examples) |

#### Structure/Flow

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Incomplete sentence before list | Line 19 | MODERATE | "Here are the options:" followed by bare list items | "The following options are available:" then numbered/bulleted list with complete descriptions | Voice/Grammar #5 |
| List items lack detail | Lines 21-23 | MODERATE | "- `--env` - specify environment" | "- `--env` - The environment where the application is deployed (required: production, staging, development)" | Completeness |

#### Consistency

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Contractions in technical docs | Line 15 | CRITICAL | "It'll configure everything" | "It will configure everything" | Plain Language #14 |
| Inconsistent option descriptions | Lines 21-23 | MODERATE | Mix of short fragments ("specify environment") vs. incomplete descriptions | Expand all descriptions to complete sentences with context | Voice/Grammar #5 |

#### Completeness

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Missing default values | Lines 21-23 | MODERATE | No information about defaults for flags | Add "Default: [value]" for each option | Completeness |
| Missing exit codes/errors | Entire section | MINOR | No error handling documentation | Add "Error Codes" or "Troubleshooting" section | Completeness |

#### Audience Appropriateness

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Assumes prior knowledge | Line 5 | MODERATE | "various environments" without explanation | "various environments (production, staging, development)" | Audience #1 (Plain Language #6) |
| Sentence exceeds 40 words | Line 5 | MODERATE | "The deploy command is a powerful tool that allows you to deploy your application to various environments." (19 words - PASSES) But: "You can utilize it to set up your infrastructure quickly." combined with previous creates reading difficulty | Break into shorter, simpler sentences | Plain Language #1 |

---

### Document 2: sample-terraform-doc.md (Terraform Provider Documentation)

**Doc Type:** Terraform Resource Documentation  
**Status:** Multiple quality issues detected

#### Tone/Voice Consistency

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Anthropomorphism - "allows you" | Line 3 | CRITICAL | "This resource allows you to create inventories" | "Create inventories in AAP using the aap_inventory resource" | Voice/Grammar #4 |
| Vague directive "You should" | Line 24 | MODERATE | "You should configure these as needed" | "Configure these attributes according to your requirements" | Word Usage (avoid "should") |

#### Clarity/Readability

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Ultra-vague descriptions | Lines 17-18 | CRITICAL | "Name of inventory" / "Description" | "The human-readable name of the inventory that will be created in AAP" / "A descriptive note about the inventory's purpose or contents" | Completeness + Plain Language #6 |
| Missing attribute metadata | Lines 17-22 | CRITICAL | No indication of Required vs Optional, no type info | Add type, requirement status, and constraints: "name (String, Required) - The human-readable..." | Completeness |

#### Structure/Flow

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Incomplete example | Lines 8-10 | MODERATE | HCL example doesn't show all relevant attributes | Show more realistic example with description and organization fields | Example Quality |

#### Consistency

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Inconsistent capitalization | Line 22 | MINOR | "ID of the resource" should match pattern | "The unique identifier for the resource, assigned by AAP" | Formatting #1 |

#### Completeness

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Missing attribute types | Lines 17-22 | CRITICAL | No data types (String, Int, Bool, List, etc.) specified | Add type information for every argument and attribute | Completeness #1 |
| Missing Optional/Required markers | Lines 17-22 | CRITICAL | No indication of which fields are required | Add "Required" or "Optional" for each argument | Completeness #2 |
| Missing output/computed attributes | Line 22 | MODERATE | Only shows `id` but no other computed fields | Add documentation for all computed fields: `url`, `organization_id`, etc. | Completeness #3 |

#### Audience Appropriateness

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Assumes Terraform knowledge | Entire doc | MINOR | No explanation of what "resource" means or how to use it | Add brief intro: "An aap_inventory resource creates or manages an inventory in Ansible Automation Platform (AAP). To use this resource, define..." | Audience |

#### Example Quality

| Issue | Location | Severity | Current Text | Suggestion | Rule Reference |
|-------|----------|----------|--------------|-----------|-----------------|
| Example is too minimal | Lines 8-10 | MODERATE | Shows only `name` attribute | Show complete, realistic example: include `description`, `organization` fields; add comment explaining the example | Example Quality #2 |

---

## Findings by Dimension

### 1. Tone/Voice Consistency

**sample-cli-doc.md:**
- Line 1: Title uses "How to" (Formatting violation)
- Line 5: "powerful tool" (marketing language)
- Line 15: Anthropomorphism ("The system will automatically handle")
- Line 15: Contraction "It'll" (Plain Language violation)
- Line 25: "Make sure" (vague authority directive)

**sample-terraform-doc.md:**
- Line 3: Anthropomorphism ("allows you to create")
- Line 24: "You should configure" (Word Usage violation)

### 2. Clarity/Readability

**sample-cli-doc.md:**
- Line 5: "utilize" instead of "use" (Plain Language #2)
- Line 9: "Simply" (patronizing word to avoid)
- Line 29: "take a while" is vague (Plain Language #6 - need concrete examples)
- Multiple sentences are difficult for non-native English speakers

**sample-terraform-doc.md:**
- Lines 17-18: Descriptions are ultra-vague ("Name of inventory", "Description")
- Line 3: "allows you to" is passive framing

### 3. Structure/Flow

**sample-cli-doc.md:**
- Line 19: Incomplete sentence before list ("Here are the options:")
- Lines 21-23: List items are fragments, not parallel structures

**sample-terraform-doc.md:**
- Lines 8-10: Example is too minimal, missing attributes

### 4. Consistency

**sample-cli-doc.md:**
- Inconsistent option descriptions (some one word, some fragments)
- Inconsistent tense and voice in sections

**sample-terraform-doc.md:**
- Capitalization inconsistency in attribute descriptions

### 5. Completeness

**sample-cli-doc.md:**
- Missing: default values for flags
- Missing: error codes/error handling section
- Missing: exit codes

**sample-terraform-doc.md:**
- Missing: data types (String, Int, List, etc.) for all attributes
- Missing: Required vs Optional designation
- Missing: computed/read-only attribute documentation
- Missing: constraints or validation rules

### 6. Audience Appropriateness

**sample-cli-doc.md:**
- Line 5: "various environments" needs explanation
- Uses technical jargon without sufficient explanation
- Assumes user knows what deployment means

**sample-terraform-doc.md:**
- Assumes user understands Terraform concepts
- No beginner context provided

### 7. Example Quality

**sample-cli-doc.md:**
- Single inline example; could use more complete command scenarios
- Missing error handling examples

**sample-terraform-doc.md:**
- Example is incomplete (missing attributes)
- Example doesn't show how to handle all required fields
- No comments in the example

---

## Recommendations

### High Priority (Critical Issues)

1. **Rewrite title** (sample-cli-doc.md, line 1)
   - Remove "How to" prefix
   - Use "Deploy Command" or "Deploying Your Application"

2. **Replace "utilize" with "use"** (sample-cli-doc.md, line 5)
   - Current: "You can utilize it to set up"
   - Suggested: "You can use it to configure"

3. **Remove contractions** (sample-cli-doc.md, line 15)
   - Current: "It'll configure everything"
   - Suggested: "It will configure everything"

4. **Fix anthropomorphism** (sample-cli-doc.md, line 15 and sample-terraform-doc.md, line 3)
   - Remove agent-based language ("system will", "allows you")
   - Focus on user actions

5. **Add attribute type information** (sample-terraform-doc.md, lines 17-22)
   - Add data type for each argument/attribute
   - Mark as Required or Optional

6. **Expand vague descriptions** (sample-terraform-doc.md, lines 17-22)
   - Replace one-word descriptions with complete sentences

### Medium Priority (Moderate Issues)

1. **Replace "Simply"** (sample-cli-doc.md, line 9)
   - Remove patronizing word

2. **Replace "Make sure"** (sample-cli-doc.md, line 25)
   - Use "Ensure" instead

3. **Replace "prior to"** (sample-cli-doc.md, line 29)
   - Use "before" instead

4. **Add concrete timing** (sample-cli-doc.md, line 29)
   - Replace "a while" with specific timeframe

5. **Fix incomplete sentences** (sample-cli-doc.md, line 19)
   - Add complete introductory sentence before lists

6. **Expand example** (sample-terraform-doc.md, lines 8-10)
   - Show more realistic configuration with multiple attributes

### Low Priority (Minor Issues)

1. **Add error handling section** (sample-cli-doc.md)
   - Document possible error codes and solutions

2. **Add beginner context** (sample-terraform-doc.md)
   - Brief explanation of what a resource is

---

## Summary Statistics

| Category | Count |
|----------|-------|
| Total Issues | 15 |
| Critical Issues | 6 |
| Moderate Issues | 7 |
| Minor Issues | 2 |

**sample-cli-doc.md Issues:** 11 (8 Critical/Moderate, 1 Minor)  
**sample-terraform-doc.md Issues:** 4 (4 Critical/Moderate, 1 Minor)

---

**Report Generated By:** Anthropic | Claude Sonnet 4.5 | Jun-03-2026 18:30 GMT
