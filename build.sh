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

VERSION=0.1.0

ACBUILD=${ACBUILD:-acbuild}

$ACBUILD --debug begin

$ACBUILD --debug set-name portefaix/base
$ACBUILD --debug annotation add authors "Nicolas Lamirault <nicolas.lamirault@gmail.com>"
$ACBUILD --debug label add version $VERSION

# based on alpine
$ACBUILD --debug dep add quay.io/coreos/alpine-sh

$ACBUILD --debug run -- apk update
$ACBUILD --debug run -- apk upgrade
$ACBUILD --debug run -- apk add bash
$ACBUILD --debug run -- rm -rf /var/cache/apk/*

$ACBUILD --debug write --overwrite ./rkt-base-$VERSION.aci

$ACBUILD --debug end
