# Use official Node.js 18 image
FROM node:18

LABEL maintainer="Iamcodio"
LABEL description="Claude Code Dev Environment with Git, Ripgrep, and MCP-ready setup"

RUN apt-get update && apt-get install -y \
    git \
    ripgrep \
    curl \
    vim \
 && rm -rf /var/lib/apt/lists/*

WORKDIR /app

RUN npm install -g @anthropic-ai/claude-code

COPY . .

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

CMD ["/entrypoint.sh"]