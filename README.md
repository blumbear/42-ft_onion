# 42-ft_onion

A project that deploys a website accessible via the Tor network in a secure Docker environment with SSH access.

## 📋 Description

This project creates a web service accessible via the Tor network (.onion address) using:
- **Nginx** as web server
- **Tor** to create a hidden service (.onion)
- **Secure SSH** for remote administration
- **Docker** for isolation and reproducibility

## 🏗️ Architecture

```
┌─────────────────┐    ┌──────────────────┐    ┌─────────────────┐
│     User        │    │   Container      │    │   Tor Network   │
│                 │    │                  │    │                 │
│  SSH (port 4242)├────┤  SSH Server      │    │                 │
│  Web (port 8080)├────┤  Nginx (port 80) ├────┤  .onion Service │
│                 │    │  Tor             │    │                 │
└─────────────────┘    └──────────────────┘    └─────────────────┘
```

## 🚀 Installation and Deployment

### 1. Prerequisites

- Docker and Docker Compose installed
- Git to clone the project

```bash
git clone <repository>
cd 42-ft_onion
```

### 2. SSH Configuration (Required)

#### Generate SSH key on your machine

```bash
# Generate SSH key pair
ssh-keygen -t rsa -b 4096 -f ~/.ssh/ft_onion_key

# Or use your existing key
ls ~/.ssh/id_rsa.pub
```

#### Copy public key to container

```bash
# Start the container
docker-compose up -d

# Copy your public key (replace with your key)
ssh-copy-id -i ~/.ssh/id_rsa.pub -p 4242 sshuser@localhost
# Default password: password123

# Or manually:
ssh -p 4242 sshuser@localhost
mkdir -p ~/.ssh
echo "YOUR_PUBLIC_KEY" >> ~/.ssh/authorized_keys
chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
exit
```

### 3. Start the service

```bash
# Build and run
docker-compose up -d --build

# View logs
docker-compose logs -f
```

### 4. Get the .onion address

```bash
# Display generated .onion address
docker exec ft_onion_site cat /var/lib/tor/hidden_service/hostname
```

## 🔐 Service Access

### SSH Access

```bash
# Connect via SSH (key authentication)
ssh -i ~/.ssh/id_rsa -p 4242 sshuser@localhost

# SSH tunnel to access website
ssh -L 9090:localhost:80 -p 4242 sshuser@localhost
# Then open http://localhost:9090
```

### Web Access

- **Local:** http://localhost:8080
- **Via SSH Tunnel:** http://localhost:9090 (after SSH tunnel)
- **Via Tor:** Use .onion address with Tor browser

## 📂 Project Structure

```
42-ft_onion/
├── docker-compose.yml      # Docker Compose configuration
├── Dockerfile             # Custom Docker image
├── nginx.conf            # Secure Nginx configuration
├── torrc                 # Tor configuration
├── sshd_config          # Hardened SSH configuration
├── index.html           # Web page
├── start.sh            # Startup script
└── README.md          # This file
```

## 🔧 Configuration

### Secure SSH

The `sshd_config` file applies the following security measures:
- Root access disabled
- Custom port (4242)
- Key-only authentication (after setup)
- Connection attempt limits
- X11 forwarding disabled
- Detailed logging

### Tor

The Tor service automatically creates:
- A unique .onion address
- A hidden service accessible from Tor network
- Traffic redirection to Nginx (port 80)

### Nginx

Secure configuration with:
- Security headers
- HTTP method limitations
- No server information disclosure

## 📊 Useful Commands

```bash
# View real-time logs
docker-compose logs -f

# Enter container
docker exec -it ft_onion_site bash

# Restart service
docker-compose restart

# Stop completely
docker-compose down

# Clean up (warning: deletes data)
docker-compose down -v --rmi all

# Check .onion address
docker exec ft_onion_site cat /var/lib/tor/hidden_service/hostname

# Test SSH
ssh -v -p 4242 sshuser@localhost
```

## 🛡️ Security

### Implemented Measures

1. **Secure Container**
   - Non-root user
   - Limited capabilities
   - Restricted filesystem

2. **Hardened SSH**
   - Non-standard port
   - Key authentication
   - Limited attempts
   - Detailed logs

3. **Secure Nginx**
   - Security headers
   - Request limitations
   - No information disclosure

4. **Tor**
   - Anonymous hidden service
   - End-to-end encryption

### Recommendations

- Change default password (`password123`)
- Use SSH key authentication only in production
- Monitor logs regularly
- Update Docker images periodically

## 🚨 Troubleshooting

### SSH "Permission denied"
```bash
# Check if key is installed
ssh -v -p 4242 sshuser@localhost

# Reinstall key
ssh-copy-id -i ~/.ssh/id_rsa.pub -p 4242 sshuser@localhost
```

### Tor not generating .onion address
```bash
# Check Tor logs
docker exec ft_onion_site tail -f /var/log/tor/tor.log

# Restart Tor
docker exec ft_onion_site service tor restart
```

### Website inaccessible
```bash
# Check Nginx
docker exec ft_onion_site nginx -t
docker exec ft_onion_site service nginx status
```

## 📚 Resources

- [Tor Documentation](https://www.torproject.org/docs/)
- [SSH Hardening Guide](https://www.ssh.com/academy/ssh/sshd_config)
- [Nginx Security](https://nginx.org/en/docs/http/securing_nginx.html)
- [Docker Security](https://docs.docker.com/engine/security/)

## ⚠️ Warning

This project is intended for educational purposes. Use of the Tor network must comply with local laws and appropriate terms of use.

---

**Author:** blumbear  
**Project:** 42 School - ft_onion