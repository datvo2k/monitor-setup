#!/bin/sh

[[ -n $DEBUG ]] && set -x
set -o errtrace         # Make sure any error trap is inherited
set -o nounset          # Disallow expansion of unset variables
set -o pipefail         # Use last non-zero exit code in a pipeline

# ------------------------------
# Version
# ------------------------------
#
export METRICVERSION="${METRICVERSION:-0.6.1}"
export calicoVersion="${calicoVersion:-3.26.4}"
export k8sDashBoardVersion="${k8sDashBoardVersion:-2.7.0}"
export kubeShpere="${kubeShpere:-3.3.0}"

export kubeAddon="${METRICVERSION:-metric-server}"
export kubeNetwork="${calicoVersion:-calico}"
export kubeDashBoard="${k8sDashBoardVersion: -dashboard}"
export kubeUI="${kubeShpere: -ui}"

export configureTCPIPSetting=false
export interface="eth0"                                     # Find with 'ip addr'
export ipAddress=""                                         # Require even if 'configureTCPIPSetting' is set to 'false'.
export netmask=""
export defaultGateway=""
export dnsServers=("8.8.8.8" "4.4.4.4")                     # Don't specify more than 3. K8s will only use the first three and throw errors.
export dnsSearch=("domain.local")                           # Your local DNS search domain if you have one.

# ------------------------------
# Kubernetes
# ------------------------------
#
export k8sVersion="latest"                                  # You can specify a specific version such as "1.25.0-00".
export k8sLoadBalancerIPRange=""                            # Either a range such as "192.168.0.100-192.168.0.150" or a CIDR (Add /32 for a single IP).
export k8sAllowMasterNodeSchedule=true                      # Disabling this is best practice however without it MetalLB cannot be deployed until a node is added.

# ------------------------------
# Kubernetes Storage Classes
# ------------------------------
# If the 'nfsInstallServer' or 'smbInstallServer' values are set to 'false' but the 'nfsServer' or 'smbServer' values are set to anything 
# other than this machines hostname, the CSI driver(s) will be installed and storage class(es) created and configured for the specifed server(s).
#
# WARNING: Using the master node as a storage server is not standard practice nor recommended. This option exists so that those who are new to k8s
# can quickly and easily try out Kubernetes features and applications that rely on persistent storage. Do not do this in a production environment.
#
export nfsInstallServer=true
export nfsServer=$HOSTNAME 
export nfsSharePath="/shares/nfs"                           # Local server only.
export nfsDefaultStorageClass=false

export smbInstallServer=true
export smbServer=$HOSTNAME
export smbSharePath="/shares/smb"                           # Local server only.
export smbShareName="persistentvolumes"
export smbUsername=$SUDO_USER
export smbPassword="password"
export smbDefaultStorageClass=true                          # Only one storage class should be set as default.

export TMP_DIR="$(rm -rf /tmp/log-install* && mktemp -d -t log-install.XXXXXXXXXX)"
export LOG_FILE="${TMP_DIR}/log-install.log"

export ERROR_INFO="\n\033[31mERROR Summary: \033[0m\n  "
export ACCESS_INFO="\n\033[32mACCESS Summary: \033[0m\n  "
# ------------------------------
# Parameters
# ------------------------------
#
# while [[ $# -gt 0 ]]; do
#     key="$1"
#     case $key in
#         --configure-tcpip) configureTCPIPSetting="$2"; shift; shift;;
#         --interface) interface="$2"; shift; shift;;
#         --ip-address) ipAddress="$2"; shift; shift;;
#         --netmask) netmask="$2"; shift; shift;;
#         --default-gateway) defaultGateway="$2"; shift; shift;;
#         --dns-servers) dnsServers=($2); shift; shift;;
#         --dns-search) dnsSearch=($2); shift; shift;;
#         --k8s-version) k8sVersion="$2"; shift; shift;;
#         --k8s-load-balancer-ip-range) k8sLoadBalancerIPRange="$2"; shift; shift;;
#         --k8s-allow-master-node-schedule) k8sAllowMasterNodeSchedule="$2"; shift; shift;;
#         --nfs-install-server) nfsInstallServer="$2"; shift; shift;;
#         --nfs-server) nfsServer="$2"; shift; shift;;
#         --nfs-share-path) nfsSharePath="$2"; shift; shift;;
#         --nfs-default-storage-class) nfsDefaultStorageClass="$2"; shift; shift;;
#         --smb-install-server) smbInstallServer="$2"; shift; shift;;
#         --smb-server) smbServer="$2"; shift; shift;;
#         --smb-share-path) smbSharePath="$2"; shift; shift;;
#         --smb-share-name) smbShareName="$2"; shift; shift;;
#         --smb-username) smbUsername="$2"; shift; shift;;
#         --smb-password) smbPassword="$2"; shift; shift;;
#         --smb-default-storage-class) smbDefaultStorageClass="$2"; shift; shift;;

#         *) echo -e "\e[31mError:\e[0m Parameter \e[35m$key\e[0m is not recognised."; exit 1;;
#     esac
# done

# ------------------------------
# Check os
# ------------------------------
#
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

function log_error() {
  local item; item="[$(date +'%Y-%m-%dT%H:%M:%S.%N%z')]: \033[31mERROR:   \033[0m$*"
  ERROR_INFO="${ERROR_INFO}${item}\n  "
  echo -e "${item}" | tee -a "$LOG_FILE"
}


function log_info() {
  printf "[%s]: \033[32mINFO:    \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S.%N%z')" "$*" | tee -a "$LOG_FILE"
}


function log_warning() {
  printf "[%s]: \033[33mWARNING: \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S.%N%z')" "$*" | tee -a "$LOG_FILE"
}


function log_access() {
  ACCESS_INFO="${ACCESS_INFO}$*\n  "
  printf "[%s]: \033[32mINFO:    \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S.%N%z')" "$*" | tee -a "$LOG_FILE"
}


function log_exec() {
  printf "[%s]: \033[34mEXEC:    \033[0m%s\n" "$(date +'%Y-%m-%dT%H:%M:%S.%N%z')" "$*" >> "$LOG_FILE"
}

function addon() {
	if [[ "$KUBE_ADDON" == "metric-server" ]]; then

}
