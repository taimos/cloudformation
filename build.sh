#!/usr/bin/env bash

cd ecr-clean
./build.sh
cd ..

cd rolling-update-notifier
./build.sh
cd ..

cd mongodb
./build.sh
cd ..

cd logs-sumologic
./build.sh
cd ..

cd vpn-server
./build.sh
cd ..

cd support-access
./build.sh
cd ..
