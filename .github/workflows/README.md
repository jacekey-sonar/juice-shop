# GitHub Actions Workflows

This directory contains the CI/CD workflows for the Juice Shop project.

## Workflows Overview

### 🔄 CI/CD Pipeline (`ci.yml`)

**Triggers:**
- Push to `master` or `develop` branches
- Pull requests to `master` or `develop` branches

**Jobs:**
1. **Lint**: Code quality checks with ESLint
2. **Unit Tests**: Frontend and backend unit tests across multiple Node.js versions (18, 20, 21, 22) and OS (Ubuntu, macOS)
3. **API Tests**: Integration tests across multiple platforms (Ubuntu, macOS, Windows)
4. **Build**: Compile TypeScript backend and build Angular frontend
5. **Docker Test**: Smoke tests using Docker
6. **Coverage Report**: Aggregate and publish coverage to CodeClimate

**Features:**
- Matrix testing across Node.js versions and operating systems
- Dependency caching for faster builds
- Coverage report generation
- Build artifact retention (7 days)
- Retry logic for flaky tests

---

### 🔍 SonarQube Analysis (`sonarqube.yml`)

**Triggers:**
- Push to `master` or `develop` branches
- Pull requests (opened, synchronized, reopened)

**Jobs:**
1. **SonarQube Scan**: Static code analysis for code quality and security
2. **Quality Gate Check**: Validates code meets quality standards
3. **Results Display**: Provides link to detailed SonarQube dashboard

**Required Secrets:**
- `SONAR_TOKEN`: Authentication token for SonarQube
- `SONAR_HOST_URL`: SonarQube server URL

**Features:**
- Deep code analysis for bugs, vulnerabilities, and code smells
- Coverage integration with test results
- Quality gate enforcement
- Pull request decoration

---

### 🛡️ CodeQL Security Scan (`codeql.yml`)

**Triggers:**
- Push to `master` or `develop` branches
- Pull requests to `master` or `develop` branches
- Scheduled scan every Monday at 2:30 AM UTC

**Features:**
- Security vulnerability detection
- JavaScript/TypeScript analysis
- Security-extended query suite
- Automated security alerts

---

## Setup Instructions

### 1. SonarQube Configuration

Add these secrets to your GitHub repository:
- Go to **Settings** → **Secrets and variables** → **Actions**
- Add the following secrets:
  - `SONAR_TOKEN`: Your SonarQube authentication token
  - `SONAR_HOST_URL`: Your SonarQube server URL (e.g., `https://sonarcloud.io`)

### 2. CodeClimate (Optional)

For coverage reporting to CodeClimate:
- Add secret: `CC_TEST_REPORTER_ID`

### 3. Branch Protection

Recommended branch protection rules for `master` and `develop`:
- Require status checks to pass:
  - Lint Code
  - Unit Tests
  - API Tests
  - Build Application
  - SonarQube Code Analysis
  - CodeQL Analysis
- Require branches to be up to date before merging

## Workflow Best Practices

### Concurrency Control
All workflows use concurrency groups to prevent duplicate runs and save CI minutes.

### Security
- Workflows use minimal required permissions
- Actions are pinned to specific commit SHAs for security
- Secrets are properly scoped and never exposed in logs

### Performance
- npm cache enabled for faster dependency installation
- Parallel job execution where possible
- Artifact retention limited to 7 days

### Reliability
- Retry logic on flaky tests (3 attempts)
- Continue-on-error for non-critical steps
- Matrix testing across environments

## Monitoring and Debugging

### View Workflow Runs
- Navigate to **Actions** tab in GitHub
- Click on specific workflow for detailed logs

### Common Issues

**SonarQube scan failing:**
- Verify `SONAR_TOKEN` and `SONAR_HOST_URL` secrets are set
- Check SonarQube project key matches configuration

**Coverage not uploading:**
- Ensure tests generate coverage reports in expected locations
- Check `build/reports/coverage/` directory structure

**Tests timing out:**
- Review timeout settings in workflow
- Check for hanging processes in tests

## Local Testing

To test workflows locally, you can use [act](https://github.com/nektos/act):

```bash
# Install act
brew install act  # macOS
# or
curl https://raw.githubusercontent.com/nektos/act/master/install.sh | sudo bash

# Run specific workflow
act -j lint
act -j test-unit
act -j build
```

## Maintenance

### Updating Actions
All actions are pinned to commit SHAs. To update:
1. Check for new versions at the action's repository
2. Update the version comment (e.g., `#v4.2.2`)
3. Update the commit SHA
4. Test thoroughly before merging

### Adding New Jobs
When adding new jobs:
1. Use descriptive names
2. Set appropriate permissions
3. Add to branch protection rules
4. Document in this README
