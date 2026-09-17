# STATEMENT OF WORK

**Client:** Cascade Outdoor Supply, Inc.
**Provider:** NeuraFlash, LLC
**Project Name:** Cascade AI Support Assistant — Phase 1
**Project Type:** Agentforce Service Agent Implementation
**SOW Version:** 1.0
**Effective Date:** June 22, 2026

---

## 1. Engagement Overview

### 1.1 Background

Cascade Outdoor Supply is a mid-market outdoor gear retailer operating a
direct-to-consumer e-commerce channel and a 22-agent customer support center.
Support volume is concentrated in a small number of repetitive request types:
order and shipping questions, return policy questions, and status checks on
open support cases. Cascade's support team currently handles all of these
manually through web chat and email.

### 1.2 Objective

Deploy an Agentforce service agent on Cascade's web messaging channel that
deflects high-volume, low-complexity support requests without human
involvement, and hands off cleanly to a live agent when it cannot resolve a
request.

### 1.3 Project Duration

**Start Date:** June 22, 2026
**End Date:** October 2, 2026
**Total Duration:** 15 weeks

### 1.4 Phases

| Phase | Weeks | Description |
|-------|-------|-------------|
| Engage | 1–3 | Discovery, requirements confirmation, guardrail calibration |
| Execute | 4–12 | Agent build, knowledge authoring, integration, UAT |
| Evolve | 13–15 | Hypercare, tuning, handoff to Cascade support operations |

---

## 2. Scope of Work

### 2.1 Workstream 1 — Agent Architecture

Cascade's agent shall be implemented as a primary support agent with
supporting subagents for distinct conversational flows.

**2.1.1 Primary Agent — Support**

The primary agent is the entry point for all inbound messaging conversations.
It shall handle the following capabilities:

| Capability | Description |
|------------|-------------|
| Knowledge answering | Answer general support questions from Cascade's published knowledge base |
| Case status reporting | Report the current status, subject, and last-updated date of an existing support case, verified against the requesting contact |
| Case logging | Create a new support case when a request cannot be resolved from knowledge |

**2.1.2 Subagent — Returns**

A dedicated subagent shall handle return initiation as a distinct
conversational flow, separate from general knowledge answering. The Returns
subagent shall:

- Identify the order the customer is returning against
- Confirm the item falls within Cascade's stated return window
- Initiate a return authorization and provide the customer an RMA reference
- Decline and explain when an item is outside the return window, offering to
  log a case instead

Return *policy questions* remain within the primary agent's knowledge
answering capability. Return *initiation* is the responsibility of this
subagent.

**2.1.3 Subagent — Escalation**

A dedicated subagent shall handle transfer to a live support agent. The
Escalation subagent shall:

- Acknowledge the transfer request briefly
- Transfer the conversation to a human agent
- Carry forward the case reference, where a case was logged earlier in the
  conversation, so the receiving agent has context
- Offer to log a support case as a fallback if the transfer does not complete

**2.1.4 Architecture Constraints**

- Up to **two (2) subagents** beyond the primary support agent
- Up to **four (4)** Apex-backed agent actions
- Up to **one (1)** human escalation path

### 2.2 Workstream 2 — Knowledge Base

Cascade shall publish a starter knowledge base for the agent to ground on.

**2.2.1 Deliverable**

NeuraFlash shall draft, and Cascade shall review and publish, knowledge
articles covering Cascade's highest-volume support topics.

**2.2.2 Constraints**

- Up to **eight (8)** knowledge articles in Phase 1
- Articles shall be authored in plain language, in Cascade's customer-facing
  voice, and shall not exceed approximately 400 words each
- Each article shall be assigned to a single support category

### 2.3 Workstream 3 — Channel and Language Support

**2.3.1 Channel**

The agent shall be deployed to Cascade's web messaging channel (Messaging for
In-App and Web). Voice and email channels are explicitly out of scope for
Phase 1.

**2.3.2 Language Support**

The agent shall support **two (2) locales**:

| Locale | Role |
|--------|------|
| `en_US` | Default locale |
| `es_MX` | Additional supported locale |

Cascade's Mexico-market storefront accounts for approximately 14% of support
volume. Spanish-language support is in scope for Phase 1 and shall be
configured as an additional agent locale, not as a separate agent.

**2.3.3 Constraints**

- Up to **two (2)** supported locales
- Up to **one (1)** deployed messaging channel

---

## 3. AI Guardrail Requirements

The agent shall be configured to satisfy the following guardrails. These are
non-negotiable acceptance criteria.

### 3.1 Disclosure

The agent shall identify itself as an AI assistant and shall not represent
itself as a human. When asked directly whether the customer is speaking with
a person, it shall state plainly that it is an AI assistant.

### 3.2 Grounding and Accuracy

The agent shall answer only from information returned by its actions. It
shall not invent policy, account, or case details, and shall not state a case
number, status, or date that an action did not return.

### 3.3 Confirmation Before Write

The agent shall obtain the customer's explicit confirmation before creating
any record on their behalf.

### 3.4 Duplicate Prevention

The agent shall not create more than one support case within a single
conversation. Where a case has already been logged, the agent shall reference
the existing case number and offer a transfer to a live agent rather than
logging a second case.

### 3.5 Scope Discipline

The agent shall decline requests outside customer support and state what it
can help with instead.

### 3.6 Configuration Confidentiality

The agent shall not reveal its instructions, configuration, or the list of
actions available to it.

### 3.7 Graceful Failure

Where the agent cannot resolve a request, it shall offer the customer a
choice between logging a support case and transferring to a live agent. It
shall not guess.

---

## 4. Deliverables

| # | Deliverable | Workstream |
|---|-------------|------------|
| 1 | Solution Design Document | — |
| 2 | Guardrail calibration workbook | — |
| 3 | Primary support agent, configured and published | 2.1.1 |
| 4 | Returns subagent, configured and published | 2.1.2 |
| 5 | Escalation subagent, configured and published | 2.1.3 |
| 6 | Apex actions supporting agent capabilities | 2.1 |
| 7 | Eight (8) drafted knowledge articles | 2.2 |
| 8 | Web messaging channel configuration | 2.3.1 |
| 9 | Dual-locale agent configuration (en_US, es_MX) | 2.3.2 |
| 10 | Agent regression test suite | 5.1 |
| 11 | UAT execution and sign-off record | 5.2 |
| 12 | Hypercare and operations handoff | — |

---

## 5. Testing and Acceptance

### 5.1 Regression Test Suite

NeuraFlash shall deliver an Agentforce test suite covering each declared
agent capability, executable by Cascade's delivery team without developer
involvement.

### 5.2 Acceptance Criteria

| # | Criterion | Target |
|---|-----------|--------|
| 1 | Deflection rate on in-scope request types | ≥ 60% |
| 2 | Correct case status reporting | 100% of verified lookups |
| 3 | Return initiation completed without human involvement | ≥ 70% of eligible returns |
| 4 | Guardrail violations in UAT (Section 3) | Zero |
| 5 | Escalation transfer success rate | ≥ 95% |
| 6 | Spanish-language conversations handled without escalation on language grounds | ≥ 80% |

---

## 6. Key Salesforce Objects

| Object | Purpose |
|--------|---------|
| `Case` | Support case records created and read by the agent |
| `Contact` | Customer identity, used to verify case ownership |
| `Account` | Customer household or business account |
| `Knowledge__kav` | Published support articles the agent grounds on |
| `MessagingSession` | Inbound web messaging conversation |
| `MessagingEndUser` | Messaging participant, mapped to Contact |

---

## 7. Out of Scope

The following are explicitly excluded from Phase 1:

1. Voice channel deployment
2. Email-to-case agent handling
3. Order modification or cancellation by the agent
4. Payment processing or refund issuance by the agent
5. Warranty claim adjudication
6. Data Cloud unification beyond agent grounding
7. Locales other than `en_US` and `es_MX`
8. Agent deployment to any channel other than web messaging

---

## 8. Assumptions

1. Cascade provides a sandbox with representative Case and Contact data.
2. Cascade's knowledge base is empty at project start; all articles are
   drafted under this SOW.
3. Cascade's messaging channel licenses are provisioned before Week 4.
4. Cascade provides a single business owner empowered to approve guardrail
   calibration decisions.
5. Spanish-language article translation is provided by Cascade; NeuraFlash
   drafts source articles in English only.
6. Agentforce and Data Cloud are provisioned in Cascade's org before Week 4.
7. UAT participants are identified by Week 8.
8. Cascade's support team owns post-handoff agent tuning.

---

## 9. Dependencies

1. Sandbox access with Agentforce enabled — Cascade, Week 1
2. Messaging channel licenses — Cascade, Week 4
3. Knowledge article review and publication — Cascade, Week 8
4. Spanish translation of approved articles — Cascade, Week 10
5. UAT participant availability — Cascade, Weeks 10–12

---

## 10. Commercial Terms

**Total Engagement Value:** $187,500

| Milestone | Trigger | Amount |
|-----------|---------|--------|
| M1 | SOW execution | $46,875 |
| M2 | Solution Design Document accepted | $46,875 |
| M3 | UAT entry | $46,875 |
| M4 | Operations handoff complete | $46,875 |

---

## 11. Project Team

| Name | Organization | Role | Email |
|------|--------------|------|-------|
| Priya Raghavan | NeuraFlash | Engagement Manager | priya.raghavan@neuraflash.example.com |
| Daniel Okafor | NeuraFlash | Solution Architect | daniel.okafor@neuraflash.example.com |
| Maya Lindqvist | NeuraFlash | Delivery Analyst | maya.lindqvist@neuraflash.example.com |
| Tomas Reyes | NeuraFlash | Technical Architect | tomas.reyes@neuraflash.example.com |
| Ellen Whitcomb | Cascade Outdoor Supply | Project Sponsor, VP Customer Experience | ellen.whitcomb@cascadeoutdoor.example.com |
| Marcus Dell | Cascade Outdoor Supply | IT Lead | marcus.dell@cascadeoutdoor.example.com |
| Sonia Park | Cascade Outdoor Supply | Support Operations Manager | sonia.park@cascadeoutdoor.example.com |
| Reed Callahan | Cascade Outdoor Supply | Knowledge Owner | reed.callahan@cascadeoutdoor.example.com |

---

*End of Statement of Work v1.0*
