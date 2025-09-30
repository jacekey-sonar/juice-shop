# GitHub Actions Quick Start Guide

## ⚡ 5-Minute Setup

### Step 1: Get Your SonarQube Token (2 min)

Go to https://sonarcloud.io (or your SonarQube instance):
1. Click **My Account** → **Security** tab
2. Generate token named "GitHub Actions"
3. **Copy the token** (you won't see it again!)

### Step 2: Add GitHub Secrets (1 min)

In your GitHub repository:
1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Click **New repository secret**
3. Add these two secrets:

```
Name: SONAR_TOKEN
Value: [paste your SonarQube token]

Name: SONAR_HOST_URL
Value: https://sonarcloud.io
```

### Step 3: Push the Workflows (1 min)

```bash
git add .github/ sonar-project.properties
git commit -m "ci: add GitHub Actions workflows with SonarQube integration"
git push
```

### Step 4: Verify (1 min)

1. Go to **Actions** tab in GitHub
2. You should see workflows running
3. Wait for them to complete ✅

---

## 🎯 What You Get

### ✅ CI/CD Pipeline
- **Runs on:** Every push and PR
- **Tests:** Unit, Integration, API tests
- **Platforms:** Ubuntu, macOS, Windows
- **Node versions:** 18, 20, 21, 22
- **Build:** TypeScript backend + Angular frontend
- **Coverage:** Automatic code coverage reporting

### ✅ SonarQube Analysis
- **Runs on:** Every push and PR
- **Checks:** Code quality, bugs, vulnerabilities
- **Coverage:** Integrated test coverage
- **Quality Gate:** Automatic pass/fail
- **PR Comments:** Issues shown directly in PRs

### ✅ CodeQL Security Scan
- **Runs on:** Push, PR, Weekly schedule
- **Detects:** 100+ security vulnerability patterns
- **Languages:** JavaScript, TypeScript
- **Alerts:** Automatic security advisories

---

## 🔍 Quick Commands

### Validate Setup
```bash
./.github/validate-workflows.sh
```

### Run Tests Locally
```bash
npm test           # Unit tests
npm run frisby     # API tests
npm run lint       # Linting
```

### Check Coverage
```bash
npm test
# Coverage reports in: build/reports/coverage/
```

---

## 📊 View Results

| Service | URL |
|---------|-----|
| GitHub Actions | `https://github.com/[owner]/[repo]/actions` |
| SonarQube | `https://sonarcloud.io/dashboard?id=jacekey-sonar_juice-shop` |
| Security Alerts | `https://github.com/[owner]/[repo]/security/code-scanning` |

---

## 🐛 Troubleshooting

### Workflows not running?
- Check `.github/workflows/` files exist
- Verify you pushed to `master` or `develop` branch
- Check Actions are enabled in Settings → Actions

### SonarQube failing?
- Verify secrets are set: `SONAR_TOKEN` and `SONAR_HOST_URL`
- Check token has permissions in SonarQube
- Verify project key: `jacekey-sonar_juice-shop`

### Tests failing?
- Run locally first: `npm test`
- Check Node.js version: `node --version` (should be 18-22)
- Clear cache: `rm -rf node_modules && npm install`

---

## 📚 Full Documentation

- **Complete Setup Guide:** [.github/WORKFLOWS_SETUP.md](.github/WORKFLOWS_SETUP.md)
- **Workflow Reference:** [.github/workflows/README.md](.github/workflows/README.md)
- **Validation Script:** Run `.github/validate-workflows.sh`

---

## 🎓 Learn More

- [GitHub Actions Docs](https://docs.github.com/en/actions)
- [SonarQube Docs](https://docs.sonarqube.org/)
- [CodeQL Docs](https://codeql.github.com/docs/)

---

**Questions?** Check [WORKFLOWS_SETUP.md](WORKFLOWS_SETUP.md) for detailed documentation.

**Need help?** Open an issue with workflow logs and error messages.
