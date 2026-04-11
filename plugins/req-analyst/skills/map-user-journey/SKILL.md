---
name: map-user-journey
description: Map the full end-to-end user journey for a backlog item. Shows where the requirement fits in the broader user flow, identifies journey gaps, and surfaces moments that matter. Works with GitHub Issues and Azure DevOps Work Items. Usage: /map-user-journey [issue-number or work-item-id]
argument-hint: [issue-number | work-item-id]
disable-model-invocation: true
---

Map the full user journey for item #$ARGUMENTS.

## Steps

1. Detect the platform from `git remote get-url origin`.

2. Fetch the item content:
   - **GitHub:** Use `gh issue view ${ISSUE_NUMBER} --json title,body,labels,milestone,comments`.
   - **Azure DevOps:** Use `curl` to fetch the work item — see `providers/azure-devops.md`.

3. Fetch related items:
   - **GitHub:** Use `gh issue list` — search by milestone, labels, and keywords.
   - **Azure DevOps:** Use `curl` with WIQL to query items in the same iteration — see `providers/azure-devops.md`.

4. Scan the repo for relevant documentation:
   - Look for `README.md`, `docs/**/*.md`, `requirements/**/*`, `specs/**/*`
   - Read files that describe user flows, features, or journeys
   - Build a short documentation summary for context

5. Use the **journey-mapper** agent, passing it the item content, related items, **and** the documentation summary.

6. Output the journey map directly. Do not post to any platform — this is a local-only analysis.

If no argument is given, prompt the user for an item number.
