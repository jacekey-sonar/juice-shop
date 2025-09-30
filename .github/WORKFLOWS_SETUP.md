# GitHub Actions & SonarQube Setup Guide

This guide will help you configure the CI/CD workflows for the Juice Shop project with SonarQube integration.

## 📋 Prerequisites

- GitHub repository with admin access
- SonarQube account (SonarCloud or self-hosted)
- Node.js 18+ installed locally

## 🚀 Quick Start

### Step 1: Configure GitHub Secrets

Navigate to your repository settings and add the following secrets:

**Settings → Secrets and variables → Actions → New repository secret**

#### Required Secrets:

| Secret Name | Description | Example |
|-------------|-------------|---------|
| `SONAR_TOKEN` | SonarQube authentication token | `sqp_1234567890abcdef...` |
| `SONAR_HOST_URL` | SonarQube server URL | `https://sonarcloud.io` |

#### Optional Secrets:

| Secret Name | Description | Required For |
|-------------|-------------|--------------|
| `CC_TEST_REPORTER_ID` | CodeClimate reporter ID | Coverage reporting |

### Step 2: Get SonarQube Token

#### For SonarCloud:
1. Go to https://sonarcloud.io
2. Click on your profile → **My Account** → **Security**
3. Generate a new token with name "GitHub Actions"
4. Copy the token (you won't see it again!)
5. Add it as `SONAR_TOKEN` secret in GitHub

#### For Self-hosted SonarQube:
1. Login to your SonarQube instance
2. Go to **Administration** → **Security** → **Users**
3. Click on your user → **Tokens**
4. Generate new token
5. Add it as `SONAR_TOKEN` secret in GitHub
6. Add your SonarQube URL as `SONAR_HOST_URL` secret

### Step 3: Verify SonarQube Project

The workflows are configured for project key: `jacekey-sonar_juice-shop`

To verify or update:
1. Check `sonar-project.properties` in the root directory
2. Update `sonar.projectKey` if needed
3. Update the same key in `.github/workflows/sonarqube.yml`

### Step 4: Enable Branch Protection (Recommended)

**Settings → Branches → Add rule**

For `master` and `develop` branches:

✅ **Require status checks to pass before merging**
- Lint Code
- Unit Tests (Node 20 - ubuntu-latest)
- API Tests (Node 20 - ubuntu-latest)
- Build Application
- SonarQube Code Analysis
- CodeQL Analysis

✅ **Require branches to be up to date before merging**

✅ **Require linear history** (optional)

### Step 5: Test the Workflows

1. Create a new branch:
   ```bash
   git checkout -b test/ci-setup
   ```

2. Make a small change (e.g., update README):
   ```bash
   echo "Testing CI/CD" >> README.md
   git add README.md
   git commit -m "test: verify CI/CD workflows"
   git push -u origin test/ci-setup
   ```

3. Create a pull request and verify all checks pass

4. Check the Actions tab for workflow runs

## 📊 Workflow Details

### CI/CD Pipeline (`ci.yml`)

**Purpose:** Build, test, and validate code quality

**Runs on:**
- Every push to `master` or `develop`
- Every pull request to `master` or `develop`

**What it does:**
1. ✅ Lints TypeScript/JavaScript code
2. ✅ Runs unit tests (frontend & backend)
3. ✅ Runs API integration tests
4. ✅ Builds the application
5. ✅ Runs Docker smoke tests
6. ✅ Generates coverage reports

**Artifacts:** Build files and coverage reports (retained 7 days)

---

### SonarQube Analysis (`sonarqube.yml`)

**Purpose:** Static code analysis for quality and security

**Runs on:**
- Every push to `master` or `develop`
- Every pull request

**What it analyzes:**
- 🔍 Code smells and maintainability issues
- 🐛 Bugs and potential errors
- 🛡️ Security vulnerabilities
- 📊 Code coverage
- 🔄 Code duplication

**Quality Gates:**
- Automatically checks if code meets quality standards
- Fails if critical issues are found
- Provides detailed feedback in PR comments

---

### CodeQL Security Scan (`codeql.yml`)

**Purpose:** Advanced security vulnerability detection

**Runs on:**
- Every push to `master` or `develop`
- Every pull request
- Weekly schedule (Mondays at 2:30 AM UTC)

**What it detects:**
- SQL injection vulnerabilities
- Cross-site scripting (XSS)
- Command injection
- Path traversal
- And 100+ other security patterns

---

## 🔧 Customization

### Modify SonarQube Analysis

Edit `sonar-project.properties`:

```properties
# Change coverage paths
sonar.javascript.lcov.reportPaths=custom-coverage.info

# Add more exclusions
sonar.exclusions=**/custom-path/**

# Change quality gate wait
sonar.qualitygate.wait=false
```

### Modify CI Workflow

Edit `.github/workflows/ci.yml`:

```yaml
# Change Node.js versions
matrix:
  node-version: [20, 22]  # Only test on LTS versions

# Change test timeout
timeout_minutes: 20  # Increase for slower environments

# Add environment variables
env:
  CUSTOM_VAR: value
```

### Skip Workflows on Specific Paths

Add to workflow's `on.push` section:

```yaml
on:
  push:
    paths-ignore:
      - 'docs/**'
      - '**.md'
```

## 🐛 Troubleshooting

### SonarQube Analysis Failing

**Issue:** "ERROR: Error during SonarQube Scanner execution"

**Solutions:**
1. Verify `SONAR_TOKEN` is set correctly
2. Check `SONAR_HOST_URL` matches your SonarQube instance
3. Ensure project key `jacekey-sonar_juice-shop` exists in SonarQube
4. Check SonarQube server is accessible from GitHub Actions

### Tests Failing in CI but Pass Locally

**Issue:** Tests pass on local machine but fail in GitHub Actions

**Solutions:**
1. Check Node.js version matches (use `nvm use 20`)
2. Clear `node_modules` and reinstall: `rm -rf node_modules && npm install`
3. Check for hardcoded file paths or environment variables
4. Review test logs in Actions tab for specific errors

### Coverage Reports Not Uploading

**Issue:** Coverage percentage shows 0% in SonarQube

**Solutions:**
1. Verify coverage files are generated: `ls -la build/reports/coverage/`
2. Check coverage file paths in `sonar-project.properties`
3. Ensure tests run successfully before SonarQube scan
4. Verify LCOV format is correct

### Workflow Not Triggering

**Issue:** Workflows don't run on push/PR

**Solutions:**
1. Check workflow files are in `.github/workflows/` directory
2. Verify YAML syntax is valid
3. Check branch names match trigger configuration
4. Ensure workflows are enabled in Settings → Actions

## 📈 Monitoring

### View Workflow Status

- **Actions Tab:** See all workflow runs and their status
- **Pull Requests:** See check status directly on PRs
- **Badges:** Add status badges to README (optional)

### SonarQube Dashboard

View detailed analysis at:
```
{SONAR_HOST_URL}/dashboard?id=jacekey-sonar_juice-shop
```

### Security Alerts

CodeQL results appear in:
- **Security Tab → Code scanning alerts**
- Pull request checks
- Email notifications (if enabled)

## 🎯 Best Practices

1. **Always** run tests locally before pushing
2. **Review** SonarQube feedback in PRs
3. **Address** critical security issues immediately
4. **Keep** dependencies up to date
5. **Monitor** workflow run times and optimize if needed
6. **Document** any custom configurations
7. **Update** action versions regularly

## 📚 Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [SonarQube Documentation](https://docs.sonarqube.org/)
- [CodeQL Documentation](https://codeql.github.com/docs/)
- [Juice Shop Project](https://owasp-juice.shop)

## 🆘 Getting Help

If you encounter issues:
1. Check workflow logs in Actions tab
2. Review this documentation
3. Search existing issues in the repository
4. Create a new issue with workflow logs and error messages

---

**Last Updated:** September 30, 2025
**Maintained By:** DevOps Team
