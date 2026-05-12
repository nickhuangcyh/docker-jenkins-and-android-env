FROM jenkins/jenkins:lts-jdk21

LABEL maintainer="NickHuang <nickhuang@climax.com.tw>"

# ANDROID_HOME ENV
ENV ANDROID_HOME=/opt/android-sdk-linux 

USER root

# Update and install necessary packages
RUN apt update && apt install -y zip unzip python3 vim

# Install jdk-21 (Adoptium Temurin)
RUN mkdir -p /usr/lib/jvm/java-21-openjdk-amd64 \
    && curl -fsSL https://api.adoptium.net/v3/binary/latest/21/ga/linux/x64/jdk/hotspot/normal/eclipse -o /tmp/temurin-21.tar.gz \
    && tar -xzf /tmp/temurin-21.tar.gz -C /usr/lib/jvm/java-21-openjdk-amd64 --strip-components=1 \
    && rm /tmp/temurin-21.tar.gz

# Install jdk-17 (Adoptium Temurin)
RUN mkdir -p /usr/lib/jvm/java-17-openjdk-amd64 \
    && curl -fsSL https://api.adoptium.net/v3/binary/latest/17/ga/linux/x64/jdk/hotspot/normal/eclipse -o /tmp/temurin-17.tar.gz \
    && tar -xzf /tmp/temurin-17.tar.gz -C /usr/lib/jvm/java-17-openjdk-amd64 --strip-components=1 \
    && rm /tmp/temurin-17.tar.gz

# Install jdk-11 (Adoptium Temurin)
RUN mkdir -p /usr/lib/jvm/java-11-openjdk-amd64 \
    && curl -fsSL https://api.adoptium.net/v3/binary/latest/11/ga/linux/x64/jdk/hotspot/normal/eclipse -o /tmp/temurin-11.tar.gz \
    && tar -xzf /tmp/temurin-11.tar.gz -C /usr/lib/jvm/java-11-openjdk-amd64 --strip-components=1 \
    && rm /tmp/temurin-11.tar.gz

# Create android sdk directory and change user:group permission
RUN mkdir -p ${ANDROID_HOME}
RUN chown -R jenkins:jenkins ${ANDROID_HOME}

# Download gdrive binary file into /usr/local/bin and change own/mod
# RUN curl https://raw.githubusercontent.com/nickhuangcyh/gdrive-binaries/main/linux/gdrive-linux-x64 --output /usr/local/bin/gdrive
# RUN chown jenkins:jenkins /usr/local/bin/gdrive
# RUN chmod a+x /usr/local/bin/gdrive

# Install rclone
RUN curl -fsSL -o /tmp/rclone.deb https://downloads.rclone.org/rclone-current-linux-amd64.deb \
    && dpkg -i /tmp/rclone.deb \
    && rm /tmp/rclone.deb

# Install Docker CLI and add jenkins to docker group (GID 999)
RUN apt-get update \
    && apt-get install -y ca-certificates curl gnupg \
    && install -m 0755 -d /etc/apt/keyrings \
    && curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc \
    && echo "deb [arch=amd64 signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/debian $(. /etc/os-release && echo $VERSION_CODENAME) stable" > /etc/apt/sources.list.d/docker.list \
    && apt-get update \
    && apt-get install -y docker-ce-cli \
    && rm -rf /var/lib/apt/lists/* \
    && groupadd -g 999 docker \
    && usermod -aG docker jenkins

USER jenkins

# Download sdkmanager
RUN cd ${ANDROID_HOME} \
    && curl -o commandlinetools.zip https://dl.google.com/android/repository/commandlinetools-linux-6200805_latest.zip \
    && unzip commandlinetools.zip \
    && rm commandlinetools.zip

# Download android sdk, ndk and tools
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --list
RUN yes | ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} --licenses 
RUN ${ANDROID_HOME}/tools/bin/sdkmanager --sdk_root=${ANDROID_HOME} "platform-tools" "platforms;android-28" "ndk;27.0.12077973"
ENV PATH=${PATH}:${ANDROID_HOME}/tools:${ANDROID_HOME}/tools/bin:${ANDROID_HOME}/platform-tools