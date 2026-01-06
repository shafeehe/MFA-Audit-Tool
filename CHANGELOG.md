# # Changelog

All notable changes to the MFAAudit project will be documented in this file.

This project follows an iterative development approach — features are added gradually with focus on learning, security awareness, and practical DevOps tooling.

---

## v1.1.0 — GuardRail & Module Improvements (2026-01-05)

### Added
- Implemented **GuardRail AWS Account Confirmation** before running audits
- Added account alias / account ID display for safety awareness
- Improved function structure for Get-MFAReport
- Added support for cleaner output formatting
- Introduced safer development workflow:
  - Understanding module reload vs autoload
  - Reloading module during development
  - Working with project vs installed module copy

### Project / DevOps Improvements
- Adopted Git discipline:
  - Commit ? Pull (rebase) ? Push workflow
  - Conflict resolution experience
  - README recovery & repo consistency
- Established GitHub-hosted development workflow

---

## v1.0.0 — Initial Release (Foundation Build)

### Added
- Created **MFAAudit PowerShell Module**
- Implemented Get-MFAReport function:
  - Lists IAM users
  - Detects MFA enabled / disabled
- Enabled pipeline-friendly output (works with Export-Csv, Format-Table)
- Structured project into **Public / Module** layout
- First working end-to-end AWS IAM automation script

### Learning Outcomes
- Gained experience with:
  - PowerShell automation
  - AWS IAM inspection
  - IAM user + MFA fundamentals
  - Tool-building instead of ad-hoc scripting

