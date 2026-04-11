---
name: analyze-domain
description: Run a focused domain and market-context analysis on a backlog item. Brings domain knowledge, competitive insights, data semantics, and business rules. Works with GitHub Issues and Azure DevOps Work Items. Usage: /analyze-domain [issue-number or work-item-id]
argument-hint: [issue-number | work-item-id]
disable-model-invocation: true
---

Run a focused domain analysis on item #$ARGUMENTS.

## Steps

1. Detect the platform from `git remote get-url origin`.

2. Fetch the item content:
   - **GitHub:** Use `gh issue view ${ISSUE_NUMBER} --json title,body,labels,comments`.
   - **Azure DevOps:** Use `curl` to fetch the work item — see `providers/azure-devops.md`.

3. Scan the repo for relevant documentation:
   - Look for `README.md`, `docs/**/*.md`, `requirements/**/*`, `specs/**/*`
   - Read files that reference key domain terms from the item
   - Build a short documentation summary for context

4. Use the **domain-analyst** agent, passing it the item title, body, inferred domain/category, **and** the documentation summary.

5. Output the domain analysis findings directly. Do not post to any platform — this is a local-only analysis.

If no argument is given, prompt the user for an item number.
