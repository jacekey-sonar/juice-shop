#!/bin/bash
# Workflow Validation Script
# This script validates that all required workflows and configurations are in place

set -e

echo "🔍 Validating GitHub Actions Workflows Setup..."
echo ""

# Colors for output
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

ERRORS=0
WARNINGS=0

# Function to check if file exists
check_file() {
    if [ -f "$1" ]; then
        echo -e "${GREEN}✅${NC} Found: $1"
    else
        echo -e "${RED}❌${NC} Missing: $1"
        ((ERRORS++))
    fi
}

# Function to check if secret is mentioned in documentation
check_secret_docs() {
    if grep -q "$1" .github/WORKFLOWS_SETUP.md; then
        echo -e "${GREEN}✅${NC} Secret documented: $1"
    else
        echo -e "${YELLOW}⚠️${NC}  Secret not documented: $1"
        ((WARNINGS++))
    fi
}

echo "📁 Checking workflow files..."
check_file ".github/workflows/ci.yml"
check_file ".github/workflows/sonarqube.yml"
check_file ".github/workflows/codeql.yml"

echo ""
echo "📄 Checking configuration files..."
check_file "sonar-project.properties"
check_file "package.json"
check_file "tsconfig.json"

echo ""
echo "📚 Checking documentation..."
check_file ".github/workflows/README.md"
check_file ".github/WORKFLOWS_SETUP.md"

echo ""
echo "🔐 Checking required secrets documentation..."
check_secret_docs "SONAR_TOKEN"
check_secret_docs "SONAR_HOST_URL"

echo ""
echo "🔎 Validating YAML syntax..."
if command -v node &> /dev/null; then
    node -e "
        const fs = require('fs');
        const yaml = require('js-yaml');
        const files = ['ci.yml', 'sonarqube.yml', 'codeql.yml'];
        let errors = 0;
        files.forEach(f => {
            try {
                yaml.load(fs.readFileSync('.github/workflows/' + f, 'utf8'));
                console.log('${GREEN}✅${NC} Valid YAML:', f);
            } catch(e) {
                console.error('${RED}❌${NC} Invalid YAML:', f, '-', e.message);
                errors++;
            }
        });
        if (errors > 0) process.exit(1);
    " 2>&1 || ((ERRORS++))
else
    echo -e "${YELLOW}⚠️${NC}  Node.js not found, skipping YAML validation"
    ((WARNINGS++))
fi

echo ""
echo "🔍 Checking SonarQube configuration..."
if grep -q "jacekey-sonar_juice-shop" sonar-project.properties && \
   grep -q "jacekey-sonar_juice-shop" .github/workflows/sonarqube.yml; then
    echo -e "${GREEN}✅${NC} SonarQube project key is consistent"
else
    echo -e "${RED}❌${NC} SonarQube project key mismatch between files"
    ((ERRORS++))
fi

echo ""
echo "📊 Checking test coverage configuration..."
if grep -q "lcov.info" sonar-project.properties; then
    echo -e "${GREEN}✅${NC} Coverage reporting configured"
else
    echo -e "${YELLOW}⚠️${NC}  Coverage reporting may not be configured"
    ((WARNINGS++))
fi

echo ""
echo "🎯 Checking Node.js version consistency..."
NODE_VERSION=$(grep -o "NODE_DEFAULT_VERSION: [0-9]*" .github/workflows/ci.yml | head -1 | awk '{print $2}')
if [ ! -z "$NODE_VERSION" ]; then
    echo -e "${GREEN}✅${NC} Default Node.js version: $NODE_VERSION"
    if grep -q "\"node\": \"18 - 22\"" package.json; then
        echo -e "${GREEN}✅${NC} Node.js version range matches package.json"
    else
        echo -e "${YELLOW}⚠️${NC}  Check Node.js version compatibility"
        ((WARNINGS++))
    fi
else
    echo -e "${RED}❌${NC} Could not determine Node.js version"
    ((ERRORS++))
fi

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}🎉 All checks passed! Workflows are properly configured.${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Add SONAR_TOKEN and SONAR_HOST_URL secrets to GitHub"
    echo "2. Push workflows to GitHub: git add .github/ sonar-project.properties"
    echo "3. Create a test PR to verify everything works"
    echo "4. Enable branch protection rules"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  Validation completed with $WARNINGS warning(s).${NC}"
    echo "   Review warnings above, but setup should work."
    exit 0
else
    echo -e "${RED}❌ Validation failed with $ERRORS error(s) and $WARNINGS warning(s).${NC}"
    echo "   Please fix the errors above before proceeding."
    exit 1
fi
