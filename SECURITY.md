# Security Policy

Language: English | [한국어](./docs/i18n/ko/SECURITY.md) | [Español](./docs/i18n/es/SECURITY.md) | [Français](./docs/i18n/fr/SECURITY.md) | [हिन्दी](./docs/i18n/hi/SECURITY.md) | [简体中文](./docs/i18n/zh-CN/SECURITY.md)

This is the default security policy for repositories owned by 0disoft. If a repository has its own `SECURITY.md`, the repository-specific policy takes precedence.

## Supported Repositories

Security reports are reviewed for repositories that are actively maintained.

Archived, experimental, deprecated, or unmaintained repositories may not receive security fixes.

Unless a repository states otherwise, security work is handled on a best-effort basis for the default branch and the latest public release, if releases are used.

## Security Requirements for Contributions

Changes that introduce or modify authentication, authorization, cryptography, secret handling, payment handling, personal data processing, or network-exposed behavior require additional maintainer review.

## Cryptography Policy

For any change that introduces, modifies, or depends on cryptographic behavior:

- Do not implement custom cryptography or compose cryptographic primitives directly without explicit maintainer approval and appropriate security review.
- Prefer established protocols, well-maintained libraries, and standards-track implementations.
- Symmetric cryptography and hash functions remain allowed. Use modern authenticated encryption, message authentication, and hash primitives through maintained libraries.
- Cryptographic choices should be configurable and replaceable where practical. Avoid hard-coding algorithms when protocol negotiation or library configuration is available.

### Public-Key Cryptography and PQC

- For new public-key encryption, key establishment, or digital signature functionality, prefer NIST-standardized post-quantum cryptography where production-ready support exists.
- Prefer ML-KEM for new key establishment and ML-DSA or SLH-DSA for new digital signatures when they fit the protocol and runtime environment.
- Track additional NIST-standardized or standards-track algorithms, including FN-DSA and HQC, as they mature.
- Hybrid classical and post-quantum configurations are allowed when required for interoperability, provided they follow a recognized protocol, profile, or vendor-supported standard.
- Existing RSA, Diffie-Hellman, ECDH, ECDSA, or EdDSA usage may remain when required for compatibility, but new long-lived secrets, long-lived trust roots, and new cryptographic protocol designs should be post-quantum ready where practical.
- Do not use non-standard, experimental, or research-only post-quantum schemes in production code without explicit maintainer approval and security review.

The goal is not to ban all existing cryptography immediately. The goal is to avoid adding unnecessary quantum-vulnerable public-key dependencies and to keep cryptographic components replaceable.

## Password Storage Policy

If a project stores user passwords:

- Do not store passwords in plaintext or with reversible encryption.
- Do not hash passwords directly with fast general-purpose hash functions such as MD5, SHA-1, SHA-256, or SHA-512.
- Prefer Argon2id for new password hashing.
- Use unique, randomly generated salts for each password. For Argon2id password hashing, a 16-byte salt is recommended.
- Use maintained libraries and standard password hash formats where practical.
- Argon2id parameters should be configurable and reviewed as hardware and deployment constraints change.
- As a baseline, use at least the OWASP-recommended minimum Argon2id settings unless a repository-specific policy defines stricter parameters: 19 MiB memory, 2 iterations, and 1 degree of parallelism.
- If Argon2id is not available, use scrypt when possible. For legacy systems, bcrypt may remain temporarily with an appropriate work factor and a migration plan. If FIPS-140 compliance is required, use PBKDF2-HMAC-SHA-256 with an approved work factor.
- Do not use fast hashes, unsalted hashes, or custom password hashing schemes.
- Store the algorithm, parameters, salt, and hash version with each password hash so hashes can be upgraded over time.

## Tokens, API Keys, and Secrets Policy

For machine-generated tokens, API keys, recovery codes, and similar secrets:

- Generate secrets with a cryptographically secure random number generator.
- Do not store raw API keys, access tokens, refresh tokens, session tokens, or recovery codes unless there is a clear operational need.
- Prefer storing a keyed hash, hash, or non-reversible verifier when plaintext recovery is not required.
- Secrets must not be committed to the repository, included in logs, exposed in error messages, or stored in test fixtures.
- Use a secrets manager, environment-specific secret storage, or the platform's encrypted secret facility for operational secrets.

## Dependency and Supply Chain Security

- Keep dependencies reasonably up to date.
- Security-relevant dependency changes should be reviewed before release.
- Do not add dependencies for cryptography, authentication, authorization, serialization, template rendering, or network parsing without maintainer review.

## Reporting a Vulnerability

Please do not report security vulnerabilities through public issues, pull requests, or discussions.

Report privately through GitHub:

1. Open the affected repository, select the **Security** tab, and choose **Report a vulnerability**. Private vulnerability reporting is enabled on maintained 0disoft repositories.
2. If that option is not available, open an issue that only asks for a private contact channel. Do not include technical details, exploit steps, or affected versions in that issue.
3. If you cannot identify the affected repository, or the repository does not accept private reports, use the same **Security** tab flow on `0disoft/.github`. It is the default policy repository and the fallback contact point for the account.

When reporting a vulnerability, include:

- the affected repository
- the affected version, branch, or commit, if known
- a clear description of the issue
- steps to reproduce the issue
- potential impact
- any suggested mitigation, if available

## Handling

Reports will be reviewed in good faith.

The maintainer may ask for additional details, prepare a fix, coordinate disclosure, or determine that the reported issue is not a security vulnerability.

Please avoid publicly disclosing the issue until a fix or mitigation has been prepared, unless the maintainer is unresponsive for an unreasonable period of time.
