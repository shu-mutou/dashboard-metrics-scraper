#!/bin/sh

# Copyright 2019 The Kubernetes Authors.
#
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

mkdir -p .tmp
export GOPATH=/dashboard-metrics-scraper/.tmp
export PATH=${GOPATH}/bin:${PATH}

if [ "${K8S_DASHBOARD_METRICS_OMIT_DEPS}" = "false" ] ; then
  echo "Install delve for debuging go."
  go get -u github.com/derekparker/delve/cmd/dlv

  echo "Download dependencies."
  go get -d
fi

if [ "${K8S_DASHBOARD_METRICS_DEBUG}" = "true" ] ; then
  echo "Run delve for remote debuging metrics-scraper"
  dlv debug --headless --listen=:2345 --log -- --kubeconfig /kubeconfig
else
  echo "Run metrics-scraper"
  go run server.go --kubeconfig /kubeconfig
fi
