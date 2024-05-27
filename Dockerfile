# Use an official Ubuntu base image
FROM ubuntu:20.04

# Install packages and dependencies for steamcmd
RUN apt-get update && apt-get install -y \
    software-properties-common \
    sudo \
    nano \
    expect \
    lib32gcc-s1 \
    lib32stdc++6 \
    lib32z1 \
    curl \
    xdg-user-dirs \
    && rm -rf /var/lib/apt/lists/*

# SteamCMD Dependencies
RUN sudo add-apt-repository multiverse; sudo dpkg --add-architecture i386; sudo apt update

# Add Steam user and group and Sudo it for SteamCMD
RUN adduser --disabled-password --gecos "" steam \
    && usermod -aG sudo steam && \
    adduser steam sudo && \
    echo 'steam ALL=(ALL) NOPASSWD: ALL' >> /etc/sudoers

# Create the .steam Directory
RUN mkdir -p /home/steam/.steam/sdk64/

# Change to the Steam User
RUN cd /home/steam/.steam

# Install SteamCMD
RUN echo steamcmd steam/question select "I AGREE" | sudo debconf-set-selections && \
    echo steamcmd steam/license note '' | sudo debconf-set-selections && \
    sudo apt-get install -y steamcmd

# Add SteamCMD to the PATH
ENV PATH=$PATH:/usr/games

# Give Ownership of the Steam Account Directory to the Steam User
RUN chown -R steam:steam /home/steam/

# Switch to the Steam User
USER steam