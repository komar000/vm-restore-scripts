#!/bin/bash

# Ustawienia
VERSION=1.22.1 # Wybierz najnowszą wersję z https://golang.org/dl/

# Wykrywanie architektury
ARCH=$(uname -m)
if [ "$ARCH" == "x86_64" ]; then
    ARCH="amd64"
elif [ "$ARCH" == "aarch64" ]; then
    ARCH="arm64"
elif [[ "$ARCH" == "arm"* ]]; then
    ARCH="arm64"
else
    echo "Nieobsługiwana architektura: $ARCH"
    exit 1
fi

# Instalacja Go
echo "Pobieranie Go $VERSION dla architektury $ARCH"
wget https://dl.google.com/go/go$VERSION.linux-$ARCH.tar.gz
echo "Pobieranie Go $VERSION zakończone"

# Ekstrakcja archiwum
echo "Ekstrakcja..."
tar -C ~/.local/share -xzf go$VERSION.linux-$ARCH.tar.gz
echo "Ekstrakcja zakończona"

# Ustawienie zmiennych środowiskowych
SHELL_TYPE=$(basename "$SHELL")

if [ "$SHELL_TYPE" = "zsh" ]; then
    echo "Znaleziono powłokę ZSH"
    SHELL_RC="$HOME/.zshrc"
elif [ "$SHELL_TYPE" = "bash" ]; then
    echo "Znaleziono powłokę Bash"
    SHELL_RC="$HOME/.bashrc"
elif [ "$SHELL_TYPE" = "fish" ]; then
    echo "Znaleziono powłokę Fish"
    SHELL_RC="$HOME/.config/fish/config.fish"
else
    echo "Nieobsługiwana powłoka: $SHELL_TYPE"
    exit 1
fi

echo 'export GOPATH=$HOME/go' >> "$SHELL_RC"
echo 'export PATH=$PATH:$GOPATH/bin' >> "$SHELL_RC"

# Weryfikacja instalacji Go
if [ -x "$(command -v go)" ]; then
    INSTALLED_VERSION=$(go version | awk '{print $3}')
    if [ "$INSTALLED_VERSION" == "go$VERSION" ]; then
        echo "Go $VERSION został pomyślnie zainstalowany."
    else
        echo "Zainstalowana wersja Go ($INSTALLED_VERSION) nie zgadza się z oczekiwaną wersją (go$VERSION)."
        exit 1
    fi
else
    echo "Go nie został znaleziony w PATH. Upewnij się, że dodano katalog bin Go do PATH."
    exit 1
fi

# Czyszczenie - usuwanie pliku tar.gz
rm go$VERSION.linux-$ARCH.tar.gz

# Klonowanie repozytorium docker-backup
echo "Klonowanie repozytorium docker-backup..."
git clone https://github.com/muesli/docker-backup.git $HOME/docker-backup

# Budowanie projektu docker-backup
cd $HOME/docker-backup || exit
go build

# Ustawienie zmiennych środowiskowych dla docker-backup
echo 'export DOCKER_BACKUP_HOME=$HOME/docker-backup' >> "$SHELL_RC"
echo 'export PATH=$PATH:$DOCKER_BACKUP_HOME' >> "$SHELL_RC"

# Załaduj zmiany w bieżącej sesji
source "$SHELL_RC"

echo "Instalacja zakończona. Możesz teraz używać docker-backup."