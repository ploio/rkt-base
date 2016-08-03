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

APP=portefaix
NAMESPACE=$(APP)
IMAGE=base

NO_COLOR=\033[0m
OK_COLOR=\033[32;01m
ERROR_COLOR=\033[31;01m
WARN_COLOR=\033[33;01m

RKT=rkt

VERSION := $(shell grep 'VERSION=' build.sh|awk -F"=" '{ print $$2 }')

all: help

help:
	@echo -e "$(OK_COLOR)==== $(APP) [$(VERSION)] ====$(NO_COLOR)"
	@echo -e "$(WARN_COLOR)- build version=xx   : Make the ACI image"
	@echo -e "$(WARN_COLOR)- publish version=xx : Publish the image"
	@echo -e "$(WARN_COLOR)- run version=xx     : Run a container"
	@echo -e "$(WARN_COLOR)- debug version=xx   : Launch a shell"

.PHONY: generate
generate:
	@echo -e "$(OK_COLOR)[$(APP)] Generate Alpine ACI $(NO_COLOR)"
	@sudo ./generate.sh 3.4
	@sudo ./generate.sh 3.3
	@sudo ./generate.sh 3.2
	@sudo ./generate.sh 3.1
	@sudo ./generate.sh edge

.PHONY: fetch
fetch:
	@echo -e "$(OK_COLOR)[$(APP)] Fetch Alpine ACI $(NO_COLOR)"
	@sudo $(RKT) --insecure-options=image fetch https://github.com/portefaix/rkt-base/raw/master/alpine-3.4-linux-amd64.aci
	@sudo $(RKT) --insecure-options=image fetch https://github.com/portefaix/rkt-base/raw/master/alpine-3.3-linux-amd64.aci
	@sudo $(RKT) --insecure-options=image fetch https://github.com/portefaix/rkt-base/raw/master/alpine-3.2-linux-amd64.aci
	@sudo $(RKT) --insecure-options=image fetch https://github.com/portefaix/rkt-base/raw/master/alpine-3.1-linux-amd64.aci
	@sudo $(RKT) --insecure-options=image fetch https://github.com/portefaix/rkt-base/raw/master/alpine-edge-linux-amd64.aci

.PHONY: build
build:
	@echo -e "$(OK_COLOR)[$(APP)] Build $(NAMESPACE)/$(IMAGE):$(VERSION)$(NO_COLOR)"
	@sudo ./build.sh 3.4

.PHONY: sign
sign:
	@echo -e "$(OK_COLOR)[$(APP)] Sign image $(NAMESPACE)/$(IMAGE):$(VERSION)$(NO_COLOR)"
	gpg --armor --yes \
	     --output /rkt-base-$(VERSION).asc \
	     --detach-sig ./rkt-base-$(VERSION).aci

.PHONY: run
run:
	@echo -e "$(OK_COLOR)[$(APP)] run $(NAMESPACE)/$(IMAGE):$(VERSION)$(NO_COLOR)"
	@$(RKT) --insecure-options=image run ./rkt-base-$(VERSION).aci --exec /bin/date
