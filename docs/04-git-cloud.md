# 4. Git delivery and cloud computing

Git records snapshots as commits. The working tree holds edits, the staging area selects the next snapshot, and a branch names a line of commits. `git status`, `git diff`, `git add`, `git commit` make that boundary visible. A remote is another repository; `fetch` gets its objects, `pull` fetches and integrates, and `push` publishes local commits. A pull request adds review and automated checks before merge. Conflicts require understanding both changes; never accept one side blindly for infrastructure.

Prefer short-lived branches and reviewed changes on a shared main branch. Tags identify releases. Semantic versions communicate compatibility promises for published software. GitFlow is another branching model, but extra long-lived branches add merge overhead. Infrastructure changes deserve review because a small CIDR, route or IAM change can affect many systems.

Traditional data centers require procuring and operating hardware. Virtualization allows several isolated virtual machines on one host. Cloud APIs rent managed compute, storage and networking on demand. A region is a geographic grouping; availability zones are separate infrastructure locations within a region. Multi-AZ design reduces some failures, but applications must still handle retries, data consistency and recovery. Elasticity changes capacity with demand; high availability is continued service during a failure; fault tolerance is a stronger property. IaaS gives more machine control, PaaS abstracts more operations, SaaS delivers an application. A managed database removes some maintenance but not schema design or access control.

The shared responsibility model divides duties by service: AWS protects underlying infrastructure; customers still own identities, data, configuration and workloads. Check the service-specific boundary.

## Knowledge check

Why inspect `git diff --staged` before a commit? What does an AZ failure mean for an application in one AZ? Which database responsibilities remain with you on RDS?

Further reading: [Git book](https://git-scm.com/book/en/v2), [AWS shared responsibility](https://aws.amazon.com/compliance/shared-responsibility-model/).
