#!/bin/bash

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

# This runs dashboard metrics-scraper in container.

CD="$(pwd)"
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

# Build and run container for dashboard metrics-scraper
DASHBOARD_METRICS_IMAGE_NAME=${K8S_DASHBOARD_METRICS_CONTAINER_NAME:-"k8s-dashboard-metrics-scraper-dev-image"}
K8S_DASHBOARD_METRICS_SRC=${K8S_DASHBOARD_METRICS_SRC:-"${CD}"}
K8S_DASHBOARD_METRICS_CONTAINER_NAME=${K8S_DASHBOARD_METRICS_CONTAINER_NAME:-"k8s-dashboard-dev"}

echo "Remove existing container ${K8S_DASHBOARD_METRICS_CONTAINER_NAME}"
docker rm -f ${K8S_DASHBOARD_METRICS_CONTAINER_NAME}

# Always test if the image is up-to-date. If nothing has changed since last build,
# it'll just use the already-built image
echo "Start building container image for development"
docker build -t ${DASHBOARD_METRICS_IMAGE_NAME} -f ${DIR}/Dockerfile ${DIR}/../

# Run metrics-scraper container for development and expose necessary ports automatically.
echo "Run container for development"
docker run \
	-it \
	--net=host \
	--name=${K8S_DASHBOARD_METRICS_CONTAINER_NAME} \
	--security-opt=seccomp:unconfined \
	-v /var/run/docker.sock:/var/run/docker.sock \
	-v ${K8S_DASHBOARD_METRICS_SRC}:/dashboard-metrics-scraper \
	-v ${K8S_DASHBOARD_KUBECONFIG}:/kubeconfig \
	-e K8S_DASHBOARD_METRICS_DEBUG=${K8S_DASHBOARD_METRICS_DEBUG} \
	-e K8S_DASHBOARD_METRICS_OMIT_DEPS=${K8S_DASHBOARD_METRICS_OMIT_DEPS} \
	${DOCKER_RUN_OPTS} \
	${DASHBOARD_METRICS_IMAGE_NAME}
