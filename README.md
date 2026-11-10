# Active Directory Security Auditing with PowerShell

## Project Overview

Built an Active Directory security auditing solution using Windows Server 2022 and PowerShell in a virtualized Proxmox home lab.

The project demonstrates Windows Server administration, identity and access management (IAM), PowerShell automation, and security reporting.

## Lab Environment

- **Hypervisor:** Proxmox VE
- **Operating System:** Windows Server 2022
- **Domain:** wrighttech.test
- **Domain Controller:** DC01
- **Networking:** Isolated virtual network (10.10.10.0/24)
- **Technologies:** Active Directory Domain Services, PowerShell, Remote Desktop, SSH

## Active Directory Configuration

Configured a domain environment with:

- Six organizational units for departments, workstations, and security groups
- Five fictional employee accounts
- Department-based security groups
- Role-based access organization following least-privilege principles

## Security Audit Features

The PowerShell script performs three security checks:

1. **Password Expiration Audit:** Identifies accounts configured with passwords that never expire.
2. **Inactive Account Audit:** Identifies enabled accounts with a recorded last logon older than 90 days.
3. **Privileged Account Audit:** Identifies direct members of the Domain Admins security group.

## Automated Reporting

The script exports findings to a CSV report containing account names, usernames, and finding categories.

### Sample Findings

| Account | Finding |
|---|---|
| Administrator | Password Never Expires |
| Guest | Password Never Expires |
| Administrator | Domain Admin Member |

These findings were generated in a controlled lab environment and do not represent a production security assessment.

## Security Considerations

- The lab network is isolated from the home LAN.
- Departmental security groups support role-based access organization.
- Privileged accounts are audited to support least-privilege reviews.
- The inactive-account check excludes accounts that have never logged in.
- The privileged-account check identifies direct Domain Admins members, not all nested or indirectly privileged accounts.
- Audit findings require context before being classified as vulnerabilities.

## Skills Demonstrated

- Active Directory Domain Services administration
- Windows Server 2022 configuration
- Organizational unit and security group management
- Identity and access management
- PowerShell scripting and automation
- Security auditing and CSV reporting
- Virtual networking and remote administration

## Future Improvements

- Identify accounts that have never logged in
- Add account lockout and disabled-account reporting
- Audit nested privileged group membership
- Implement scheduled audits
- Add logging and error handling