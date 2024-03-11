#!/usr/bin/env bash

# Set CLI version
ETCD_VER=v3.5.12

# Set binary repository
GITHUB_URL=https://github.com/etcd-io/etcd/releases/download
DOWNLOAD_URL=${GITHUB_URL}

# Cleanup previous iterations so we can re-run it as needed and prevent errors
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
rm -rf /tmp/etcd-cli && mkdir -p /tmp/etcd-cli

# Fetch and unpack
curl -L ${DOWNLOAD_URL}/${ETCD_VER}/etcd-${ETCD_VER}-linux-amd64.tar.gz -o /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz
tar xzvf /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz -C /tmp/etcd-cli --strip-components=1
rm -f /tmp/etcd-${ETCD_VER}-linux-amd64.tar.gz

ETCDCTL=/tmp/etcd-download-test/etcdctl
ETCDUTL=/tmp/etcd-download-test/etcdutl

# Print out the version to console
$ETCDCTL version
$ETCDUTL version

# Move the binaries to common bin path
sudo /usr/bin/mv $ETCDCTL /usr/local/bin/
sudo /usr/bin/mv $ETCDUTL /usr/local/bin/

# Cleanup
rm -rf /tmp/etcd-cli

# Specifics for rancher K3S
ETC_RANCHER_KEY=/var/lib/rancher/k3s/server/tls/etcd/client.key
ETC_RANCHER_CERT=/var/lib/rancher/k3s/server/tls/etcd/client.crt
ETC_RANCHER_CACERT=/var/lib/rancher/k3s/server/tls/etcd/server-ca.crt

# Printout test info
etcdctl --key $ETC_RANCHER_KEY --cert $ETC_RANCHER_CERT  --cacert $ETC_RANCHER_CACERT member list
