#!/bin/sh
# yum install android-tools -y
yum install java-1.8.0-openjdk-devel
mkdir -p android-sdk-linux
cd android-sdk-linux
# @see https://developer.android.com/studio/index.html
wget --output-document=android-sdk.zip --quiet https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip
unzip android-sdk.zip
rm -f android-sdk.zip
yes | tools/bin/sdkmanager --licenses
tools/bin/sdkmanager "tools" "platform-tools" "extras;google;m2repository"
