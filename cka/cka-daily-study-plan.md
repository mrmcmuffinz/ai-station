# CKA Course: Lecture-Level Daily Study Plan

**Course:** Certified Kubernetes Administrator (CKA) with Practice Tests
**Instructor:** Mumshad Mannambeth / KodeKloud
**Total:** 314 lectures, 26 hours video, 18 sections

**Schedule:** 14 study days (Mon-Fri), ~3 weeks. Compressed from the original 17-day plan based on
prior Kubernetes experience. Days 1-10 are complete. Day 11 is partially complete (S10 done through
lecture 245, picking up at lecture 246 with S11: Install Kubernetes the kubeadm way). Listed times are
video/reading only. KodeKloud labs add 15-30min each on top.

**Practice repo:** https://github.com/mrmcmuffinz/cka-exam-prep

**Legend**

- [V] Video lecture
- [R] Reading / article
- [L] KodeKloud hands-on lab

-----

## Week 1

### Day 1 (Mon) | 69min video, 0 labs | S1, S2 -- COMPLETE

**S1: Introduction**

- [V] 1. Course Introduction (3m)
- [V] 2. Certification (3m)
- [R] 3. Course Release Notes (2m)
- [V] 4. The Kubernetes Trilogy (5m)
- [R] 5. Notes available at KodeKloud Notes (1m)

**S2: Core Concepts**

- [V] 6. Core Concepts - Section Introduction (1m)
- [V] 7. Cluster Architecture (9m)
- [V] 8. Docker-vs-ContainerD (13m)
- [V] 9. A note on Docker deprecation (2m)
- [V] 10. ETCD For Beginners (7m)
- [V] 11. ETCD in Kubernetes (3m)
- [R] 12. ETCD - Commands (Optional) (1m)
- [V] 13. Kube-API Server (5m)
- [V] 14. Kube Controller Manager (4m)
- [V] 15. Kube Scheduler (4m)
- [V] 16. Kubelet (2m)
- [V] 17. Kube Proxy (4m)

### Day 2 (Tue) | 85min video, 3 labs | S2 -- COMPLETE

**S2: Core Concepts**

- [V] 18. Pods (9m)
- [V] 19. Pods with YAML (7m)
- [V] 20. Demo - Pods with YAML (6m)
- [V] 21. Practice Test Introduction (6m)
- [V] 22. Demo: Accessing Labs (2m)
- [R] 23. Course setup - accessing the labs (1m)
- [L] 24. Lab - Pods (1m)
- [V] 25. Lab Solution - Pods (optional) (12m)
- [V] 26. Recap - ReplicaSets (16m)
- [L] 27. Lab - ReplicaSets (1m)
- [V] 28. Lab Solution - ReplicaSets (optional) (14m)
- [V] 29. Deployments (4m)
- [R] 30. Certification Tip! (1m)
- [L] 31. Lab - Deployments (1m)
- [V] 32. Lab Solution - Deployments (optional) (7m)

### Day 3 (Wed) | 144min video, 7 labs | S2, S3 -- COMPLETE

**S2: Core Concepts**

- [V] 33. Services (14m)
- [V] 34. Services Cluster IP (4m)
- [V] 35. Services - Loadbalancer (4m)
- [L] 36. Lab - Services (1m)
- [V] 37. Lab Solution - Services (optional) (9m)
- [V] 38. Namespaces (8m)
- [L] 39. Lab - Namespaces (1m)
- [V] 40. Lab Solution - Namespaces (optional) (6m)
- [V] 41. Imperative vs Declarative (13m)
- [R] 42. Certification Tips - Imperative Commands with Kubectl (2m)
- [V] 43. Kubectl Explain Command (2m)
- [L] 44. Lab - Imperative Commands (1m)
- [V] 45. Lab Solution - Imperative Commands (optional) (13m)
- [V] 46. Kubectl Apply Command (5m)
- [R] 47. Here's some inspiration to keep going (0m)
- [V] 48. A Quick Reminder (1m)
- [R] 49. Reference Notes for lectures and labs (1m)

**S3: Scheduling (part 1)**

- [V] 50. Scheduling - Section Introduction (1m)
- [V] 51. Manual Scheduling (2m)
- [L] 52. Lab - Manual Scheduling (0m)
- [V] 53. Lab Solution - Manual Scheduling (optional) (7m)
- [V] 54. Labels and Selectors (6m)
- [L] 55. Lab - Labels and Selectors (1m)
- [V] 56. Lab Solution - Labels and Selectors (Optional) (6m)
- [V] 57. Taints and Tolerations (10m)
- [L] 58. Lab - Taints and Tolerations (1m)
- [V] 59. Lab Solution - Taints and Tolerations (Optional) (10m)
- [V] 60. Node Selectors (3m)
- [V] 61. Node Affinity (7m)
- [L] 62. Lab - Node Affinity (1m)
- [V] 63. Lab Solution - Node Affinity (Optional) (10m)

### Day 4 (Thu) | 136min video, 9 labs | S3, S4 -- COMPLETE

**S3: Scheduling (continued)**

- [V] 64. Taints and Tolerations vs Node Affinity (2m)
- [V] 65. Resource Requirements (15m)
- [R] 66. A quick note on editing Pods and Deployments (1m)
- [L] 67. Lab - Resource Limits (0m)
- [V] 68. Lab Solution - Resource Limits (5m)
- [V] 69. DaemonSets (4m)
- [L] 70. Lab - DaemonSets (0m)
- [V] 71. Lab Solution - DaemonSets (optional) (6m)
- [V] 72. Static Pods (9m)
- [L] 73. Lab - Static Pods (1m)
- [V] 74. Lab Solution - Static Pods (Optional) (15m)
- [V] 75. Priority Classes (6m)
- [L] 76. Lab - Priority Classes (1m)
- [V] 77. Multiple Schedulers (9m)
- [L] 78. Lab - Multiple Schedulers (1m)
- [V] 79. Lab Solution - Multiple Scheduler (7m)
- [V] 80. Configuring Scheduler Profiles (9m)
- [R] 81. References (1m)
- [V] 82. Admission Controllers (8m)
- [L] 83. Lab - Admission Controllers (1m)
- [V] 84. Lab Solution: Admission Controllers (7m)
- [V] 85. Validating and Mutating Admission Controllers (10m)
- [L] 86. Lab - Validating and Mutating Admission Controllers (1m)
- [V] 87. Lab Solution: Validating and Mutating Admission Controllers (8m)

**S4: Logging & Monitoring**

- [V] 88. Logging and Monitoring - Section Introduction (1m)
- [V] 89. Monitor Cluster Components (4m)
- [L] 90. Lab - Monitoring Cluster Components (1m)
- [V] 91. Lab Solution: Monitor Cluster Components (4m)
- [V] 92. Managing Application Logs (3m)
- [L] 93. Lab - Monitor Application Logs (0m)
- [V] 94. Lab Solution: Logging (Optional) (3m)

*Admission controllers are the one S3 topic worth revisiting if anything felt shaky. S4 is short enough that it should not need review.*

### Day 5 (Fri) | 161min video, 12 labs | S5 -- COMPLETE

**S5: Application Lifecycle Management**

- [V] 95. Application Lifecycle Management - Section Introduction (1m)
- [V] 96. Rolling Updates and Rollbacks (7m)
- [L] 97. Lab - Rolling Updates and Rollbacks (0m)
- [V] 98. Lab Solution: Rolling update (9m)
- [R] 99. Configure Applications (1m)
- [V] 100. Commands and Arguments in Docker (7m)
- [V] 101. Commands and Arguments in Kubernetes (3m)
- [L] 102. Lab - Commands and Arguments (0m)
- [V] 103. Lab Solution - Commands and Arguments (Optional) (20m)
- [V] 104. Configure Environment Variables in Applications (1m)
- [V] 105. Configuring ConfigMaps in Applications (5m)
- [L] 106. Lab: Env Variables (0m)
- [V] 107. Lab Solution - Env Variables (Optional) (9m)
- [V] 108. Secrets (6m)
- [L] 109. Lab - Secrets (0m)
- [R] 110. Additional Resource (1m)
- [V] 111. Lab Solution - Secrets (Optional) (10m)
- [V] 112. Demo: Encrypting Secret Data at Rest (19m)
- [R] 113. A Note on Secrets (1m)
- [R] 114. Scale Applications (1m)
- [V] 115. Multi Container Pods (2m)
- [V] 116. Multi container Pods Design Pattern (6m)
- [L] 117. Lab - Multi Container Pods (1m)
- [R] 118. InitContainers (2m)
- [L] 119. Lab - Init Containers (1m)
- [V] 120. Lab Solution - Init Containers (Optional) (11m)
- [R] 121. Self Healing Applications (1m)
- [V] 122. Introduction to Autoscaling (5m)
- [V] 123. Horizontal Pod Autoscaler (HPA) (5m)
- [L] 124. Lab - Manual Scaling (1m)
- [L] 125. Lab - HPA (1m)
- [V] 126. In-Place Resize of Pods (4m)
- [V] 127. Vertical Pod Autoscaling (VPA) (9m)
- [L] 128. Lab - Install VPA (1m)
- [L] 129. Lab - Modifying CPU resources in VPA (1m)

*Weekend: S5 covered a lot of ground. Rolling updates, ConfigMaps, Secrets, multi-container patterns, and autoscaling are all exam-relevant. Redo any labs that felt uncertain before Security starts on Day 6.*

-----

## Week 2

### Day 6 (Mon) | 152min video, 6 labs | S6, S7 -- COMPLETE

**S6: Cluster Maintenance -- COMPLETE**

- [V] 130. Cluster Maintenance - Section Introduction (1m)
- [V] 131. OS Upgrades (4m)
- [L] 132. Lab - OS Upgrades (0m)
- [V] 133. Kubernetes Releases (2m)
- [R] 134. References (1m)
- [V] 135. Cluster Upgrade Introduction (11m)
- [V] 136. Demo - Cluster upgrade (19m)
- [L] 137. Lab - Cluster Upgrade (0m)
- [V] 138. Backup and Restore Methods (6m)
- [R] 139. Working with ETCDCTL and ETCDUTL (1m)
- [L] 140. Lab - Backup and Restore Methods (1m)
- [R] 141. Certification Exam Tip! (1m)
- [R] 142. References (1m)

**S7: Security (part 1, through KubeConfig) -- COMPLETE**

- [V] 143. Security - Section Introduction (2m)
- [V] 144. Kubernetes Security Primitives (3m)
- [V] 145. Authentication (4m)
- [V] 146. TLS Introduction (1m)
- [V] 147. TLS Basics (20m)
- [V] 148. TLS in Kubernetes (8m)
- [V] 149. TLS in Kubernetes - Certificate Creation (11m)
- [V] 150. View Certificate Details (4m)
- [R] 151. Resource: Download K8s Certificate Health Check Spreadsheet (1m)
- [L] 152. Lab - View Certificates (0m)
- [V] 153. Lab Solution - View Certification Details (21m)
- [V] 154. Certificates API (6m)
- [L] 155. Lab - Certificates API (0m)
- [V] 156. Lab Solution - Certificates API (8m)
- [V] 157. KubeConfig (8m)
- [L] 158. Lab - KubeConfig (0m)
- [V] 159. Lab Solution - KubeConfig (8m)

*S6 etcd backup/restore and S7 TLS cert creation are high-value exam topics. Do not rush the labs for lectures 140, 149, and 152-153.*

### Day 7 (Tue) | 120min video, 6 labs | S7 -- COMPLETE

**S7: Security (part 2, RBAC through Network Policy) -- COMPLETE**

- [R] 160. Persistent Key/Value Store (1m)
- [V] 161. API Groups (6m)
- [V] 162. Authorization (8m)
- [V] 163. Role Based Access Controls (4m)
- [L] 164. Lab - Role-Based Access Controls (0m)
- [V] 165. Lab Solution - Role-Based Access Controls (13m)
- [V] 166. Cluster Roles (4m)
- [L] 167. Lab - Cluster Roles (0m)
- [V] 168. Lab Solution - Cluster Roles (11m)
- [V] 169. Service Accounts (8m)
- [L] 170. Lab: Service Accounts (1m)
- [V] 171. Lab Solution: Service Accounts (7m)
- [V] 172. Image Security (5m)
- [L] 173. Lab - Image Security (0m)
- [V] 174. Lab Solution - Image Security (7m)
- [V] 175. Pre-requisite - Security in Docker (6m)
- [V] 176. Security Contexts (2m)
- [L] 177. Lab - Security Contexts (0m)
- [V] 178. Lab Solution - Security Contexts (5m)
- [V] 179. Network Policy (8m)
- [V] 180. Developing network policies (11m)
- [L] 181. Lab - Network Policy (0m)
- [V] 182. Lab Solution - Network Policies (optional) (14m)

*Security is the heaviest CKA exam domain. Redo TLS and RBAC labs if anything felt uncertain on Day 6.*

### Day 8 (Wed) | 86min video, 3 labs | S7, S8 -- COMPLETE

**S7: Security (remainder, CRDs and Operators) -- COMPLETE**

- [R] 183. Kubectx and Kubens - Command Line Utilities (1m)
- [V] 184. Custom Resource Definition (CRD) (11m)
- [L] 185. Lab - Custom Resource Definition (1m)
- [V] 186. Custom Controllers (4m)
- [V] 187. Operator Framework (3m)

**S8: Storage -- COMPLETE**

- [V] 188. Storage - Section Introduction (1m)
- [V] 189. Docker Storage - Introduction (1m)
- [V] 190. Storage in Docker (12m)
- [V] 191. Volume Driver Plugins in Docker (2m)
- [V] 192. Container Storage Interface (4m)
- [V] 193. Volumes (4m)
- [V] 194. Persistent Volumes (3m)
- [V] 195. Persistent Volume Claims (5m)
- [R] 196. Using PVCs in Pods (1m)
- [L] 197. Lab - Persistent Volume Claims (0m)
- [V] 198. Lab Solution - PV and PVC (18m)
- [R] 199. Application Configuration (1m)
- [R] 200. Additional Topics (1m)
- [V] 201. Storage Class (4m)
- [L] 202. Lab - Storage Class (0m)
- [V] 203. Lab Solution - Storage Class (10m)

### Day 9 (Thu) | 93min video, 2 labs | S9 -- COMPLETE

**S9: Networking (prerequisites and CNI)**

- [V] 204. Networking - Introduction (2m)
- [V] 205. Prerequisite Switching, Routing, Gateways CNI (13m)
- [V] 206. Prerequisite DNS (14m)
- [R] 207. Prerequisite - CoreDNS (1m)
- [V] 208. Prerequisite Network Namespaces (15m)
- [R] 209. FAQ (1m)
- [V] 210. Prerequisite Docker Networking (7m)
- [V] 211. Prerequisite CNI (6m)
- [V] 212. Cluster Networking (2m)
- [R] 213. Important Note about CNI and CKA Exam (1m)
- [L] 214. Lab - Explore Environment (0m)
- [V] 215. Lab Solution - Explore Environment (optional) (8m)
- [V] 216. Pod Networking (9m)
- [V] 217. CNI in kubernetes (3m)
- [R] 218. Note CNI Weave (1m)
- [V] 219. CNI weave (6m)
- [L] 220. Lab - CNI (0m)
- [V] 221. Lab Solution - Explore CNI (optional) (2m)
- [V] 222. ipam weave (2m)

*Weekend: Networking is the second-highest weighted CKA domain. The prerequisite videos are conceptual foundation for the lab-heavy days ahead. Redo the Network Policy lab from Day 7 if it felt shaky.*

-----

## Week 3

### Day 10 (Mon) | 110min video, 6 labs | S9 -- COMPLETE

**S9: Networking (service networking, DNS, Ingress, Gateway API)**

- [L] 223. Lab - Networking CNIs (1m)
- [V] 224. Service Networking (9m)
- [L] 225. Lab - Service Networking (0m)
- [V] 226. Lab Solution - Service Networking (optional) (5m)
- [V] 227. DNS in kubernetes (6m)
- [V] 228. CoreDNS in Kubernetes (7m)
- [L] 229. Lab - CoreDNS in Kubernetes (0m)
- [V] 230. Lab Solution - Explore DNS (optional) (16m)
- [V] 231. Ingress (18m)
- [R] 232. Article: Ingress (1m)
- [R] 233. Ingress - Annotations and rewrite-target (2m)
- [L] 234. Lab - CKA Ingress Networking - 1 (1m)
- [V] 235. Lab Solution - Ingress Networking 1 (optional) (16m)
- [L] 236. Lab - CKA Ingress Networking - 2 (1m)
- [V] 237. Lab Solution - Ingress Networking - 2 (optional) (15m)
- [V] 238. Introduction to Gateway API (8m)
- [R] 239. Practical Guide to Gateway API (7m)
- [L] 240. Lab - Gateway API (1m)

### Day 11 (Tue) | 127min video, 4 labs | S10, S11, S12 -- S10 COMPLETE

**S10: Design and Install a Kubernetes Cluster -- COMPLETE**

- [V] 241. Design a Kubernetes Cluster (6m)
- [V] 242. Choosing Kubernetes Infrastructure (6m)
- [V] 243. Configure High Availability (8m)
- [V] 244. ETCD in HA (12m)
- [R] 245. Important Update: Kubernetes the Hard Way (1m)

**S11: Install Kubernetes the kubeadm way**

- [V] 246. Deployment With kubeadm - Introduction (2m)
- [R] 247. Resources (1m)
- [V] 248. Deployment With Kubeadm - Provision VMs With Vagrant (6m)
- [V] 249. Demo - Deployment with Kubeadm (26m)
- [L] 250. Lab - Deploy a Kubernetes Cluster using Kubeadm (1m)
- [V] 251. Lab Solution - Deploy a Kubernetes Cluster using kubeadm (Optional) (10m)

**S12: Helm Basics**

- [V] 252. Helm - Introduction (7m)
- [V] 253. Installation and Configuration (1m)
- [L] 254. Lab: Installing Helm (1m)
- [V] 255. A Quick Note on Helm2 vs Helm3 (8m)
- [V] 256. Helm Components (8m)
- [V] 257. Helm Charts (7m)
- [V] 258. Working With Helm - Basics (6m)
- [V] 259. Customizing Chart Parameters (4m)
- [L] 260. Lab: Using Helm to Deploy a chart (1m)
- [V] 261. Lifecycle Management With Helm (8m)
- [L] 262. Lab: Upgrading a Helm Chart (1m)

### Day 12 (Wed) | 92min video, 5 labs | S13

**S13: Kustomize Basics**

- [V] 263. Kustomize Problem Statement and Ideology (8m)
- [V] 264. Kustomize vs Helm (5m)
- [V] 265. Installation/Setup (1m)
- [V] 266. The kustomization.yaml File (4m)
- [V] 267. Kustomize Output (3m)
- [V] 268. Kustomize ApiVersion & Kind (1m)
- [V] 269. Managing Directories (6m)
- [V] 270. Managing Directories Demo (9m)
- [L] 271. Lab: Managing Directories (1m)
- [V] 272. Common Transformers (3m)
- [V] 273. Image Transformers (3m)
- [V] 274. Transformers Demo (12m)
- [L] 275. Lab: Transformers (1m)
- [V] 276. Patches Intro (9m)
- [V] 277. Different Types of Patches (1m)
- [V] 278. Patches Dictionary (6m)
- [V] 279. Patches List (6m)
- [L] 280. Lab: Patches (1m)
- [V] 281. Overlays (6m)
- [L] 282. Lab: Overlay (1m)
- [V] 283. Components (9m)
- [L] 284. Lab: Components (1m)

### Day 13 (Thu) | 87min video, 7 labs | S14, S15, S16

**S14: Troubleshooting**

- [V] 285. Troubleshooting - Section Introduction (1m)
- [V] 286. Application Failure (3m)
- [L] 287. Lab - Application Failure (1m)
- [V] 288. Lab Solution - Application Failure (Optional) (28m)
- [V] 289. Control Plane Failure (1m)
- [L] 290. Lab - Control Plane Failure (1m)
- [V] 291. Lab Solution - Control Plane Failure (Optional) (16m)
- [V] 292. Worker Node Failure (2m)
- [L] 293. Lab - Worker Node Failure (1m)
- [V] 294. Lab Solution - Worker Node Failure (Optional) (10m)
- [V] 295. Network Troubleshooting (12m)
- [L] 296. Practice Test - Troubleshoot Network (0m)

**S15: Other Topics**

- [L] 297. Lab - JSON PATH (1m)
- [R] 298. Pre-Requisites - JSON PATH (1m)
- [V] 299. JSON Path in Kubernetes (12m)
- [L] 300. Lab - Advanced Kubectl Commands (1m)

**S16: Lightning Labs**

- [R] 301. Lightning Lab Introduction (1m)
- [L] 302. Lightning Lab - 1 (1m)

### Day 14 (Fri) | 140min video, 3 labs | S17, S18

**S17: Mock Exams**

- [L] 303. Mock Exam - 1 (1m)
- [V] 304. Solution - Mock Exam - 1 (Optional) (32m)
- [L] 305. Mock Exam - 2 (1m)
- [V] 306. Mock Exam - 2 - Solution (Optional) (44m)
- [L] 307. Mock Exam - 3 (1m)
- [V] 308. Mock Exam - 3 - Solution (Optional) (48m)

**S18: Bonus Section**

- [R] 309. Bonus Lecture (1m)
- [R] 310. Frequently Asked Questions! (1m)
- [R] 311. More Certification Tips! (1m)
- [V] 312. Conclusion (3m)
- [V] 313. What's Next? (9m)
- [R] 314. Kubernetes Update and Project Videos (1m)

*Course phase complete. Killer.sh phase begins Monday.*

-----

## Killer.sh Practice Exams (Post-Course)

Your CKA exam registration includes two Killer.sh sessions (36 hours access each).
These are intentionally harder than the real exam. Use them as diagnostic tools, not just score checks.

### Day 15 | Killer.sh Session 1

- Take the full Killer.sh practice exam under timed conditions (2 hours)
- Do NOT look at solutions during the attempt
- After submitting: review every question, note which you got wrong
- Categorize each miss into one of three buckets:
  - **Coverage gap:** topic you haven't seen or forgot existed
  - **Retention issue:** topic you studied but couldn't recall under pressure
  - **Speed issue:** knew the answer but ran out of time
- Write down the categorized list before looking at solutions

### Day 16 | Remediation

- Review Killer.sh solutions for all missed questions
- For coverage gaps: go back to the relevant Mumshad lecture and lab
- For retention issues: redo the KodeKloud lab for that topic
- For speed issues: practice the imperative kubectl commands until they are muscle memory
- Focus areas based on typical CKA weak spots: etcd backup/restore, kubeadm upgrades, network policies, RBAC, troubleshooting

### Day 17 | Targeted Lab Review

- Redo the KodeKloud labs you struggled with most across the course
- Practice time-boxed scenarios: set a 5-minute timer per task (exam gives roughly 5-7 min per question)
- Review kubectl cheat sheet and bookmark key docs pages you will need during the exam
- Verify you can navigate kubernetes.io/docs quickly (allowed during the exam)

*Weekend: Rest. Light review only if you feel like it.*

### Day 18 | Killer.sh Session 2

- Take the second Killer.sh session under timed conditions
- Compare results to Session 1: did your targeted remediation close the gaps?
- If score improved significantly: you are ready. Schedule exam for later this week.
- If specific domains are still weak: spend Day 19 on those domains only.

### Day 19 | Final Polish + Exam Prep

- Address any remaining gaps from Session 2
- Review exam logistics: PSI browser setup, ID requirements, workspace rules
- Do a dry run of your exam environment (clean desk, second monitor off, browser ready)
- Light review of your weakest domain, then stop studying by evening

### Day 20 | Exam Day

- Take the CKA exam
- You have 2 hours, 15-20 performance-based tasks
- You can access kubernetes.io/docs during the exam
- Use the flag-and-skip strategy for hard questions, come back after finishing easier ones

-----

## Summary

- **Course study days:** 14 (3 weeks), Days 1-10 complete, Day 11 next (picking up at lecture 246, S11: kubeadm)
- **Killer.sh + remediation:** 5 days (1 week)
- **Total timeline:** ~4 weeks to exam day (compressed from original 4.5)
- **Video/reading:** 1588min (26h 28m)
- **Labs:** 71 KodeKloud labs + 2 Killer.sh sessions + 3 course mock exams
- **Daily commitment:** 3-5 hours (video + labs)
- **Practice repo:** https://github.com/mrmcmuffinz/cka-exam-prep

### Daily load (course phase)

|Day   |Video|Labs|Sections     |Status                                          |
|------|-----|----|-------------|-------------------------------------------------|
|Day 1 |69m  |0   |S1, S2       |Complete                                         |
|Day 2 |85m  |3   |S2           |Complete                                         |
|Day 3 |144m |7   |S2, S3       |Complete                                         |
|Day 4 |136m |9   |S3, S4       |Complete                                         |
|Day 5 |161m |12  |S5           |Complete                                         |
|Day 6 |152m |6   |S6, S7       |Complete                                         |
|Day 7 |120m |6   |S7           |Complete                                         |
|Day 8 |86m  |3   |S7, S8       |Complete                                         |
|Day 9 |93m  |2   |S9           |Complete                                         |
|Day 10|110m |6   |S9           |Complete                                         |
|Day 11|127m |4   |S10, S11, S12|S10 complete, picking up at L246 (S11)           |
|Day 12|92m  |5   |S13          |                                                 |
|Day 13|87m  |7   |S14, S15, S16|                                                 |
|Day 14|140m |3   |S17, S18     |                                                 |

### Killer.sh phase

|Day   |Activity                                            |
|------|----------------------------------------------------|
|Day 15|Killer.sh Session 1 (timed) + gap categorization    |
|Day 16|Remediation: revisit lectures/labs for missed topics|
|Day 17|Targeted lab review + kubectl speed practice        |
|Day 18|Killer.sh Session 2 (timed) + comparison            |
|Day 19|Final polish + exam environment prep                |
|Day 20|**Exam day**                                        |
