#!/bin/bash

# Aktualizacja pakietów
sudo apt-get update

# Instalacja wymaganych pakietów
sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common \
    mc -y

# Pobranie skryptu instalacyjnego Dockera
curl -fsSL https://get.docker.com -o get-docker.sh

# Uruchomienie skryptu instalacyjnego Dockera
sh get-docker.sh

# Sprawdzenie statusu usługi Dockera
sudo systemctl status docker

# Informacja o pozytywnym zakończeniu
echo "Docker został pomyślnie zainstalowany!"
