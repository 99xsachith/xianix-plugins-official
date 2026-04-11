---
name: post-elaboration
description: Post the elaborated requirement as comments on a backlog item (GitHub Issue or Azure DevOps Work Item). Each analysis aspect becomes a separate comment, preserving the original description. Usage: /post-elaboration [issue-number or work-item-id]
argument-hint: [issue-number | work-item-id]
---

Post the elaborated requirement as comments on item #$ARGUMENTS.

Do not ask for confirmation at any point. Execute all steps autonomously and proceed immediately from one step to the next.

## Steps

1. **Detect platform**

   ```bash
   git remote get-url origin
   ```
   - Contains `github.com` → **GitHub**
   - Contains `dev.azure.com` or `visualstudio.com` → **Azure DevOps**
   - Anything else → **Generic** (write to file)

2. **Verify item exists**

   **GitHub:** Use `gh issue view` to confirm the issue exists and is open.

   ```bash
   gh issue view ${ISSUE_NUMBER} --json state
   ```

   **Azure DevOps:** Use `curl` to fetch the work item — see `providers/azure-devops.md`.

   If the item does not exist or is already closed/completed, stop and output a single error line.

3. **Post each aspect as a separate comment**

   **Do not modify the item body.** Post each analysis aspect as its own comment, in this order:

   | # | Comment | Heading |
   |---|---------|---------|
   | 1 | Summary & Verdict | `## 📋 Elaboration Summary` |
   | 2 | Intent & User Context | `## 🔍 Intent & User Context` |
   | 3 | User Journey | `## 🗺️ User Journey` |
   | 4 | Personas | `## 👥 Personas` |
   | 5 | Domain Context | `## 🏢 Domain Context` |
   | 6 | Gaps, Risks & Dependencies | `## ⚠️ Gaps, Risks & Dependencies` |

   Skip comments 3 and 4 if those sections have no findings.

   **GitHub:** Use `gh issue comment`.

   ```bash
   gh issue comment ${ISSUE_NUMBER} --body "${COMMENT_BODY}"
   ```

   **Azure DevOps:** Use `curl` POST to the work item comments API — see `providers/azure-devops.md`.

4. **Apply verdict label/tag**

   **GitHub:** Use `gh issue edit`.

   ```bash
   gh issue edit ${ISSUE_NUMBER} --add-label "${VERDICT_LABEL}"
   ```

   **Azure DevOps:** Use `curl` PATCH to add the tag — see `providers/azure-devops.md`.

   | Plugin verdict | GitHub label | Azure DevOps tag |
   |---|---|---|
   | `GROOMED` | `groomed` | `groomed` |
   | `NEEDS CLARIFICATION` | `needs-clarification` | `needs-clarification` |
   | `NEEDS DECOMPOSITION` | `needs-decomposition` | `needs-decomposition` |

5. **Post unresolved questions**

   Post each as a separate comment, tagging the relevant person.

6. **Output result**

   ```
   Elaboration posted on issue #<number>: <verdict> — <N> comments — <N> unresolved questions
   ```

> **Note:** GitHub requires `gh` CLI installed and authenticated. Azure DevOps requires `AZURE_DEVOPS_TOKEN`. See `docs/platform-config.md` for setup.
