# Team Development Reference

Frameworks for coaching SEs, running effective 1:1s, managing enablement, and keeping the team retained and growing.

---

## The SE Development Stack

SEs have a natural growth arc. Understanding where each person is on this arc shapes how you coach them.

```
Level 1 — Technical Proficiency
    Can demo the product, answer technical questions, run a basic POC
    
Level 2 — Customer Fluency  
    Understands customer problems, can connect product to pain, adapts the demo
    
Level 3 — Deal Navigation
    Can manage a technical evaluation end-to-end, identify stakeholders, de-risk
    
Level 4 — Strategic Impact
    Drives pipeline independently, develops IPs (workshops, frameworks), mentors others
    Influences product roadmap through field intelligence
    Leads without authority in complex multi-stakeholder deals
```

Most SE teams have a mix across these levels. Your coaching goal is to move each person up one meaningful level per year — not to make everyone Level 4 immediately, and not to let high performers stagnate at Level 3.

---

## 1:1 Framework

### The Purpose of a 1:1

A 1:1 is not a status update meeting. Status belongs in async formats (Slack, CRM, team meetings). A 1:1 is for the things that don't happen in a group:
- Building the individual relationship and trust
- Surfacing what's actually going on (deals, team dynamics, career)
- Development coaching that's specific to this person
- Catching retention signals before they become a notice letter
- Following up on commitments from previous sessions

If your 1:1s feel like status updates, restructure them.

### Cadence Recommendations

- **Weekly**: For new SEs (first 90 days), for SEs in a growth stretch, for anyone showing retention signals
- **Biweekly**: For experienced SEs who are performing well and relatively stable
- **Never cancel for deal pressure**: The weeks you most want to cancel are the weeks 1:1s matter most

### 1:1 Structure (30-45 min)

**Opening (5 min)**
Start with a genuine check-in, not a task review. "How are you doing — not the work, but you?" This sounds small but it signals that you see the person, not just the output.

**Their agenda (15-20 min)**
Ask what they want to cover first. Good 1:1s are primarily driven by the SE's agenda, not yours. If they consistently have nothing, that's a signal — either they don't feel safe bringing things to you, or they're disengaged.

Topics they might bring:
- Deal they're stuck on (coaching opportunity)
- Something they saw in the field worth discussing
- Interpersonal situation with an AE or customer
- Career question
- Process or tooling frustration

**Your agenda (10-15 min)**
After theirs. Keep this to 2-3 items — if you have more, put them in Slack. Your items might include:
- Follow-up on a previous development goal
- Specific feedback (positive or constructive) from something recent
- An opportunity you want to offer them (lead a workshop, join a strategic call)
- A heads-up about something changing in the business

**Closing (2-3 min)**
"What's the one thing you're taking away from this conversation?" and "What am I doing/not doing that would help you?" The second question is uncomfortable at first — but it's the fastest way to build trust and improve as a manager.

### Using Obsidian Notes Effectively

Keep one note per SE in your Obsidian vault with a consistent structure:

```
# [SE Name] 1:1s

## [Date]
**Their agenda:**
**My agenda:**
**Key themes:**
**Follow-ups — them:**
**Follow-ups — me:**
**Development thread:**
```

The development thread is the most important part. It tracks what you've been coaching this person on across multiple sessions. Without it, development conversations tend to reset each session rather than building.

Before each 1:1, review the last 2-3 sessions and the development thread. Come in with one specific observation or question connected to what's been discussed before.

---

## Coaching Framework

### The Coaching vs. Telling Distinction

Telling: "Here's what you should have done in that demo."
Coaching: "What do you think happened? What would you do differently?"

Telling is faster. Coaching builds capability. Both have their place — but SE managers over-index on telling because it's quicker in the moment. The problem: the SE learns the answer to that specific situation, not how to develop judgment for the next one.

**When to tell**: When there's a clear right answer, the situation is time-sensitive, or it's a compliance/safety issue.
**When to coach**: When the person has the capacity to work it out with guidance, and the learning is more valuable than the speed.

### The GROW Model (a simple coaching structure)

When an SE brings a deal or situation they're struggling with, this structure helps:

**Goal**: "What outcome are you trying to achieve in this situation?"
**Reality**: "Where do you think things stand right now? What's getting in the way?"
**Options**: "What options do you see? What else could you try? What would you do if [constraint] wasn't there?"
**Way forward**: "What are you going to do? What do you need from me?"

This doesn't mean running through GROW like a checklist. It means holding back your answer long enough to ask the right questions first.

### Giving Feedback That Actually Changes Behavior

Feedback that sticks is specific, timely, connected to impact, and given with care.

**Weak feedback:** "You need to be more concise in demos."
**Strong feedback:** "In the Acme call Wednesday, you spent 8 minutes on the architecture diagram before the customer had told us their core concern. I watched [CTO name] start checking his phone. Next time, try asking 'what would be most useful to see first?' before going into the technical depth."

The formula: **Observation** (what I saw) + **Impact** (what it caused) + **Alternative** (what else you could try) + **Invitation** (what do you think?)

**On positive feedback:** Be specific here too. "Great demo" is forgettable. "The way you connected their CI/CD pipeline problem to the signing use case in the first 5 minutes — that was exactly the right move, and I could see [champion] light up." That sticks.

---

## Enablement Planning

### What Enablement Actually Is

Enablement is the work of making the SE team field-ready on a specific topic — product, competitive, use case, or skill. Bad enablement is a slide deck in Confluence. Good enablement is when SEs can confidently handle a customer conversation about that topic without help.

The test: "Can each SE on my team independently handle a prospect's deep technical questions on [topic]?" If not, the enablement isn't done.

### Enablement vs. Awareness

Some topics require full readiness (can demo it, can answer hard questions, can run a POC). Others just need awareness (can recognize when it's relevant, knows to loop in a specialist).

For your quarterly enablement goals, be explicit about which level you're targeting:
- **Full readiness**: Core product capabilities, current quarter's priority use cases, key competitive scenarios
- **Awareness**: Adjacent product areas, emerging use cases, long-horizon roadmap items

### Effective Enablement Formats

**Not effective alone:**
- Slide decks sent async
- All-hands product updates without practice
- "Just read the docs"

**More effective:**
- Live session with hands-on lab or demo practice
- "Teaching back" — have an SE teach the topic to the rest of the team (forces real mastery)
- Shadow sessions — pair a developing SE with a strong one on a real customer call for a new use case
- Deal debrief with explicit focus on a specific technical competency

**Most effective:**
- Customer conversation where the SE owns the topic (real practice)

### Tracking Readiness

A simple quarterly readiness matrix:

| SE Name | Core Product | [Priority Use Case] | [Key Competitor] | [New Feature] |
|---------|-------------|---------------------|-----------------|----------------|
| [Name] | ✅ Ready | 🟡 Developing | ✅ Ready | ❌ Not started |

Use this in 1:1s ("you're in 'developing' on [use case] — what would getting to ready look like for you?") and in quarterly planning to set enablement goals.

---

## Retention and Engagement

### The Retention Conversation You Should Have Proactively

Once a year minimum (and when you see warning signals), have a direct conversation:

"I want to make sure you're in a place where you want to stay and where you feel like you're growing. Can we talk about what's keeping you engaged — and what, if anything, would make this job better for you?"

This conversation is uncomfortable for many managers. Have it anyway. The cost of a proactive retention conversation is one slightly awkward 30 minutes. The cost of losing an experienced SE is typically 6-12 months of productivity disruption, recruiting cost, and institutional knowledge loss.

### What SEs Usually Leave For

**Better compensation**: Especially if they've been in-band too long or the market has shifted. Annual comp conversations shouldn't wait for a retention crisis.

**Title/growth stagnation**: SEs who feel stuck at the same level for 2+ years often leave even if they like the work. Create visible growth paths — "here's what Principal SE looks like, here's what we'd need to see from you."

**AE relationship friction**: SEs who consistently work with AEs who undervalue their contributions or include them poorly in deals burn out and leave. This is worth monitoring — which AE partnerships are your SEs energized by vs. drained by?

**Lack of interesting work**: SEs who are always doing the same demo for the same use case stop growing. Rotate the interesting deals, give high performers exposure to strategic or complex accounts.

**Manager relationship**: Direct manager quality is the strongest predictor of retention after compensation. The 1:1 relationship is the primary lever you have here.

### When Someone Does Leave

Even when you handle retention well, people leave. When they do:
1. Have an honest exit conversation — understand the real reason, not just the polite version
2. Ask for 2-3 specific pieces of feedback on what you or the company could do better
3. Leave the door open — SEs who leave often consider boomeranging, especially if the exit is handled well

---

## Individual Development Plans (IDPs)

### Why Bother

IDPs are often treated as HR formality. Done well, they're the most valuable tool you have for retaining high performers and developing the rest of the team.

An IDP answers:
- Where does this SE want to go (in 1-3 years)?
- What do they need to develop to get there?
- What specific actions will they take this quarter?
- What will you do to support them?

### A Simple IDP Format (per quarter)

```
SE Name: [Name]
Quarter: [Q X YEAR]

Where they want to go (longer horizon):
[2-3 sentences on their stated career direction]

Development focus this quarter:
[One specific capability or area — not a list]

How we'll develop it:
[Specific actions: lead X workshop, shadow Y call, complete Z course, take on specific project]

How we'll know they've grown:
[What does success look like? Observable behavior, not just completion of activities]

Manager commitments:
[What will you do to support this? Provide the opportunity? Give specific feedback?]
```

Review at end of quarter: What happened? What's next?

### Matching Opportunities to Development Goals

The most powerful enablement isn't training — it's doing real work at the edge of someone's capability with support. 

As you plan each quarter, actively think: "Which deal, event, or project could I assign to develop [SE name]?" Match the opportunity to the development goal:
- Want to develop strategic account skills? → Give them a named account with a complex buying committee
- Want to develop facilitation skills? → Give them lead on the next workshop (you attend, they drive)
- Want to develop competitive expertise? → Make them the team's designated point person on a key competitor for 90 days
