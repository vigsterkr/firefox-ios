#!/usr/bin/env bash

set -eu

FRAMEWORK_LOCATION="${PWD}/Carthage/Build/iOS/MozillaAppServices.framework"

if [ -z "${APP_SERVICES_DIR-}" ]; then
  # Local dev disabled but symbolic link is still there :(
  if [ -h "${FRAMEWORK_LOCATION}" ]; then
    echo "Application Services was substituted but is not anymore."
    rm -rf "${FRAMEWORK_LOCATION}"
    echo "Re-running the bootstrap script!"
    carthage bootstrap --platform iOS application-services
    echo "Application Services is back on its Carthage version!"
  fi
else
  echo "Using local Application Services: ${APP_SERVICES_DIR}"
  if [ ! -h "${FRAMEWORK_LOCATION}" ]; then
    rm -rf "${FRAMEWORK_LOCATION}"
    ln -s "${APP_SERVICES_DIR}/Carthage/Build/iOS/Static/MozillaAppServices.framework" "${PWD}/Carthage/Build/iOS"
  fi
  pushd "${APP_SERVICES_DIR}"
  env -i PATH="$(bash -l -c 'echo $PATH')" ./build-carthage.sh --no-archive
  popd
fi
