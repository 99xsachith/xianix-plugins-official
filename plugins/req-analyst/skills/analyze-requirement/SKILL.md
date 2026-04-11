---
name: analyze-requirement
description: Groom a backlog item (GitHub Issue or Azure DevOps Work Item). Analyzes user intent, domain knowledge, competitive context, and workflow. Usage: /analyze-requirement [issue-number or work-item-id]
argument-hint: [issue-number | work-item-id]
---

Perform requirement grooming for item $ARGUMENTS.

Use the **orchestrator** agent to run a full requirement elaboration. The orchestrator will:

1. Detect the hosting platform from `git remote get-url origin`
2. Fetch item context (`gh` CLI for GitHub, `curl` REST API for Azure DevOps)
3. Index repo documentation — scan for README, docs/, specs/, requirements/, and architecture files to build product and domain context
4. Classify the item (story, task, bug, spike)
5. Run five analysts in two phases (each receives the item content **and** the documentation summary):

   **Phase 1 (parallel — context gathering):**
   - **intent-analyst** — Intent decomposition, user context, workflow, decision points
   - **domain-analyst** — Domain knowledge, data meaning, business rules, competitive insights (via web search)
   - **journey-mapper** — End-to-end user journey across related issues, journey gaps, moments that matter
   - **persona-analyst** — User types, needs mapping, persona conflicts, persona-specific edge cases

   **Phase 2 (after Phase 1):**
   - **gap-risk-analyst** — Gaps, risks, value/priority, dependencies

6. Compile into a structured elaboration (see `styles/elaboration-template.md`)
7. Post each analysis aspect as a **separate comment** on the issue/work item — the original body is never modified

If an issue/work item number is provided (e.g., `/analyze-requirement 42`), fetch the item details first.

If no argument is given, prompt the user for an item number.
