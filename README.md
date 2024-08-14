# docker-jenkins-and-android-env

## Version

v1.0.0-jdk17

## Description

This project sets up a Docker environment for Jenkins and Android development. It includes configurations for Jenkins and the necessary tools for Android development.

## Features

* Jenkins setup in Docker
* Android SDK and tools installation
* Pre-configured environment for Android development

## Requirements

* Docker

## Installation

### Pull from GitHub Container Registry

You can pull the pre-built Docker image from the GitHub Container Registry:

```sh
docker pull ghcr.io/nickhuangcyh/docker-jenkins-and-android-env:v1.0.0-jdk17
```

### Run the Docker Container

After pulling the image, you can run the Docker container with the following command:

```sh
docker run -d -v ${volume path}:/var/jenkins_home -p 8080:8080 -p 50000:50000 ghcr.io/nickhuangcyh/docker-jenkins-and-android-env:v1.0.0-jdk17
```

### Build from Source

Alternatively, you can clone the repository and build the Docker image yourself:
1. Clone the repository:
    

```sh
git clone git@github.com:nickhuangcyh/docker_jenkins_android.git
cd docker-jenkins-and-android-env
```

2. Build the Docker image:
    

```sh
docker build -t docker-jenkins-and-android-env:v1.0.0-jdk17 .
```

3. Run the Docker container:
    

```sh
docker run -d -v ${volume path}:/var/jenkins_home -p 8080:8080 -p 50000:50000 docker-jenkins-and-android-env:v1.0.0-jdk17
```

## Usage

* Access Jenkins at `http://localhost:8080`
* Configure your Android development environment within the Docker container

## License

This project is licensed under the MIT License.
