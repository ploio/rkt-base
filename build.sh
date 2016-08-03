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

VERSION=0.2.0

ACBUILD=${ACBUILD:-acbuild}

ALPINE_VERSION=$1

echo -e "Build Portefaix Rkt Base using Alpine ${ALPINE_VERSION}"

$ACBUILD --debug begin ./${ALPINE_VERSION}/alpine-${ALPINE_VERSION}-linux-amd64.aci

$ACBUILD --debug set-name github.com/portefaix/base
$ACBUILD --debug annotation add authors "Nicolas Lamirault <nicolas.lamirault@gmail.com>"
$ACBUILD --debug label add version ${VERSION}
$ACBUILD --debug label add arch amd64
$ACBUILD --debug label add os linux
$ACBUILD --debug label add alpine_version ${ALPINE_VERSION}

$ACBUILD --debug run -- apk update
$ACBUILD --debug run -- apk upgrade
$ACBUILD --debug run -- apk add bash
$ACBUILD --debug run -- rm -rf /var/cache/apk/*

$ACBUILD --debug write --overwrite ./${ALPINE_VERSION}/base-${ALPINE_VERSION}-linux-amd64.aci

$ACBUILD --debug end
