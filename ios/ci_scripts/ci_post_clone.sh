#!/bin/sh

set -e

cd $CI_PRIMARY_REPOSITORY_PATH

# Install Flutter
git clone https://github.com/flutter/flutter.git --depth 1 -b stable $HOME/flutter
export PATH="$PATH:$HOME/flutter/bin"

flutter precache --ios

# Clean flutter
flutter clean

# Dependencies
flutter pub get

# CocoaPods
HOMEBREW_NO_AUTO_UPDATE=1
brew install cocoapods

cd ios

# CLEAN PODS
rm -rf Pods
rm -rf .symlinks
rm -rf Flutter/Flutter.framework
rm -rf Flutter/Flutter.podspec
rm -f Podfile.lock

# Reinstall pods
pod repo update
pod install

exit 0