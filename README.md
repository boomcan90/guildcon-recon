# GuildCon Bug Bounty Workshop Tools

A Docker container with a comprehensive set of security testing and reconnaissance tools pre-installed and ready to use. This container is specifically prepared for the Bug Bounty workshop at GuildCon.

## Quick Start

```bash
docker run -it ghcr.io/boomcan90/guildcon-recon:latest
```


## Included Tools

### Programming Languages & Package Managers

#### **Go**
- **Description**: Go programming language for building and running Go-based security tools
- **Website**: https://go.dev/
- **Installation Command**: `wget https://go.dev/dl/go1.21.5.linux-amd64.tar.gz && tar -C /usr/local -xzf go1.21.5.linux-amd64.tar.gz && rm go1.21.5.linux-amd64.tar.gz && export PATH=$PATH:/usr/local/go/bin`

#### **Python** (via uv)
- **Description**: Latest Python version managed by uv (fast Python package installer)
- **Website**: https://www.python.org/
- **uv**: https://github.com/astral-sh/uv
- **Installation Command**: `curl -LsSf https://astral.sh/uv/install.sh | sh && uv python install`

### Reconnaissance & Discovery Tools

#### **Subfinder**
- **Description**: Subdomain discovery tool that discovers valid subdomains for websites
- **GitHub**: https://github.com/projectdiscovery/subfinder
- **Installation Command**: `go install -v github.com/projectdiscovery/subfinder/v2/cmd/subfinder@latest`

#### **httpx**
- **Description**: Fast and multi-purpose HTTP toolkit that allows running multiple probes
- **GitHub**: https://github.com/projectdiscovery/httpx
- **Installation Command**: `go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest`

### Web Application Security Tools

#### **Gobuster**
- **Description**: Directory/file brute-forcer written in Go
- **GitHub**: https://github.com/OJ/gobuster
- **Installation Command**: `go install github.com/OJ/gobuster/v3@latest`

#### **Dirb**
- **Description**: Web Content Scanner - directory brute-forcer
- **Website**: https://dirb.sourceforge.net/
- **Installation Command**: `apt-get update && apt-get install -y dirb`

#### **SQLMap**
- **Description**: Automatic SQL injection and database takeover tool
- **GitHub**: https://github.com/sqlmapproject/sqlmap
- **Website**: http://sqlmap.org/
- **Installation Command**: `git clone --depth 1 https://github.com/sqlmapproject/sqlmap.git /opt/sqlmap && ln -s /opt/sqlmap/sqlmap.py /usr/local/bin/sqlmap && chmod +x /opt/sqlmap/sqlmap.py`

### Wordlists & Resources

#### **SecLists**
- **Description**: Collection of multiple types of lists used during security assessments
- **GitHub**: https://github.com/danielmiessler/SecLists
- **Installation Command**: `git clone --depth 1 https://github.com/danielmiessler/SecLists.git /usr/share/seclists`
- **Location**: `/usr/share/seclists`

### Optional Tools (Not Pre-installed)

#### **ffuf**
- **Description**: Fast web fuzzer written in Go
- **GitHub**: https://github.com/ffuf/ffuf
- **Installation Command**: `go install github.com/ffuf/ffuf@latest`

## Notes

- The container runs as a non-root user (`security`) for security best practices
- All tools are pre-installed and available in the PATH
- Working directory is set to `/workspace` - mount your local directory here for easy access
- Python packages can be installed using `uv pip install <package>`
- Go tools can be installed using `go install <package>@latest`

## Useful Links

- [ProjectDiscovery Tools](https://projectdiscovery.io/)
- [Go Documentation](https://go.dev/doc/)
- [Python Documentation](https://docs.python.org/)
- [uv Documentation](https://github.com/astral-sh/uv)
- [SecLists Repository](https://github.com/danielmiessler/SecLists)


## Thanks
- @sledge
- @xchaos