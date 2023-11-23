#!/bin/sh

[[ -n $DEBUG ]] && set -x
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

# Version
KUBE_VERSION="${KUBE_VERSION:-latest}"
METRICS_SERVER_VERSION="${METRICS_SERVER_VERSION:-0.6.1}"
CALICO_VERSION="${CALICO_VERSION:-3.26.4}"
KUBERNETES_DASHBOARD_VERSION="${KUBERNETES_DASHBOARD_VERSION:-2.7.0}"
KUBESPHERE_VERSION="${KUBESPHERE_VERSION:-3.3.0}"

######################################################################################################

MASTER_NODES="${MASTER_NODES:-}"
WORKER_NODES="${WORKER_NODES:-}"

######################################################################################################
# SSH config
SSH_USER="${SSH_USER:-root}"
SSH_PASSWORD="${SSH_PASSWORD:-}"
SSH_PRIVATE_KEY="${SSH_PRIVATE_KEY:-}"
SSH_PORT="${SSH_PORT:-22}"
SUDO_USER="${SUDO_USER:-root}"

######################################################################################################

HOSTNAME_PREFIX="${HOSTNAME_PREFIX:-k8s}"

######################################################################################################

CONFIGURE_TCP_IP_SETTING=false
INTERFACE="eth0"
IP_ADDRESS=""
NETMASK=""
DEFAULT_GATEWAY=""
DNS_SERVER=("8.8.8.8" "4.4.4.4")	# DNS Google
DNS_SEARCH=("domain.local")

######################################################################################################
# Kubernetes Storage Classes
NFS_INSTALL_SERVER=true
NFS_SERVER=$HOSTNAME
NFS_SHARE_PATH="/share/nfs"
NFS_


# check the OS
os=$(cat /etc/os-release | grep -o "Ubuntu")
if [ "$os" == "Ubuntu" ]; then
	echo "

        #################################################################
        #                                                               #
        #       This Script Install Master Kubernetes on Ubuntu         #
        #                                                               #
        #################################################################


"
else
	exit 0
fi

