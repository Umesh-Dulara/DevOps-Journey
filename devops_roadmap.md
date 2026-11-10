# 🚀 DevOps Journey — Fresh Start Roadmap

> **Profile**: Linux basics + Git → Target: DevOps/Cloud Engineer + Freelance/Open-source  
> **Daily commitment**: 3+ hours  
> **Focus areas**: Linux & Shell Scripting → CI/CD → Monitoring & Observability

---

> [!IMPORTANT]
> Each phase builds on the previous one. **Don't skip ahead.** Mastering the fundamentals makes everything downstream easier.

---

## 🗺️ Overview at a Glance

| Phase | Topic | Duration | Outcome |
|-------|-------|----------|---------|
| **1** | Linux Power User + Shell Scripting | ~3 weeks | Write real automation scripts |
| **2** | Docker & Containers | ~2 weeks | Containerize any application |
| **3** | CI/CD Pipelines | ~3 weeks | Build automated pipelines from scratch |
| **4** | Monitoring & Observability | ~2 weeks | Set up dashboards & alerting |
| **5** | Cloud Fundamentals (AWS) | ~3 weeks | Deploy real infra on cloud |
| **6** | Capstone Projects | ~2 weeks | Portfolio-ready projects |

**Total estimated time**: ~3–4 months at 3+ hrs/day

---

## 📦 Phase 1 — Linux Power User + Shell Scripting
**Duration**: ~3 weeks | **Daily**: 3 hrs

### Week 1 — Linux Internals
- [ ] File system hierarchy (`/etc`, `/var`, `/proc`, `/sys`)
- [ ] File permissions deep dive (`chmod`, `chown`, `umask`, SUID/SGID)
- [ ] Process management (`ps`, `top`, `htop`, `kill`, `nice`, `systemctl`)
- [ ] User & group management
- [ ] Package management (`apt`, `rpm`, `snap`)
- [ ] Networking basics (`ip`, `ss`, `netstat`, `curl`, `wget`, `ping`, `traceroute`)

**Mini-project**: Write a script that monitors disk usage and sends an alert log when > 80%.

### Week 2 — Shell Scripting Fundamentals
- [ ] Variables, arrays, and arithmetic
- [ ] Conditionals (`if/elif/else`, `case`)
- [ ] Loops (`for`, `while`, `until`)
- [ ] Functions and return values
- [ ] Reading user input
- [ ] String manipulation (`sed`, `awk`, `grep`, `cut`, `tr`)
- [ ] File I/O and redirection (`>`, `>>`, `<`, `2>&1`, pipes)
- [ ] Exit codes and error handling (`set -e`, `trap`)

**Mini-project**: Write a log rotation script that archives logs older than 7 days.

### Week 3 — Advanced Shell + Automation
- [ ] Cron jobs and scheduling
- [ ] `find`, `xargs`, and batch file operations
- [ ] SSH key management + `scp`, `rsync`
- [ ] Environment variables and `.bashrc`/`.bash_profile`
- [ ] Writing robust scripts: linting with `shellcheck`
- [ ] Intro to `jq` for JSON processing in scripts

**Mini-project**: Write a system health check script that reports CPU, memory, disk, and running services — save output to a timestamped log file.

---

## 📦 Phase 2 — Docker & Containers
**Duration**: ~2 weeks | **Daily**: 3 hrs

### Week 4 — Docker Core
- [ ] What containers are and why they exist (vs VMs)
- [ ] Installing Docker, Docker CLI basics
- [ ] Pulling, running, stopping, removing containers
- [ ] Images vs containers
- [ ] `Dockerfile` — writing your own images
- [ ] Layers, caching, and build optimization
- [ ] Volumes and bind mounts
- [ ] Networking in Docker (bridge, host, none)
- [ ] `docker-compose` for multi-container apps

**Mini-project**: Dockerize a simple Node.js or Python web app with a database using `docker-compose`.

### Week 5 — Docker in Practice
- [ ] Docker Hub and private registries
- [ ] Multi-stage builds
- [ ] Tagging and versioning images
- [ ] Health checks in containers
- [ ] Best practices: non-root users, `.dockerignore`, minimal base images

**Mini-project**: Build a production-ready Docker image for a sample app and push it to Docker Hub.

---

## 📦 Phase 3 — CI/CD Pipelines
**Duration**: ~3 weeks | **Daily**: 3 hrs

### Week 6 — Git Deep Dive + GitHub Actions Basics
- [ ] Git workflows: GitFlow, trunk-based development
- [ ] Git internals: commits, trees, blobs, refs
- [ ] Rebasing, cherry-picking, bisect
- [ ] GitHub Actions: triggers, jobs, steps, runners
- [ ] Writing your first `.github/workflows/` pipeline
- [ ] Environment variables and secrets in Actions
- [ ] Matrix builds (test on multiple OS/versions)

**Mini-project**: Create a CI pipeline that runs linting and tests on every pull request.

### Week 7 — CI/CD Patterns
- [ ] Continuous Delivery vs Continuous Deployment
- [ ] Build → Test → Lint → Deploy pipeline
- [ ] Caching dependencies in pipelines
- [ ] Artifacts and releases
- [ ] Branch protection rules and required checks
- [ ] Intro to self-hosted runners

**Mini-project**: Build a full CI/CD pipeline that auto-deploys a Docker app to a VM on every `main` push.

### Week 8 — Jenkins (Industry Standard)
- [ ] Jenkins architecture: master/agent
- [ ] Declarative `Jenkinsfile` syntax
- [ ] Plugins ecosystem
- [ ] Pipeline stages: Build, Test, Push, Deploy
- [ ] Credentials management in Jenkins
- [ ] Comparing Jenkins vs GitHub Actions

**Mini-project**: Replicate your GitHub Actions pipeline in Jenkins (run Jenkins locally via Docker).

---

## 📦 Phase 4 — Monitoring & Observability
**Duration**: ~2 weeks | **Daily**: 3 hrs

### Week 9 — Prometheus + Grafana Stack
- [ ] The three pillars of observability: Metrics, Logs, Traces
- [ ] Prometheus architecture: scrapers, exporters, TSDB
- [ ] Install and configure Prometheus
- [ ] Node Exporter for system metrics
- [ ] PromQL basics: queries, functions, aggregations
- [ ] Setting up alerting rules
- [ ] Installing and configuring Grafana
- [ ] Connecting Grafana to Prometheus data source
- [ ] Building dashboards

**Mini-project**: Monitor your local machine with Prometheus + Grafana. Build a dashboard tracking CPU, memory, disk, and network.

### Week 10 — Logging + Alerting in Production
- [ ] Log aggregation with Loki
- [ ] Promtail log shipping agent
- [ ] Structured logging concepts
- [ ] AlertManager: routing, grouping, and silencing
- [ ] Alerting to Slack/email/PagerDuty
- [ ] Intro to OpenTelemetry concepts

**Mini-project**: Set up a full observability stack (Prometheus + Grafana + Loki) for your Dockerized app. Configure alerts for downtime.

---

## 📦 Phase 5 — Cloud Fundamentals (AWS)
**Duration**: ~3 weeks | **Daily**: 3 hrs

### Week 11 — AWS Core Services
- [ ] IAM: users, roles, policies, least privilege
- [ ] EC2: launch instances, security groups, key pairs
- [ ] S3: buckets, storage classes, lifecycle rules
- [ ] VPC: subnets, route tables, internet gateways, NACLs
- [ ] RDS: managed databases
- [ ] CloudWatch: logs, metrics, alarms

**Mini-project**: Deploy your Dockerized app manually to an EC2 instance with a proper VPC setup.

### Week 12 — Infrastructure as Code (Terraform)
- [ ] Terraform fundamentals: providers, resources, state
- [ ] Variables, outputs, modules
- [ ] `terraform plan`, `apply`, `destroy`
- [ ] Remote state with S3 backend
- [ ] Managing EC2, VPC, and S3 with Terraform

**Mini-project**: Write Terraform code to provision the infrastructure from Week 11 — fully reproducible.

### Week 13 — Putting It Together
- [ ] CI/CD pipeline that deploys to AWS EC2 via GitHub Actions
- [ ] Using AWS ECR for Docker images
- [ ] AWS cost management basics
- [ ] Load balancing with ALB
- [ ] Auto-scaling groups

**Mini-project**: Full pipeline — code push → CI tests → Docker build → push to ECR → deploy to EC2 via Terraform.

---

## 📦 Phase 6 — Capstone Projects (Portfolio)
**Duration**: ~2 weeks | **Daily**: 3 hrs

### Project A: Open-Source Contribution
- Find a DevOps tool on GitHub (e.g., ansible, prometheus, k9s)
- Fix a `good-first-issue` or improve documentation/CI pipeline
- Submit a pull request

### Project B: Freelance-Ready Portfolio Project
**Build a complete deployment platform for a web app:**
- App: Any simple web service (Node/Python/Go)
- Containerized with Docker + docker-compose
- CI/CD with GitHub Actions (lint → test → build → push to Docker Hub)
- Deployed to AWS EC2 (provisioned with Terraform)
- Monitored with Prometheus + Grafana + Loki
- Alerts configured for uptime and resource usage
- README with architecture diagram

---

## 📅 Daily Schedule (3+ hrs)

| Block | Duration | Activity |
|-------|----------|----------|
| 🌅 Morning | 1.5 hrs | Learn + read docs / watch tutorials |
| 🌆 Evening | 1.5+ hrs | Hands-on practice + mini-projects |

> [!TIP]
> Keep a **daily log** (even just bullet points). Writing down what you learned forces you to process it, and it becomes your personal documentation.

---

## 🔧 Tools to Set Up Right Now

- [ ] **Linux VM or WSL2** — your sandbox environment
- [ ] **VS Code** with extensions: Remote SSH, Docker, YAML, Shell Check
- [ ] **GitHub account** — all projects go here
- [ ] **Docker Desktop** or `docker` + `docker-compose` on Linux
- [ ] **AWS Free Tier account** — needed for Phase 5

---

## 📚 Recommended Resources

| Topic | Resource |
|-------|----------|
| Linux & Shell | [Linux Journey](https://linuxjourney.com/), `man` pages, `tldr` |
| Shell Scripting | [shellscript.sh](https://www.shellscript.sh/), `shellcheck` tool |
| Docker | [Docker Official Docs](https://docs.docker.com/), TechWorld with Nana (YouTube) |
| GitHub Actions | [GitHub Actions Docs](https://docs.github.com/en/actions) |
| Jenkins | [Jenkins.io](https://www.jenkins.io/doc/) |
| Prometheus + Grafana | [Prometheus Docs](https://prometheus.io/docs/), Grafana tutorials |
| Terraform | [HashiCorp Learn](https://learn.hashicorp.com/terraform) |
| AWS | [AWS Skill Builder](https://skillbuilder.aws/) (free courses) |

---

> [!NOTE]
> This roadmap is **living document**. As you complete phases, we can adjust depth, add Kubernetes, or pivot based on what job roles require.

