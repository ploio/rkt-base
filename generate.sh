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

ACI=$(pwd)/alpine-${ALPINE_VERSION}-linux-amd64.aci

echo -e "Generate Rkt Alpine from Docker Alpine ${ALPINE_VERSION}"
docker2aci docker://alpine:${ALPINE_VERSION}
mkdir library-alpine-${ALPINE_VERSION}
tar -xf library-alpine-${ALPINE_VERSION}.aci -C library-alpine-${ALPINE_VERSION}
rm library-alpine-${ALPINE_VERSION}.aci

echo -e "Build ACI ${ACI}"
pushd library-alpine-${ALPINE_VERSION}
mv manifest manifest.old
jq '.name = "github.com/portefaix/alpine"' manifest.old > manifest
rm manifest.old
tar -cf ${ACI} *
popd

rm -fr library-alpine-${ALPINE_VERSION}
