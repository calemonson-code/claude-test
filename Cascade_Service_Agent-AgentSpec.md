# Agent Spec: Cascade_Service_Agent

**Status:** Draft scaffold — 2026-09-17. Not yet reviewed or approved.
**Bundle:** `force-app/main/default/aiAuthoringBundles/Cascade_Service_Agent/`

## Purpose & Scope

A customer-facing Agentforce Service Agent that deflects common support contacts:
answers general questions from the knowledge base, reports the status of a case
the user already has, and logs a new case when it cannot resolve the request.
Anything it cannot handle goes to a human.

Scope is deliberately generic. The knowledge domain, case fields, and routing
rules are placeholders to be replaced with the real requirements.

## Behavioral Intent

- The agent answers **only** from action output. It must not state a case
  number, status, or date that an action did not return. This is enforced in the
  global `system.instructions` and repeated as a response duty in the `support`
  block.
- Knowledge answers are reproduced verbatim (`answer`, `articleTitle`,
  `articleUrl`). Paraphrasing risks failing platform grounding validation.
- Exactly one case may be created per conversation. Repeat creation is blocked
  by a runtime gate, not by instruction text.
- Off-topic requests and ambiguous requests are handled as **branches** inside
  the `support` block, not as separate subagents. Neither changes the available
  action set or authority, so neither earns its own scope.
- Escalation is a separate subagent because it changes authority — it ends the
  agent's turn and hands control to a human.
- Action implementation type: invocable Apex for all three actions.

## Subagent Posture

| Subagent | Posture | Why this posture | Deterministic controls |
|---|---|---|---|
| `support` | agentic | One domain, one action set. The model judges question vs. case-status vs. new-problem from conversation; none of those branches is trust- or policy-sensitive. | `log_a_case` hidden once a case exists |
| `case_creation` | mixed | Collecting subject and description is ordinary conversation, but the write itself is consequential and irreversible. | `submit_case` gated on no existing case; `require_user_confirmation: True` |
| `escalation` | scripted | Single duty, single action, no judgment required. | none |

## Subagent Map

```mermaid
%%{init: {'theme':'neutral'}}%%
graph TD
    S["start_agent support<br/>answer_question · check_case"]
    C["subagent case_creation<br/>submit_case"]
    E["subagent escalation<br/>@utils.escalate"]

    S -->|handoff: unresolved problem<br/>available when created_case_number == ""| C
    S -->|handoff: user asks for a person| E
    C -->|handoff: back to general help| S
    C -->|handoff: user asks for a person| E
    E -->|"@utils.escalate — ends the agent turn"| H((human agent))
```

All transitions are **handoffs**. There is no delegation and no return stack.

## Variables

| Variable | Type / Default | Trusted Writer | Named Consumer | Cause | Reset / Expiry / Correction / Cancel |
|---|---|---|---|---|---|
| `created_case_number` | `mutable string = ""` | `create_case` output `caseNumber` | `available when` on `submit_case` and `log_a_case`; conditional instruction branches in all three subagents | Confirmed consequence — a second call creates a duplicate Case record | Never reset. A session creates at most one case, so the set-once lifetime is the whole lifecycle. |

`EndUserId`, `RoutableId`, `ContactId`, and `EndUserLanguage` are platform-linked
messaging variables. `ContactId` is consumed as an action input; the other three
are unused by this agent but the compiler flags them as required by Agentforce —
do not remove them.

No other state. The user's question, their stated problem, prior corrections,
and current intent all live in surviving conversation history.

## Actions

### search_knowledge (`support` subagent)

- **Target:** `apex://CascadeKnowledgeSearch`
- **Status:** NEEDS STUB

| Input | Type | Required | Source |
|---|---|---|---|
| `question` | string | Yes | LLM slot-fill from conversation |

| Output | Type | Visible to User? | Notes |
|---|---|---|---|
| `answer` | string | Yes | Reproduced verbatim in the response |
| `articleTitle` | string | Yes | |
| `articleUrl` | string | Yes | |
| `foundMatch` | boolean | No | Signals the "I couldn't find an answer" branch |

**Stubbing requirement:** invocable Apex class `CascadeKnowledgeSearch` with
inner `Request` (`question`) and `Result` (`answer`, `articleTitle`,
`articleUrl`, `foundMatch`). Real implementation will need a decision on the
retrieval source — Knowledge article SOSL, a Data Library retriever, or a prompt
template. **[TBD — depends on where Cascade's support content actually lives.]**

### get_case_status (`support` subagent)

- **Target:** `apex://CascadeCaseStatusLookup`
- **Status:** NEEDS STUB

| Input | Type | Required | Source |
|---|---|---|---|
| `caseNumber` | string | Yes | LLM slot-fill |
| `contactId` | string | No | Bound from `@variables.ContactId` |

| Output | Type | Visible to User? | Notes |
|---|---|---|---|
| `status` | string | Yes | |
| `subject` | string | Yes | |
| `lastModified` | string | Yes | String, not datetime, so it can be reproduced verbatim without reformatting |
| `found` | boolean | No | Signals the "no such case" branch |

**Stubbing requirement:** query `Case` by `CaseNumber` **and** `ContactId` so a
user cannot read another customer's case by guessing a number. Bulkified SOQL,
`AccessLevel.USER_MODE`.

### create_case (`case_creation` subagent)

- **Target:** `apex://CascadeCaseCreator`
- **Status:** NEEDS STUB

| Input | Type | Required | Source |
|---|---|---|---|
| `subject` | string | Yes | LLM slot-fill |
| `problemDescription` | string | Yes | LLM slot-fill |
| `contactId` | string | No | Bound from `@variables.ContactId` |

| Output | Type | Visible to User? | Notes |
|---|---|---|---|
| `caseNumber` | string | Yes | Written to `created_case_number` |
| `caseId` | string | No | Record ID, internal |

**Stubbing requirement:** insert a `Case` with Origin set to the messaging
channel. Named `problemDescription` rather than `description` to avoid colliding
with the reserved `description` property in the Agent Script action block.

## Action Invocation Strategy

| Action | Subagent | Invocation Mode | Why |
|---|---|---|---|
| `search_knowledge` | `support` | planner slot-fill | The model judges when a question is answerable from knowledge |
| `get_case_status` | `support` | planner slot-fill | Requires a case number the user supplies mid-conversation |
| `create_case` | `case_creation` | planner slot-fill + `require_user_confirmation` | Consequential write; the user confirms before it fires |

No `run` (deterministic) invocation. Nothing here must fire on every entry.

## Deterministic Controls

- `submit_case` visibility: `available when @variables.created_case_number == ""`
  — cause is confirmed consequence (duplicate Case records). Trusted writer is
  the action's own `caseNumber` output, so the gate closes the moment the write
  succeeds.
- `log_a_case` transition visibility: same condition, so the model cannot even
  route back into case creation after a case exists.
- `create_case` carries `require_user_confirmation: True` — platform-level
  confirmation in front of the write, independent of instruction text.

## Architecture Pattern

Domain-first, not router-first. `start_agent support` is the entry point and
does the real work; there is no classifier block in front of it. Two boundaries
are justified:

- `case_creation` — different action set, consequential authority, and its own
  confirmation posture.
- `escalation` — different authority; `@utils.escalate` ends the agent's turn.

Greeting, off-topic redirect, ambiguity clarification, and "no answer found" are
branches inside `support`, per the one-execution-block default.

## Agent Configuration

- **developer_name:** `Cascade_Service_Agent`
- **agent_label:** `Cascade Service Agent`
- **agent_type:** `AgentforceServiceAgent` — customer-facing over a messaging
  channel, with `MessagingSession`-linked variables.
- **access.default_agent_user:** **`"NEW AGENT USER"` — PLACEHOLDER, NOT VALID.**
  Must be replaced with the username of an active user holding an Einstein Agent
  license in the target org. Publishing with the placeholder fails with a
  misleading `Internal Error, try again later`.
- **Target org:** none set. The project has no org association; validation so far
  is local compile only.
- **Permissions verified:** no.

## Open Items

1. Choose the target org and confirm an Einstein Agent User exists in it.
2. Decide the knowledge retrieval source for `CascadeKnowledgeSearch`.
3. Generate and implement the three Apex classes.
4. Replace the generic support domain with Cascade's actual use cases.
5. Preview against realistic utterances before any publish decision.
