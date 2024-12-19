# Docker-Alpine-Audit

This repository provides automated scripts and configuration files to set up audit logging in Docker containers. It supports both **Debian** and **Alpine** Linux distributions, ensuring that audit trails are maintained for security monitoring.

## Overview

- **audit.rules**: The configuration files to define the auditing rules for monitoring system calls and events.
- **Debian & Alpine Scripts**: Automated bash scripts for configuring the audit framework on **Debian-based** and **Alpine-based** containers, respectively.

These scripts are designed to be used within Docker containers running on either Debian or Alpine Linux, helping you maintain security auditing in a containerized environment.

## Contents

- `audit.rules`: Configuration file for setting up audit rules.
- `debian/setup_audit.sh`: Script to set up auditd on a Debian-based container.
- `alpine/setup_audit.sh`: Script to set up auditd on an Alpine-based container.

## Getting Started

### Prerequisites

- Docker should be installed and running on your system.
- Basic knowledge of Docker and how to manage containers.
- The container should be based on either Debian or Alpine Linux.

### Usage

1. **Clone the repository** to your local machine:

   ```bash
   git clone https://github.com/nizarski/Docker-Audit-automation.git
   cd Docker-Audit-automation
