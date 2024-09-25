#!/bin/bash

# Aktualizacja pakietów
sudo apt-get update

# Instalacja wymaganych pakietów
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common -y

# Dodanie klucza GPG Dockera
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# Dodanie repozytorium Dockera
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# Aktualizacja pakietów po dodaniu repozytorium Dockera
sudo apt-get update

# Instalacja Dockera
sudo apt-get install docker-ce -y

# Sprawdzenie statusu usługi Dockera
sudo systemctl status docker
