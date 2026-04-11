# Provider: Generic / Unknown Platform

Use this provider when the git remote does not match GitHub or Azure DevOps — or as a fallback when API posting is not possible.

## Behaviour

In generic mode the elaboration is **not posted to a remote platform**. Instead, each analysis aspect is written to a local file as separate sections so it can be consumed by an external process, CI system, or human operator.

---

## Writing the Report File

Write the full compiled elaboration to a file in the repository root:

```
requirement-elaboration-report.md
```

The file must be written even if the verdict is `GROOMED` — the file serves as the audit artifact.

**File format:**

```markdown
# Requirement Elaboration Report

Generated: <ISO 8601 timestamp>
Repository: <repo URL>
Issue: #<issue number>
Verdict: GROOMED | NEEDS CLARIFICATION | NEEDS DECOMPOSITION

---

## 📋 Elaboration Summary
<summary and intent decomposition>

---

## 🔍 Intent & User Context
<intent-analyst output>

---

## 🗺️ User Journey
<journey-mapper output — omit if not applicable>

---

## 👥 Personas
<persona-analyst output — omit if single persona>

---

## 🏢 Domain Context
<domain-analyst output>

---

## ⚠️ Gaps, Risks & Dependencies
<gap-risk-analyst output>
```

---

## Output

On completion:

```
Elaboration complete: <verdict> — report written to requirement-elaboration-report.md
```

---

## When to Use

This provider is the correct fallback for:

- Azure Boards (when REST API posting is not configured)
- Jira instances (API posting not yet implemented — use generic)
- Self-hosted issue trackers
- Local or offline runs where no remote API is available
- CI environments where only the report file output is needed
