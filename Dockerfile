
# Based on wiorca/docker-windscribe-mono
FROM wiorca/docker-windscribe:latest

# Version
ARG VERSION=0.0.5

# Expose the webadmin port for Lidarr
EXPOSE 8686/tcp

# Create a volume for the bittorrent data and library
VOLUME [ "/data", "/music" ]

# Update and install dependencies
RUN apt update && \
    apt install -y apt-transport-https wget && \
    wget https://packages.microsoft.com/config/ubuntu/20.10/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && \
    dpkg -i packages-microsoft-prod.deb && \
    rm packages-microsoft-prod.deb && \
    apt update && \
    apt install -y aspnetcore-runtime-5.0 && \
    apt -y update && \
    apt install -y mediainfo dotnet-runtime-5.0 libchromaprint-tools && \
    apt -y autopurge && apt -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add in scripts for health check and start-up
ADD app-health-check.sh /opt/scripts/app-health-check.sh
ADD app-startup.sh /opt/scripts/app-startup.sh
ADD app-setup.sh /opt/scripts/app-setup.sh

# Install Radarr
RUN curl -L $( curl -s https://api.github.com/repos/Lidarr/Lidarr/releases | grep linux-core-x64.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) \
    | tar xvz --directory /opt && chmod -R a+rx /opt/Lidarr

