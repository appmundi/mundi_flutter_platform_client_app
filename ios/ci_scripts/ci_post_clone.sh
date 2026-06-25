#!/bin/sh

# Falha imediatamente em caso de erro
set -e

# Define o locale para evitar problemas de encoding com o CocoaPods
export LANG=en_US.UTF-8

cd $CI_PRIMARY_REPOSITORY_PATH

# Instala o Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b 3.41.9 $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

# Faz o pré-cache dos artefatos do iOS
flutter precache --ios

# Baixa as dependências do Flutter
flutter pub get

# Instala o CocoaPods usando o Homebrew
HOMEBREW_NO_AUTO_UPDATE=1 brew install cocoapods

# Entra na pasta ios e instala os Pods nativos
cd ios
rm -f Podfile.lock
pod install --repo-update

exit 0