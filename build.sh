#!/bin/bash

# Copyright (C) 2016  Nicolas Lamirault <nicolas.lamirault@gmail.com>

# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

ALPINE_VERSION=$1

echo -e "Build Portefaix Rkt Base using Alpine ${ALPINE_VERSION}"

acbuild --debug begin ./${ALPINE_VERSION}/alpine-${ALPINE_VERSION}-linux-amd64.aci

acbuild --debug set-name github.com/portefaix/base
acbuild --debug annotation add authors "Nicolas Lamirault <nicolas.lamirault@gmail.com>"
acbuild --debug label add arch amd64
acbuild --debug label add os linux
acbuild --debug label add alpine_version ${ALPINE_VERSION}

acbuild --debug run -- apk update
acbuild --debug run -- apk upgrade
acbuild --debug run -- apk add bash
acbuild --debug run -- rm -rf /var/cache/apk/*

acbuild --debug write --overwrite ./${ALPINE_VERSION}/base-${ALPINE_VERSION}-linux-amd64.aci

acbuild --debug end
