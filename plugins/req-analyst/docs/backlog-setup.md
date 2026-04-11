# Backlog Setup

The `req-analyst` plugin works with **GitHub Issues** and **Azure DevOps Work Items**. This guide explains how to structure your backlog items for best results.

---

## Item Structure

The agent works with any format, but produces better elaborations when the original item includes:

### Minimum (title only)
The agent can elaborate from just a title, but will flag many gaps:
```
Title: Add user profile page
Body: (empty)
```

### Recommended (title + description)
Include a brief description of the intent and any known constraints:
```
Title: Add user profile page
Body:
Users should be able to view and edit their profile information
including name, email, and avatar. This is part of the
user management epic.
```

### Ideal (title + description + context)
Include any existing acceptance criteria, references, or constraints:
```
Title: Add user profile page
Body:
Users should be able to view and edit their profile information.

## Context
- Part of epic #15 (User Management)
- Design mockup: [link]
- API endpoint already exists: GET /api/users/:id

## Initial Acceptance Criteria
- User can view their profile
- User can update their name and email
- Avatar upload supports JPG and PNG
```

---

## Labels & Tags

The agent applies verdict labels/tags automatically based on its analysis:

| Verdict | GitHub label | Azure DevOps tag |
|---|---|---|
| Fully elaborated, ready for sprint planning | `groomed` | `groomed` |
| Questions posted, awaiting response | `needs-clarification` | `needs-clarification` |
| Too large, should be split | `needs-decomposition` | `needs-decomposition` |

**GitHub:** You may want to create these labels in your repository beforehand. The agent will create them if they don't exist (requires repo admin permissions).

**Azure DevOps:** Tags are created automatically — no setup needed.

---

## Item Types

The agent auto-detects the item type from labels/tags or content:

| Type | GitHub detection | Azure DevOps detection | Elaboration Focus |
|---|---|---|---|
| **Story** | Label `story` or `feature` | Work item type `User Story` | Personas, user journey, UX edge cases |
| **Task** | Label `task` or `chore` | Work item type `Task` | Dependencies, scope clarity |
| **Bug** | Label `bug` | Work item type `Bug` | Reproduction steps, expected vs actual |
| **Spike** | Label `spike` or `research` | Work item type `Task` + tag `spike` | Research questions, success criteria, time-box |

---

## Workflow

### GitHub

1. Create a GitHub issue with at least a title and brief description
2. Run `/requirement-analysis <issue-number>`
3. The agent posts analysis as comments on the issue
4. Product owner reviews:
   - If `GROOMED` — move to sprint planning
   - If `NEEDS CLARIFICATION` — answer the posted questions, then re-run
   - If `NEEDS DECOMPOSITION` — split into smaller issues and elaborate each

### Azure DevOps

1. Create a work item (User Story, Bug, or Task) with at least a title
2. Run `/requirement-analysis <work-item-id>`
3. The agent posts analysis as comments on the work item
4. Same review flow as above

---

## Platform Support

| Platform | Fetch items | Post results | Find related items |
|---|---|---|---|
| **GitHub** | `gh` CLI (`gh issue view`) | Comments via `gh` CLI | By milestone/labels |
| **Azure DevOps** | REST API (`curl`) | Comments via REST | By iteration path (WIQL) |
| **Generic** | User-provided | Written to file | Manual |
