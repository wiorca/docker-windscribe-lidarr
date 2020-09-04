
# Based on Ubuntu 20.04 LTS
FROM wiorca/docker-windscribe:latest

# Version
ARG VERSION=0.0.2

# Expose the webadmin port for Lidarr
EXPOSE 8686/tcp

# Create a volume for the bittorrent data and library
VOLUME [ "/data", "/music" ]

# Install mono
RUN apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF && \
    echo "deb https://download.mono-project.com/repo/ubuntu stable-focal main" | tee /etc/apt/sources.list.d/mono-official-stable.list && \
    apt -y update && apt install -y mono-devel mediainfo curl libchromaprint-tools && \
    apt -y autoremove && apt -y clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Add in scripts for health check and start-up
ADD app-health-check.sh /opt/scripts/app-health-check.sh
ADD app-startup.sh /opt/scripts/app-startup.sh
ADD app-setup.sh /opt/scripts/app-setup.sh

# Install Radarr
RUN curl -L $( curl -s https://api.github.com/repos/Lidarr/Lidarr/releases | grep linux.tar.gz | grep browser_download_url | head -1 | cut -d \" -f 4 ) \
    | tar xvz --directory /opt && chmod -R a+rx /opt/Lidarr

