# CKA Certification Plan

**Status:** In Progress
**Date:** 2026-04-06
**Target exam date:** Week of May 4-8, 2026

---

## Overview

This document captures the full CKA (Certified Kubernetes Administrator) study plan, course selection rationale, timeline estimates, and certification sequencing decisions. It serves as the planning reference for the CKA certification effort and the broader Kubernetes/Argo certification path.

---

## Certification Sequence

The following order was established in the AIF-C01 blog post conversation and confirmed here:

1. **CKA** (Certified Kubernetes Administrator) -- immediate priority
2. **CAPA** (Certified Argo Project Associate) -- after CKA, leveraging the Pi cluster
3. **CKAD** (Certified Kubernetes Application Developer) -- further out
4. **Terraform Associate** -- further out

CKAD and Terraform Associate are intentionally deferred. The lesson from AIF-C01 is to focus on one thing at a time.

---

## Exam Details

- **Format:** Online, proctored, performance-based (live cluster tasks, not multiple choice)
- **Duration:** 2 hours
- **Passing score:** 66%
- **Cost:** $445 (includes one free retake and two Killer.sh practice sessions)
- **Kubernetes version:** v1.35 (exam aligns within 4-8 weeks of K8s releases)
- **Eligibility window:** 12 months from purchase
- **Certification validity:** 2 years
- **Open book:** kubernetes.io/docs is accessible during the exam

---

## Prerequisites (Bounded Tasks Before Study Begins)

Per the blog post planning conversation, the RPi cluster assembly is a finite prerequisite, not a parallel activity.

**Sequence:** Assemble cluster, generate TMH content bundle for CKA, schedule the exam, then study block begins. No cluster tinkering after the study block starts.

The three Raspberry Pi 5 (8GB) nodes with NVMe drives need physical assembly and k3s deployment using the existing `bake_rpi.sh` script. This cluster serves dual purpose: hands-on CKA lab environment and future Argo platform.

---

## Course Selection

### Primary Course

**Mumshad Mannambeth -- "Certified Kubernetes Administrator (CKA) with Practice Tests" (Udemy)**

- URL: https://www.udemy.com/course/certified-kubernetes-administrator-with-practice-tests/
- 314 lectures, 26 hours video, 18 sections
- Integrated KodeKloud browser-based labs (71 labs total)
- 3 course mock exams with video solutions
- Last updated April 2026, lab environment on K8s v1.33
- 4.7 rating, 90,370 ratings, 422,179 students

Selected because KodeKloud's integrated lab environment is the community standard for CKA prep. The performance-based exam format demands hands-on practice, not passive video consumption.

### Supplementary (Coursera, covered by Pro membership)

**Pearson CKA Specialization** -- 3 units covering cluster architecture, workload scheduling, networking, storage, security, troubleshooting. Includes hands-on labs and two full-length practice exams. Uses kubeadm for cluster setup. Available as backup if KodeKloud labs prove insufficient.

**Whizlabs CKA course** -- 7+ hours, 6 modules. Significantly thinner than other options. Not recommended as primary.

### Practice Exams

**Killer.sh** -- Two sessions included with CKA exam registration. 36 hours access per session. Intentionally harder than the real exam. These are the standard diagnostic tool for CKA readiness.

---

## Timeline Estimate

**Total: ~4.5 weeks (23 study days)**

| Phase | Days | Duration | Notes |
|---|---|---|---|
| Course + labs | Days 1-17 | 3.5 weeks | Mumshad course, KodeKloud labs |
| Killer.sh Session 1 + remediation | Days 18-20 | 3 days | Diagnostic, gap categorization, targeted review |
| Killer.sh Session 2 + final polish | Days 21-22 | 2 days | Validation, exam environment prep |
| Exam day | Day 23 | 1 day | Target: May 7-8, 2026 |

Weekends serve as catch-up buffer, not mandatory study. The plan assumes full days available (unemployed schedule) with 3-5 hours of actual work per day (video + labs).

### Key Risk

The AIF-C01 experience showed that building tools (TMH features, homelab, local ML pipeline) instead of studying is the primary failure mode. The study plan explicitly front-loads the course and defers all cluster tinkering until after the exam.

---

## Course Curriculum Breakdown

The 18 sections vary dramatically in weight. Security (4hr 4min) and Networking (3hr 21min) are the heaviest and map to the highest-weighted CKA exam domains.

| Section | Lectures | Video Duration | Labs |
|---|---|---|---|
| S1: Introduction | 5 | 13min | 0 |
| S2: Core Concepts | 44 | 3hr 39min | 6 |
| S3: Scheduling | 38 | 3hr 2min | 7 |
| S4: Logging & Monitoring | 7 | 14min | 2 |
| S5: Application Lifecycle Management | 35 | 2hr 22min | 10 |
| S6: Cluster Maintenance | 13 | 46min | 3 |
| S7: Security | 45 | 4hr 4min | 10 |
| S8: Storage | 16 | 1hr 5min | 2 |
| S9: Networking | 37 | 3hr 21min | 8 |
| S10: Design and Install a Kubernetes Cluster | 5 | 32min | 0 |
| S11: Install Kubernetes the kubeadm way | 6 | 44min | 1 |
| S12: Helm Basics | 11 | 50min | 3 |
| S13: Kustomize Basics | 22 | 1hr 30min | 5 |
| S14: Troubleshooting | 12 | 1hr 13min | 4 |
| S15: Other Topics | 4 | 12min | 2 |
| S16: Lightning Labs | 2 | 1min | 1 |
| S17: Mock Exams | 6 | 2hr 5min | 3 |
| S18: Bonus Section | 6 | 15min | 0 |

**Total: 314 lectures, 26 hours video, 71 labs**

The detailed lecture-level daily study plan is in the companion document: `cka-daily-study-plan.md`

---

## CAPA (Certified Argo Project Associate) Planning

Captured here for reference. CAPA study begins after CKA is complete.

### Exam Details

- **Format:** Online, proctored, multiple-choice (not performance-based)
- **Cost:** $250 (includes one free retake)
- **Covers:** Argo CD, Argo Workflows, Argo Rollouts, Argo Events
- **Prerequisite:** None officially, but Kubernetes basics (CKA-level) are essential
- **Note:** 2026 exam feedback indicates scenario-based questions requiring understanding of YAML manifests and CLI outputs

### Course Options (Udemy)

1. **"Argo CD Associate (CAPA) Exam 2026 Questions Updated"** by a Golden Kubestronaut -- theory + hands-on labs + exam-style question bank covering all four Argo tools. Strongest comprehensive option on Udemy.
2. **"Argo CD for the Absolute Beginners - Hands-On DevOps"** -- foundational, more Argo CD focused, includes end-to-end CI/CD capstone with GitHub Actions. Less coverage of Workflows/Events/Rollouts.
3. **Practice exam courses** -- several available, but at least one was flagged as AI-generated with quality concerns. Use with caution.

### Official Training

**LFS256: DevOps and Workflow Management with Argo** -- Linux Foundation official course. $99 standalone or $299 bundled with CAPA exam (exam alone is $250, so the bundle saves $50 and includes the official training).

### Estimated Timeline

CAPA is multiple-choice and the Argo ecosystem is narrower than Kubernetes. With CKA already done and the Pi cluster running Argo, estimated 2-3 weeks of study.

---

## CKAD Planning

Captured here for reference. CKAD study begins after CAPA.

### Course Options

**Udemy:**
- Mumshad Mannambeth -- "Kubernetes Certified Application Developer (CKAD) with Tests" -- same KodeKloud lab format as the CKA course

**Coursera (covered by Pro membership):**
- Pearson CKAD Specialization -- covers containers, deployment, networking, security, troubleshooting with hands-on labs and self-grading practice exam
- LearnKartS CKAD Exam Prep Specialization -- more foundational, multi-course path

### Estimated Timeline

Significant CKA overlap. With CKA already passed, incremental study time is approximately 2 weeks. CKAD focuses on application developer concerns: pod design, multi-container patterns, observability, services/networking from an app perspective, Helm.

---

## Lessons Applied from AIF-C01

The AIF-C01 certification experience (March 2026, score 761/1000, marginal pass) produced several process changes that this plan incorporates:

1. **Schedule the exam early.** The exam date creates a deadline that prevents scope creep.
2. **Separate study blocks from build blocks.** No TMH features, no homelab tinkering, no ML pipeline work during the study phase.
3. **Daily retrieval practice.** The CKA is performance-based, which naturally enforces this through KodeKloud labs.
4. **Track time allocation.** Know how many hours went to studying vs. building.
5. **Diagnostic gap analysis over raw retesting.** Categorize Killer.sh misses into coverage gaps, retention issues, and speed issues rather than just retaking tests.

---

## Open Questions

- Should the CKA exam be registered and scheduled before starting the course (to enforce the deadline) or after the Pi cluster is assembled?
- Is the Pearson Coursera specialization worth doing in parallel with Mumshad's course, or is it redundant?
- For CAPA, is the LFS256 + exam bundle ($299) worth it over just the exam ($250) + Udemy courses?
