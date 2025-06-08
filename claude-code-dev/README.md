# Claude Code Development Environment Scaffold

A production-ready Docker-based development environment for Claude Code, designed to be a reusable scaffold for all future projects.

## Features

- **Containerized Environment**: Consistent development experience across all platforms
- **Pre-installed Tools**: Git, Ripgrep, Vim, and Claude Code CLI
- **ARM/x86 Compatible**: Works on Apple Silicon and Intel machines
- **Volume Mounting**: Real-time file synchronization between host and container
- **Claude Code Integration**: AI-powered coding assistance built-in
- **Branch-First Development**: Prevents AI death loops and protects API credits by isolating features

## Prerequisites

- Docker Desktop (latest version)
- Docker Compose
- Git
- GitHub account
- Anthropic API key

## Quick Start - Complete Setup Guide

### Step 1: GitHub OAuth App Setup

#### Create GitHub OAuth App
1. Go to https://github.com/settings/apps/new
2. Fill in the application details:
   - **Application name**: `your-username-claude-oauth-app` (e.g., `iamcodio-claude-oauth-app`)
   - **Homepage URL**: `http://localhost:3000` (or your preferred URL)
   - **Authorization callback URL**: `http://localhost:3000/callback`
3. Click "Create GitHub App"
4. Note down the following values:
   - **App ID**
   - **Client ID**
   - **Client Secret** (generate if not shown)
5. Generate and download the **Private Key** (.pem file)
6. Create a **Personal Access Token** at https://github.com/settings/tokens
   - Select scopes: `repo`, `user`, `workflow`

#### Create Environment Configuration
Create a `.env` file in your project root:
```bash
# Environment Variables for Local Development
# IMPORTANT: Never commit this file to git!

# GitHub Configuration
GITHUB_USERNAME=your_github_username
GITHUB_EMAIL=your_email@example.com
GITHUB_TOKEN=your_personal_access_token_here
GITHUB_APP_ID=your_app_id_here
GITHUB_CLIENT_ID=your_client_id_here
GITHUB_CLIENT_SECRET=your_client_secret_here
GITHUB_APP_NAME=your-app-name
GITHUB_PRIVATE_KEY_PATH=./github-private-key.pem

# Claude Code API Key
ANTHROPIC_API_KEY=your_anthropic_api_key_here
```

**Important**: 
- Place your downloaded `.pem` file in the project directory as `github-private-key.pem`
- Never commit `.env` or `.pem` files to git (they're in `.gitignore`)

### Step 2: Clone from GitHub
```bash
# Create your project folder and clone the scaffold
mkdir ~/my-projects
cd ~/my-projects
git clone https://github.com/<your-username>/<scaffold-repo>.git my-new-project
cd my-new-project
```

### Step 2: Start Docker Environment

#### Option A: Automated Setup (Recommended)
```bash
# Use the setup script to handle existing containers automatically
./setup.sh

# The script will:
# - Check for existing containers with the same name
# - Offer to stop/remove them if found
# - Build and start the new environment
# - Verify everything is working
```

#### Option B: Manual Setup
```bash
# Ensure Docker Desktop is running first!
# If you have existing containers, remove them first:
docker stop claude-code-dev 2>/dev/null || true
docker rm claude-code-dev 2>/dev/null || true

# Build and start the container in background
docker-compose up -d --build

# Verify container is running
docker ps
# You should see 'claude-code-dev' container running
```

### Step 3: Access the Development Container
```bash
# The container starts automatically with a welcome message
# Access the container's bash shell (if needed)
docker exec -it claude-code-dev bash

# You're now inside the container at /app directory
# Verify Claude Code is installed
claude --version
```

### Step 4: Configure Claude Code (First Time Only)
```bash
# Inside the container, set up your API key
export ANTHROPIC_API_KEY="your-api-key-here"

# Or better, create a .env file (never commit this!)
echo "ANTHROPIC_API_KEY=your-api-key-here" > .env
```

### Step 5: Start Using Claude Code
```bash
# Get help and see available commands
claude --help

# Start an interactive session
claude

# Or run a specific command
claude "analyze this codebase and suggest improvements"
```

### Step 6: Important - Create Feature Branch
```bash
# ALWAYS create a feature branch before making changes
git checkout -b feature/my-first-feature

# Now you can safely work without risking API credit loops
```

## Project Structure

```
.
├── CLAUDE.md          # Claude Code instructions and project preferences
├── Dockerfile         # Container configuration
├── docker-compose.yml # Service orchestration
└── README.md         # This file
```

## Using as a Scaffold

### For New Projects

1. **Copy this repository as a template**
   ```bash
   git clone <this-repo> my-new-project
   cd my-new-project
   rm -rf .git
   git init
   ```

2. **Update project metadata**
   - Edit `Dockerfile` LABEL maintainer
   - Update project-specific instructions in `CLAUDE.md`
   - Modify `docker-compose.yml` service names if needed

3. **Add your project files**
   - Place your code in the project directory
   - Update `.gitignore` as needed
   - Add project-specific dependencies

### Customization Points

#### Dockerfile Customization
- Add language-specific runtimes (Python, Ruby, etc.)
- Install additional development tools
- Configure environment variables

#### CLAUDE.md Customization
- Add project-specific coding standards
- Define AI assistance preferences
- Include domain-specific instructions

## Security Best Practices

### Pre-commit Checklist
- [ ] No API keys in code
- [ ] No passwords or credentials
- [ ] No sensitive URLs or endpoints
- [ ] No personal information
- [ ] Environment variables used for secrets
- [ ] `.gitignore` includes all sensitive files

### Security Tools
Run security checks before committing:
```bash
# Check for common secret patterns
grep -r -E "(api_key|apikey|secret|password|token)" . --exclude-dir=.git

# List all environment variables (ensure no secrets)
docker exec claude-code-dev env | grep -v PATH
```

## Development Workflow

### 1. Start Development
```bash
docker-compose up -d
docker exec -it claude-code-dev bash
```

### 2. Branch-First Strategy (CRITICAL)
```bash
# ALWAYS work in feature branches to prevent API credit waste
git checkout -b feature/your-feature-name

# If Claude gets stuck in a loop, simply:
git checkout main  # Return to stable code
git branch -D feature/your-feature-name  # Delete problematic branch
```

**Why This Prevents Death Loops:**
- Each feature is isolated in its own branch
- Easy rollback when AI cycles on the same problem
- Preserves working code in main branch
- Saves significant API credits
- Enables quick recovery from stuck states

### 3. Use Claude Code
```bash
# Get help
claude --help

# Start interactive session
claude

# Run specific command
claude "explain this code"
```

### 4. Version Control
```bash
# Inside container
git add .
git commit -m "Your message"
git push origin main
```

### 5. Stop Development
```bash
docker-compose down
```

## Troubleshooting

### Container won't start
```bash
docker-compose down -v
docker-compose up -d --build
```

### Permission issues
```bash
# Fix file permissions
docker exec claude-code-dev chown -R node:node /app
```

### Claude Code not working
```bash
# Check if API key is set
echo $ANTHROPIC_API_KEY

# If not set, configure it
export ANTHROPIC_API_KEY="your-api-key-here"

# Reinstall Claude Code if needed
docker exec claude-code-dev npm install -g @anthropic-ai/claude-code
```

## Contributing

1. Fork the repository
2. Create your feature branch
3. Run security checks
4. Commit your changes
5. Push to the branch
6. Create a Pull Request

## License

This scaffold is provided as-is for use in your own projects.

## Support

For Claude Code issues: https://github.com/anthropics/claude-code/issues
For scaffold issues: Create an issue in this repository