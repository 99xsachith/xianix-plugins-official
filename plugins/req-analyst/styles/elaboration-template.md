# Elaborated Requirement Template

This template defines the structure for the compiled elaboration report. The orchestrator agent must follow this format exactly when compiling findings from sub-agents.

---

## Elaborated Requirement

**Issue:** #[number] — [title]
**Type:** Story | Task | Bug | Spike
**Verdict:** `GROOMED` | `NEEDS CLARIFICATION` | `NEEDS DECOMPOSITION`

---

### Summary

[3-5 sentences: what this is, the underlying intent (problem being solved), how success is defined, and expected outcome.]

| Dimension | Detail |
|---|---|
| **Stated need** | [What they asked for] |
| **Underlying intent** | [What problem this solves; what disappears if done] |
| **Success definition** | [How they'll judge it; "this is a win" criteria] |
| **Current workaround** | [What exists today; pain being replaced] |

---

### User Context & Workflow

- **Who & when:** [Primary user; situational context — calm planning vs high-stress operation]
- **Constraints:** [Time, device, connectivity, regulation — only if relevant]
- **Workflow:** [Before → this step → after; happy path; key edge flows]
- **Decision points:** [Where users think; what can be automated vs must stay human]

---

### User Journey

> Where this requirement fits in the end-to-end user journey — only include if the journey context adds insight

| # | Stage | User Goal | Touchpoint | Emotion | Issues |
|---|-------|-----------|------------|---------|--------|
| 1 | [Stage] | [Goal] | [Where] | [State] | #[refs] |
| **2** | **[This requirement]** | **[Goal]** | **[Where]** | **[State]** | **#[this]** |
| 3 | [Stage] | [Goal] | [Where] | [State] | #[refs] |

- **Journey gaps:** [Steps with no corresponding issue or feature]
- **Moments that matter:** [High-stakes, trust-building, or delight opportunities]

*(Skip if the requirement is too narrow for meaningful journey context — e.g., a bug fix.)*

---

### Personas

> Distinct user types affected by this requirement — only include if multiple personas are relevant

| Persona | Role | Frequency | Primary Goal |
|---------|------|-----------|--------------|
| [Label] | [Who] | [How often] | [Goal] |

- **Conflicts:** [Where personas' needs diverge; suggested resolution]
- **Underserved:** [User types not mentioned but likely affected]

*(Skip if the requirement clearly serves a single persona.)*

---

### Domain Context

> Data meaning, business rules, and competitive landscape — only include what's relevant

- **Key concepts:** [What terms/data mean to users — semantic, not structural]
- **Business rules:** [Standard behavior; exceptions ("except when…"); overrides]
- **User expectations:** [Fast enough, trustworthy, simple]
- **Competitive/industry:** [Similar implementations; patterns; differentiation opportunities]

*(Skip competitive section if web search yields nothing relevant.)*

---

### Gaps & Unresolved Questions

| # | Gap / Question | Severity | Suggested question |
|---|---|---|---|
| 1 | [What's ambiguous or missing] | `CRITICAL` / `WARNING` / `INFO` | [Precise, answerable question] — @[person] |

*(Skip if no gaps found.)*

---

### Risks, Dependencies & Assumptions

- **Value & priority:** [Primary value driver; MVP vs nice-to-have; time sensitivity]
- **Risks:** [Specific to this item — with mitigation]
- **Dependencies:** [Upstream / downstream / external]
- **Assumptions:** [Conditions assumed true — validate with product owner]

*(Skip subsections with no findings.)*
