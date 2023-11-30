#!/bin/bash
#

set -euxo pipefail

# Install calico
helm repo add projectcalico https://docs.tigera.io/calico/charts
kubectl create namespace network
helm install calico projectcalico/tigera-operator --version v3.26.4 --namespace network

# Install metrics-server
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
kubectl create namespace monitor
helm upgrade --install metrics-server metrics-server/metrics-server --namespace monitor

# Install traefik
