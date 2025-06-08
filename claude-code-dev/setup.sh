#!/bin/bash

# Claude Code Development Environment Setup Script
# Handles existing container cleanup and environment setup

set -e

CONTAINER_NAME="claude-code-dev"
COMPOSE_FILE="docker-compose.yml"

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Claude Code Development Environment Setup${NC}"
echo ""

# Function to check if container exists
check_container_exists() {
    if docker ps -a --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        return 0
    else
        return 1
    fi
}

# Function to check if container is running
check_container_running() {
    if docker ps --format "table {{.Names}}" | grep -q "^${CONTAINER_NAME}$"; then
        return 0
    else
        return 1
    fi
}

# Function to stop and remove container
cleanup_container() {
    echo -e "${YELLOW}🧹 Cleaning up existing container: ${CONTAINER_NAME}${NC}"
    
    if check_container_running; then
        echo -e "${YELLOW}⏹️  Stopping running container...${NC}"
        docker stop ${CONTAINER_NAME}
    fi
    
    echo -e "${YELLOW}🗑️  Removing container...${NC}"
    docker rm ${CONTAINER_NAME}
    
    echo -e "${GREEN}✅ Container cleanup completed${NC}"
}

# Check for existing container
if check_container_exists; then
    echo -e "${YELLOW}⚠️  Container '${CONTAINER_NAME}' already exists${NC}"
    
    if check_container_running; then
        echo -e "${YELLOW}🔄 Container is currently running${NC}"
    else
        echo -e "${YELLOW}⏸️  Container exists but is stopped${NC}"
    fi
    
    echo ""
    echo "Options:"
    echo "1) Stop and remove existing container, then build new one"
    echo "2) Skip setup (container already exists)"
    echo "3) Exit without changes"
    echo ""
    
    while true; do
        read -p "Choose option (1-3): " choice
        case $choice in
            1)
                cleanup_container
                break
                ;;
            2)
                echo -e "${GREEN}✅ Using existing container${NC}"
                if ! check_container_running; then
                    echo -e "${BLUE}🔄 Starting existing container...${NC}"
                    docker-compose up -d
                fi
                echo -e "${GREEN}🎉 Container is ready!${NC}"
                echo ""
                echo "To access the container:"
                echo "  docker exec -it ${CONTAINER_NAME} bash"
                exit 0
                ;;
            3)
                echo -e "${RED}❌ Setup cancelled${NC}"
                exit 0
                ;;
            *)
                echo -e "${RED}Invalid option. Please choose 1, 2, or 3.${NC}"
                ;;
        esac
    done
fi

# Check if Docker is running
if ! docker info >/dev/null 2>&1; then
    echo -e "${RED}❌ Docker is not running. Please start Docker Desktop and try again.${NC}"
    exit 1
fi

# Check if docker-compose.yml exists
if [ ! -f "$COMPOSE_FILE" ]; then
    echo -e "${RED}❌ ${COMPOSE_FILE} not found in current directory${NC}"
    exit 1
fi

# Build and start the container
echo -e "${BLUE}🔨 Building and starting Claude Code environment...${NC}"
docker-compose up -d --build

# Verify container is running
if check_container_running; then
    echo -e "${GREEN}✅ Container built and started successfully!${NC}"
    echo ""
    echo -e "${GREEN}🎉 Claude Code Development Environment Ready!${NC}"
    echo ""
    echo "Next steps:"
    echo "1. Access the container:"
    echo "   docker exec -it ${CONTAINER_NAME} bash"
    echo ""
    echo "2. Set your API key inside the container:"
    echo "   export ANTHROPIC_API_KEY='your-key'"
    echo ""
    echo "3. Start Claude Code:"
    echo "   claude"
    echo ""
    echo "To stop the environment:"
    echo "   docker-compose down"
else
    echo -e "${RED}❌ Failed to start container. Check Docker logs for details.${NC}"
    exit 1
fi