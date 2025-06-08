# CURRENT SESSION STATUS - CODIO MCP SETUP
**SESSION STATE**: Ready to commit and push MCP updates to claude-code-dev

**COMPLETED**:
✅ Added MCP servers: Context7, Upstash, GitHub to local config
✅ Updated .env with Upstash/GitHub credentials (kept in root only)  
✅ Modified claude-code-dev/setup.sh with core MCP install instructions (context7 + github)

**NEXT STEPS**:
1. Fix bash environment (currently broken)
2. Commit current changes with proper message
3. Copy/push updates to claude-code-dev repo
4. Test MCP setup in fresh environment

**MCP ARSENAL READY**: Context7 (docs), GitHub (repos), + Upstash (optional)
**Additional MCPs researched**: Brave Search, Sequential Thinking, Supabase

**USER NOTE**: "WE ARE CODIO" - Ready for coding marathon mode

---

# Claude Project Setup & Scaffold SOPs

@/home/node/.claude/my-project-instructions.md

## Project Scaffold Standard Operating Procedures

### Initial Setup for New Projects

1. **Environment Preparation**
   ```bash
   # Clone scaffold
   git clone <scaffold-repo> <new-project-name>
   cd <new-project-name>
   
   # Reset git history
   rm -rf .git
   git init
   git add .
   git commit -m "Initial commit from Claude Code scaffold"
   ```

2. **CRITICAL: Branch-First Development Strategy**
   ```bash
   # After initial commit, ALWAYS create feature branches
   git checkout -b feature/setup-base
   # Make base configuration changes
   git add . && git commit -m "Configure base setup"
   
   # For each new feature or task
   git checkout main
   git checkout -b feature/<specific-task>
   ```
   
   **Why This Matters:**
   - Prevents death loops that burn API credits
   - Easy rollback when Claude gets stuck in cycles
   - Clean separation of concerns
   - Protects working code from experimental changes
   - Enables parallel feature development

2. **Project Configuration**
   - Update `Dockerfile` maintainer label
   - Modify project name in `docker-compose.yml`
   - Add project-specific dependencies
   - Configure environment variables

3. **Security First Setup**
   - Create `.env` file for secrets (never commit)
   - Update `.gitignore` with project-specific patterns
   - Run security audit before first commit

### Development Workflow SOPs

#### Starting a New Feature
1. Pull latest changes
2. Create feature branch
3. Start Docker environment
4. Use Claude Code for implementation
5. Run tests and security checks
6. Commit with meaningful messages

#### Code Quality Standards
- Use Claude Code for code review
- Follow existing code style
- Maintain comprehensive documentation
- Write tests for new features
- Run linters before committing

#### Security Protocols
1. **Pre-commit Security Check**
   ```bash
   # Automated secret scanning
   grep -r -E "(api_key|apikey|secret|password|token|credential)" . \
     --exclude-dir=.git \
     --exclude-dir=node_modules \
     --exclude=README.md \
     --exclude=CLAUDE.md
   ```

2. **Environment Variable Audit**
   - Never hardcode secrets
   - Use `.env` files locally
   - Document required env vars in README
   - Use secret management in production

### Claude Code Best Practices

#### Efficient Tool Usage
- Use parallel tool calls for independent operations
- Batch file reads when analyzing code
- Prefer editing over creating new files
- Use TodoWrite for complex multi-step tasks

#### Project-Specific Instructions
- Document domain knowledge here
- Add coding conventions
- Specify preferred libraries/frameworks
- Include architectural decisions

### Maintenance SOPs

#### Regular Updates
1. Update base Docker image monthly
2. Upgrade Claude Code CLI regularly
3. Review and update security patterns
4. Refresh documentation

#### Troubleshooting Guide
1. **Container Issues**
   - Check Docker daemon status
   - Verify port availability
   - Review container logs

2. **Claude Code Issues**
   - Verify API credentials
   - Check network connectivity
   - Update to latest version

3. **Git Issues**
   - Configure safe directories
   - Set proper user identity
   - Handle line ending differences

### Scaffold Evolution

#### Adding New Features
1. Test in isolated environment
2. Document in README
3. Update this file with new SOPs
4. Version tag before major changes

#### Removing Features
1. Check dependencies
2. Update documentation
3. Provide migration guide
4. Maintain backwards compatibility

## Important Reminders

- Do only what's asked; nothing more, nothing less
- Never create files unless absolutely necessary
- Always prefer editing existing files
- Never create documentation proactively
- Run security checks before every commit
- Keep commits atomic and meaningful
- Use descriptive branch names
- Maintain clean git history
