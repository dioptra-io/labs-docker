# education

## Lab POC

Replace `username` with you own username.

```bash
# Launch two containers with a webserver serving /usr/share/nginx/html on port 80
host> kubectl run username-src -it --image=praqma/network-multitool:extra --overrides='{ "apiVersion": "v1", "spec": { "nodeSelector": { "kubernetes.io/hostname": "gcp-europe-west6-a-ab41.edge-net.io" }}}' --requests='cpu=100m,memory=512Mi'
host> kubectl run username-dst -it --image=praqma/network-multitool:extra --overrides='{ "apiVersion": "v1", "spec": { "nodeSelector": { "kubernetes.io/hostname": "gcp-asia-east2-a-e265.edge-net.io" }}}' --requests='cpu=100m,memory=512Mi'

# Attach to a shell in each containers
host> kubectl exec -it username-src -- /bin/bash
host> kubectl exec -it username-dst -- /bin/bash

# Get the IP addresses of the dst container from src (TODO: Not needed if cluster DNS?)
# In src shell:
src> ip addr show dev eth0
# 10.xxx.xxx.xxx

# Create files on the dst container
dst> dd if=/dev/urandom of=/usr/share/nginx/html/32M.bin bs=32M count=1
dst> dd if=/dev/urandom of=/usr/share/nginx/html/128M.bin bs=128M count=1
# ...

# Launch a tcpdump on the dst container
dst> tcpdump -w dump.pcap

# Download the files (TODO: cluster DNS?)
src> curl -O 10.xxx.xxx.xxx/32M.bin
src> curl -O 10.xxx.xxx.xxx/128M.bin

# Stop the tcpdump
dst> CTRL+C

# Retrieve the pcap file on your laptop
host> kubectl cp username-dst:dump.pcap dump.pcap

# Delete the containers
host> kubectl delete pod username-src username-dst
```

## TODO

- See with Berat the proper RBAC configuration.
- See with Berat to increase/remove resource quotas.
- Do we need to always specify `--requests` in `kubectl run` ?
- Fix DNS in cloud nodes

## Warning

- Traceroute between (GCP) cloud nodes (on their public IPs) => chances that we see nothing due to private infra.
