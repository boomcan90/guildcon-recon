# Multi-stage build for optimized security tools environment
FROM ubuntu:22.04 AS base

# Avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install system dependencies and base tools
RUN apt-get update && apt-get install -y \
    curl \
    wget \
    git \
    build-essential \
    ca-certificates \
    gnupg \
    lsb-release \
    libssl-dev \
    libffi-dev \
    && rm -rf /var/lib/apt/lists/*

# Install uv (fast Python package installer and resolver) system-wide
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.local/bin/uv /usr/local/bin/uv && \
    chmod +x /usr/local/bin/uv

# Install latest Python using uv (no arguments installs latest stable version)
ENV PATH="/root/.local/bin:$PATH"
RUN uv python install

# Make Python accessible system-wide via symlinks
# uv installs Python to ~/.local/bin, find it and create symlinks
RUN export PATH="/root/.local/bin:$PATH" && \
    PYTHON_EXE=$(which python3 2>/dev/null) && \
    if [ -n "$PYTHON_EXE" ] && [ -f "$PYTHON_EXE" ]; then \
        ln -sf "$PYTHON_EXE" /usr/local/bin/python3 && \
        ln -sf /usr/local/bin/python3 /usr/local/bin/python; \
    fi

# Install Go (latest stable version)
ENV GO_VERSION=1.21.5
RUN wget -O go.tar.gz https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz && \
    tar -C /usr/local -xzf go.tar.gz && \
    rm go.tar.gz

ENV PATH=$PATH:/usr/local/go/bin
ENV GOPATH=/root/go
ENV PATH=$PATH:$GOPATH/bin

# Install Go-based security tools to a system-wide location
RUN mkdir -p /opt/go-tools && \
    export GOPATH=/opt/go-tools && \
    export PATH=$PATH:/opt/go-tools/bin && \
    go install github.com/OJ/gobuster/v3@latest && \
    go install github.com/projectdiscovery/httpx/cmd/httpx@latest && \
    go install github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest && \
    chmod -R 755 /opt/go-tools

# Install dirb (directory brute-forcer)
RUN apt-get update && apt-get install -y dirb && \
    rm -rf /var/lib/apt/lists/*

# Install sqlmap
RUN git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap && \
    ln -s /opt/sqlmap/sqlmap.py /usr/local/bin/sqlmap && \
    chmod +x /opt/sqlmap/sqlmap.py && \
    chmod -R 755 /opt/sqlmap

# Install SecLists (wordlists)
RUN git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/seclists && \
    chmod -R 755 /usr/share/seclists

# Install additional Python security tools and dependencies using uv
RUN uv pip install --system \
    requests \
    urllib3 \
    beautifulsoup4 \
    lxml

# Set working directory
WORKDIR /workspace

# Create a non-root user for security
RUN useradd -m -s /bin/bash security && \
    chown -R security:security /workspace /opt/go-tools

# Switch to non-root user
USER security

# Add tools to PATH for the user
ENV PATH=$PATH:/usr/local/go/bin:/opt/go-tools/bin:/opt/sqlmap:/root/.local/bin

# Default command
CMD ["/bin/bash"]

