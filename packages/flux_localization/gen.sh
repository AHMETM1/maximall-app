#!/bin/bash
set -e

flutter pub get
flutter pub global run intl_utils:generate

echo "Build Data Done !!!"