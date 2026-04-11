---
name: requirement-analysis
description: Groom a backlog item. Analyzes user intent, domain knowledge, competitive context, and workflow. Works with GitHub Issues and Azure DevOps Work Items. Usage: /requirement-analysis [issue-number or work-item-id]
argument-hint: [issue-number | work-item-id]
---

Groom and analyze the backlog item $ARGUMENTS.

## What This Does

This command invokes the **orchestrator** agent which scans repo documentation for product and domain context, then coordinates five analysts focused entirely on **user experience and intent**:

**Phase 1 — Context Gathering (parallel):**

| Analyst | Focus |
|---------|-------|
| `intent-analyst` | Intent decomposition, user context, workflow, decision points |
| `domain-analyst` | Domain knowledge, data meaning, business rules, competitive insights |
| `journey-mapper` | End-to-end user journey across related issues, journey gaps |
| `persona-analyst` | User types, needs mapping, persona conflicts, edge cases |

**Phase 2 — Gap & Risk Analysis:**

| Analyst | Focus |
|---------|-------|
| `gap-risk-analyst` | Gaps, risks, value/priority, dependencies |

## How to Use

```
/requirement-analysis 42          # Groom GitHub issue #42 or Azure DevOps work item #42
```

## Platform Support

The plugin auto-detects the hosting platform from your git remote URL:

| Remote URL contains | Platform | How items are fetched | How results are posted |
|---|---|---|---|
| `github.com` | GitHub | `gh` CLI | Comments via `gh` CLI |
| `dev.azure.com` / `visualstudio.com` | Azure DevOps | REST API (`curl`) | Comments via REST |
| Anything else | Generic | User-provided | Written to file |

## How It Posts

Each analysis aspect is posted as a **separate comment** on the issue/work item, preserving the original description. The comment thread looks like:

1. **📋 Elaboration Summary** — Verdict, summary, intent decomposition
2. **🔍 Intent & User Context** — Workflow, decision points, constraints
3. **🗺️ User Journey** — End-to-end journey map (if applicable)
4. **👥 Personas** — User types, conflicts, edge cases (if multiple personas)
5. **🏢 Domain Context** — Business rules, competitive insights
6. **⚠️ Gaps, Risks & Dependencies** — Unresolved questions, risks, dependencies

## After the Elaboration

The agent outputs:

```
Elaboration posted on issue #<number>: <verdict> — <N> comments — <N> unresolved questions
```

## Prerequisites

- **GitHub**: `gh` CLI installed and authenticated (see `docs/platform-config.md`)
- **Azure DevOps**: `AZURE_DEVOPS_TOKEN` environment variable set (see `docs/platform-config.md`)

---

Starting elaboration now...
