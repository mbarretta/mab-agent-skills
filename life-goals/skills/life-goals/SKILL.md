---
name: life-goals
description: A living goal system for defining north star values and vision, cascading them into near and mid-term goals across all life domains, and building atomic habits to achieve them. Use this skill whenever the user wants to work on their goals, life vision, retirement or financial planning, career direction, habit formation, personal development, quarterly planning, or any kind of goal review or check-in. Also trigger when the user says things like "help me with my goals", "let's review my goals", "what should I be working on", "I need to plan for the future", "update my goal system", "help me set priorities", "I want to be more intentional about my life", or similar. This is a continuous, living system — invoke it both for initial setup and for ongoing reviews and regeneration.
---

# Life Goals System

A living framework for building an intentional life across all domains — career, family, financial security, health, personal growth, and legacy. This skill synthesizes proven methodologies (GTD Horizons, OKRs, Atomic Habits, 12 Week Year) into a continuous loop: **define → plan → execute → review → redefine**.

Read `references/frameworks.md` if you need the full theoretical background on any of these methodologies. The working principles at the bottom of this file explain why the system is designed the way it is.

---

## Persistent State

All goal data lives in the user's workspace at `goals/GOALS.md`. This is the living document the system centers on.

**Always start by checking if this file exists:**
- If it exists: read it before doing anything else — it's your context
- If it doesn't exist: begin with Mode 1 (Initial Setup)

After every session, update `goals/GOALS.md` to reflect any new decisions, progress, or changes. This file is how future sessions pick up where the last one left off.

---

## Choosing a Mode

Ask the user which mode they want, or infer from context:

| Mode | When to use |
|------|-------------|
| **1. Setup** | First time, or user wants a full reset of their goal system |
| **2. Review** | Scheduled check-in — weekly, monthly, quarterly, or annual |
| **3. Regenerate** | Life has changed significantly; goals need to catch up |
| **4. Quick Check** | User wants a fast "what should I focus on right now?" |

---

## Mode 1: Initial Setup (North Star → Habits)

This is the full journey from values to daily habits. It takes real thought — don't rush it. The goal is to build a system the user can live inside, not a list they'll abandon.

Work through these phases conversationally. Don't fire all questions at once. Read the room — if someone is processing something deeply, give it space.

### Phase 1: Values & Life Vision

These questions surface what actually matters. They're intentionally provocative because surface-level answers produce surface-level goals.

**Ask these across 2-3 conversational turns, not all at once:**

1. **Eulogy test**: "Imagine it's 30 years from now and someone who knew you well is describing the life you lived — your character, your impact, what you built. What would you most want them to say?"

2. **Domain satisfaction scan**: Walk through each life domain (Health, Financial, Family, Career, Personal Growth, Legacy). For each: "On a scale of 1-10, how satisfied are you right now? What would a 10 look like for you specifically?"

3. **Anti-goals**: "What does a life you'd regret look like? What are you most afraid of *becoming* or *missing*?" (Anti-goals often reveal real values more clearly than positive questions.)

4. **Compound question**: "If you woke up 10 years from now and felt deeply satisfied with your life — what would be true about your finances, your family, your health, and your work?"

After gathering responses, synthesize them into a **North Star Statement** — 2-4 sentences capturing who they're becoming and what they're building. Share it back for their reaction and refine together. This statement is the anchor for every goal decision that follows.

### Phase 2: Time Horizon Cascade

Work backwards from the 30-year vision to today. This is how the north star becomes actionable.

For each domain where the user scored below 8 or named a meaningful aspiration, build the cascade. Read `references/domains.md` for domain-specific guiding questions.

**10-Year Milestone** (by [YEAR + 10]):
"What would need to be true in your [domain] in 10 years for you to be confidently on track toward your vision?"
Keep these concrete enough to picture but expansive enough to inspire.

**3-Year Goal** (by [YEAR + 3]):
Use OKR format for clarity and measurability:
- **Objective**: Aspirational, motivating, qualitative
- **Key Result 1-3**: Specific, measurable outcomes that prove the objective was achieved

**1-Year Objective** (by [YEAR + 1]):
What specifically needs to happen *this year*? This should feel challenging but achievable.

**90-Day Sprint** (next 12 weeks):
This is where real execution lives. What is the single highest-leverage thing to work on in the next 12 weeks? Name a sprint theme (one phrase) and 2-3 sprint goals with measurable targets.

> **Focus discipline**: Resist the urge to work all domains simultaneously. Pick 1-2 primary domains per sprint. Progress in one domain often lifts others (financial security reduces family stress; better health improves work output).

### Phase 3: Habit Design (Atomic Habits)

For each 90-day sprint goal, design the supporting daily and weekly habits. Good habits are the infrastructure beneath goals — they make consistent progress automatic rather than willpower-dependent.

For each key habit, define:

1. **Identity anchor** — "Who do I need to *become* to achieve this?" Frame as "I am someone who..." This is the deepest lever in habit design: behavior change that sticks almost always flows from identity change.

2. **Implementation intention** — "I will [SPECIFIC BEHAVIOR] at [SPECIFIC TIME] in [SPECIFIC LOCATION]." Vague habits fail. Specific ones stick.

3. **Habit stack** — "After [ESTABLISHED CURRENT HABIT], I will [NEW HABIT]." Attaching a new habit to an existing one dramatically increases follow-through.

4. **Make it measurable** — one trackable metric per habit, reviewed weekly. Can be a simple ✅/❌ streak or a number.

Read `references/frameworks.md` for the full Atomic Habits 4 Laws framework if you need to go deeper on habit design for difficult situations.

### Phase 4: Write GOALS.md

After gathering everything, create `goals/GOALS.md` in the workspace using the template at the end of this file. Make it feel personal — use the user's actual words where possible, not sanitized summaries. Their voice in the document matters for re-engagement.

Tell the user when it's written and offer to show them the first section.

---

## Mode 2: Review

Read `references/review-templates.md` for structured formats for each review type.

**Determine the right review type** based on context clues or by asking:
- **Weekly** (~15 min): Habit check-in, wins, blockers, next week's focus
- **Monthly** (~30 min): Sprint progress, metric check, adjustments needed  
- **Quarterly** (~60 min): Sprint retrospective + design the next 90-day sprint
- **Annual** (~2 hours): Full domain scan, OKR refresh, 3-year check

After every review:
1. Update `goals/GOALS.md` — add progress notes, update metrics, record the date
2. Surface 2-3 key insights or patterns from the review
3. Name the single most important action for the next period
4. Set or confirm the date for the next review

---

## Mode 3: Regenerate

Life changes — job shifts, family events, health, financial windfalls or setbacks — can make existing goals stale or wrong. Regenerate is for when the system needs to catch up to reality.

1. Ask: "What's changed since we last built your goal system? What's different about your situation, your priorities, or what you want your life to look like?"

2. Identify which domains and time horizons are most affected by the change.

3. Re-run the relevant phases of Mode 1 for those domains only — don't rebuild everything unless the change is truly sweeping.

4. Update `goals/GOALS.md` with the changes. Move outdated goals to an `## Archive` section at the bottom rather than deleting them — sometimes you want to look back at where you were.

5. Check whether the North Star Statement itself needs updating. Sometimes it doesn't — circumstances change but the deep vision holds. Sometimes it does — and that's okay and worth acknowledging.

---

## Mode 4: Quick Check

For when the user needs fast orientation without a full session.

Read `goals/GOALS.md` and surface:
- The active 90-day sprint and its theme
- This week's top 1-2 priorities
- Which habits are due for attention (based on last check-in date or any gaps in the streak)
- Any upcoming review dates or deadlines

Deliver this as a concise, punchy summary — not a document recitation. Think "here's what matters most right now, and why."

---

## GOALS.md Template

Use this structure when creating or significantly updating the goals file. Populate every section based on the conversation — leave nothing as a generic placeholder if you have the real information.

```markdown
# [Name]'s Life Goals

*Last updated: [DATE]*  
*Active sprint ends: [DATE]*  
*Next review: [DATE] — [weekly / monthly / quarterly / annual]*

---

## North Star

> [2-4 sentences: who you are becoming, what you are building, what you want your life to stand for]

**Core Values:** [3-5 words or short phrases]

---

## Domain Overview

| Domain | Now (1-10) | Vision (10 looks like...) | Current Sprint Focus |
|--------|-----------|--------------------------|----------------------|
| 🏥 Health & Longevity | X | [specific picture] | [focus or "holding"] |
| 💰 Financial & Retirement | X | [specific picture] | [focus or "holding"] |
| 👨‍👩‍👧‍👦 Family & Relationships | X | [specific picture] | [focus or "holding"] |
| 💼 Career & Business Impact | X | [specific picture] | [focus or "holding"] |
| 🌱 Personal Growth | X | [specific picture] | [focus or "holding"] |
| 🌍 Legacy & Contribution | X | [specific picture] | [focus or "holding"] |

---

## 10-Year Milestones (by [YEAR])

### 🏥 Health
[Milestone — what does your health/energy/longevity look like at this point?]

### 💰 Financial
[Milestone — retirement readiness, family security, investment targets, etc.]

### 👨‍👩‍👧‍👦 Family
[Milestone — relationship quality, parenting outcomes, community you've built]

### 💼 Career
[Milestone — role, impact, craft, the work you're known for]

### 🌱 Personal Growth
[Milestone]

### 🌍 Legacy
[Milestone — what have you contributed or set in motion?]

---

## 3-Year Goals (by [YEAR])

### [Domain]: [Objective]
- **KR1:** [Measurable outcome]
- **KR2:** [Measurable outcome]
- **KR3:** [Measurable outcome]

[Repeat for each active domain — typically 2-3 domains]

---

## Annual OKRs ([YEAR])

### O1: [Objective]
- KR1: [Metric] — Target: [X] | Current: [Y]
- KR2: [Metric] — Target: [X] | Current: [Y]

### O2: [Objective]
- KR1: [Metric] — Target: [X] | Current: [Y]
- KR2: [Metric] — Target: [X] | Current: [Y]

[3-4 objectives max — more than this dilutes focus]

---

## Current 90-Day Sprint

**Sprint:** [START DATE] → [END DATE]  
**Theme:** "[One phrase that captures the sprint's energy]"

### Sprint Goals

| Goal | Metric | Target | Current | Status |
|------|--------|--------|---------|--------|
| [Goal] | [KPI] | [X] | [Y] | 🟢 On track / 🟡 At risk / 🔴 Off track |

### Active Habits

| Habit | Identity ("I am...") | Trigger / Stack | Frequency | Streak |
|-------|---------------------|-----------------|-----------|--------|
| [Habit name] | [I am someone who...] | After [X], I... | Daily | ✅✅✅❌✅✅✅ |

---

## Weekly Log

### Week of [DATE]
**Wins:**  
**Challenges:**  
**Habit check:**  
**Next week's #1 focus:**  

---

## Archive

[Previous sprints, completed goals, retired objectives — kept for reflection]
```

---

## Working Principles

**Fewer goals, deeper commitment.** The temptation is to optimize all 6 domains at once. Resist it. Compound progress in 1-2 domains per sprint produces far better results than diffuse effort across all of them.

**Identity before outcomes.** "I am someone who protects their health" is a more durable foundation than "I want to lose 20 lbs." Identity-based habits survive bad days. Outcome-based goals don't.

**Momentum over motivation.** Design habits for your worst days, not your best. If you can execute when you're tired, stressed, and busy — that's a real habit. If it only works when you're feeling good — it's a wish.

**The review is the keystone habit.** Nothing in this system works without consistent, honest review. Protect it the way you'd protect a non-negotiable meeting. The weekly review is the minimum — it's what keeps you from drifting for months before noticing.

**Compound interest applies to decades.** Small consistent improvements in each domain compound dramatically over 20-30 years. You don't need to make giant leaps — you need to keep moving in the right direction and not lose ground. At 48, with several decades ahead, this is actually a position of enormous leverage. The runway is long enough for compounding to do serious work.

**The system serves you, not the other way around.** If part of this feels forced or doesn't fit, change it. The best goal system is the one you'll actually use. Adapt the templates, the review cadences, the domain names — whatever makes this feel like yours.
