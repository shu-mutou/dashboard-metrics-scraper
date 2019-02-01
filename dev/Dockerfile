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

# Accept the Go version for the image to be set as a build argument.
# Default to Go 1.11
ARG GO_VERSION=1.11
ARG GOARCH=amd64

# First stage: build the executable.
FROM golang:${GO_VERSION}-alpine AS builder

# Install the Certificate-Authority certificates for the app to be able to make
# calls to HTTPS endpoints.
RUN apk add --no-cache ca-certificates git gcc g++

# Set the environment variables for the go command:
# CGO_ENABLED=1 to use go-sqlite3.
ENV CGO_ENABLED=1

# Set the working directory outside $GOPATH to enable the support for modules.
WORKDIR /dashboard-metrics-scraper

# Mount the source directory.
VOLUME ["dashboard-metrics-scraper"]

# Declare the port on which the webserver will be exposed.
EXPOSE 8000 2345

# Run the metrics-scraper.
CMD ["/dashboard-metrics-scraper/dev/run-server.sh"]