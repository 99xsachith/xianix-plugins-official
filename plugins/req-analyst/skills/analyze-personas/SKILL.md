---
name: analyze-personas
description: Identify and analyze the distinct user personas affected by a backlog item. Maps different needs, surfaces persona conflicts, and highlights persona-specific edge cases. Works with GitHub Issues and Azure DevOps Work Items. Usage: /analyze-personas [issue-number or work-item-id]
argument-hint: [issue-number | work-item-id]
disable-model-invocation: true
---

Run a persona analysis for item #$ARGUMENTS.

## Steps

1. Detect the platform from `git remote get-url origin`.

2. Fetch the item content:
   - **GitHub:** Use `gh issue view ${ISSUE_NUMBER} --json title,body,labels,comments`.
   - **Azure DevOps:** Use `curl` to fetch the work item — see `providers/azure-devops.md`.

3. Fetch related items:
   - **GitHub:** Use `gh issue list` — search by milestone and labels.
   - **Azure DevOps:** Use `curl` with WIQL to query items in the same iteration — see `providers/azure-devops.md`.

4. Scan the repo for relevant documentation:
   - Look for `README.md`, `docs/**/*.md`, `requirements/**/*`, `specs/**/*`
   - Read files that describe user roles, personas, or audience
   - Build a short documentation summary for context

5. Use the **persona-analyst** agent, passing it the item content, related items, **and** the documentation summary.

6. Output the persona analysis directly. Do not post to any platform — this is a local-only analysis.

If no argument is given, prompt the user for an item number.
