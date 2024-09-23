# Creating My Ultimate Kubnert LAB

**Start by Creating 3 Control VMs each with:**
---
   - 50 GB SSD (boot drive)
   - `4 vCPU`
   - 16 GB RAM
   - 2 vNIC (One for _Public Access_ and One for the _Private Access_ to be used for _KUB internal communication_)

**For Worker Nodes we created 5 nodes each with:**
---
   - 50 GB SSD (boot drive)
   - 5x200 GB (to be used for Ceph Rook )
   - 12 vCPU (nested)
   - 64 GB RAM
   - 2 vNIC (One for _Public Access_ and One for the _Private Access_ to be used for _KUB internal communication_)

**Installation Notes and Steps**
---
` Notes :` _credit to Talos Offical Docs._
- Download the Talos ISO from  https://github.com/siderolabs/talos/releases/download/v1.7.6/metal-amd64.iso
- For me I prefere to use the https://factory.talos.dev/ to generate custom ISO Images with the needed system extensions for my environment:
>System Extensions which enable one to extend the Talos Linux base image with additional feature: extra drivers, hardware firmware, container runtimes, guest agents, etc.

 >[!TIP]
 >For a highly available production Kubernetes cluster, it is recommended to use three control plane nodes. Using five nodes can provide greater fault tolerance, but imposes more replication overhead and can result in worse performance.

At this point, you should:
- boot one machine off the ISO to be the control plane node
- boot one or more machines off the same ISO to be the workers

**Define the Kubernetes Endpoint**
---
- In order to configure Kubernetes, Talos needs to know what the endpoint of the Kubernetes API Server will be.
- In order for the endpoint to be highly available, it should be configured in a way that uses all available control plane nodes.
- There are 3 major ways
   - Using a load-balancer,o
   - Using multiple DNS records,
   - Talos Linux’s built in VIP functionality.
- For my LAB I am using `Talos Linux’s built in VIP functionality`.

**Layer 2 VIP Shared IP** 
---
- Talos has integrated support for serving Kubernetes from a shared/virtual IP address. This requires Layer 2 connectivity between control plane nodes.
- Choose an unused IP address on the same subnet as the control plane nodes for the VIP. For instance, if your control plane node IPs are:
   - 192.168.0.10
   - 192.168.0.11
   - 192.168.0.12
- One could choose the IP 192.168.0.15 as your VIP/SHARED IP address. (Make sure that 192.168.0.15 is not used by any other machine and is excluded from DHCP ranges.)

Once chosen, form the full HTTPS URL from this IP:

      https://192.168.0.15:6443
> [!IMPORTANT]
> If you create a DNS record for this IP, note you will need to use the IP address itself, not the DNS name, to configure the shared IP (machine.network.interfaces[].vip.ip) in the Talos configuration.

> After the machine configurations are generated, you will want to edit the controlplane.yaml file to activate the VIP:

      machine:
         network:
           interfaces:
            - interface: enp2s0
              dhcp: true
              vip:
                ip: 192.168.0.15
`Read More:`  https://www.talos.dev/v1.7/talos-guides/network/vip/

***Multihoming and etcd***
---
+ I tried to use the ***multihoming*** approach of using two vNIC in my setup to enable seperate kubenerts internal communication from public comms.
+ The `etcd cluster` needs to establish a mesh of connections among the members,This approach requires additional configuration.
+ It is done using the so-called advertised address - each node learns the others’ addresses as they are advertised.
> [!WARNING]
> It is crucial that these IP addresses are stable, i.e., that each node always advertises the same IP address.

***Multihoming and kubelets***
---
- Stable IP addressing for kubelets (i.e., nodeIP) is not strictly necessary but highly recommended as it ensures that, e.g., kube-proxy and CNI routing take the desired routes. 
- Analogously to etcd, for kubelets this is controlled via `machine.kubelet.nodeIP.validSubnets`

> [!TIP]
> Let’s assume that we have a cluster with two networks:
   - public network xxx.xxx.xxx.0/x
   - private network 192.168.0.0/16
     
> We want to use the private network for etcd and kubelet communication:

      machine:
        kubelet:
          nodeIP:
            validSubnets:
              - 192.168.0.0/16
      #...
      cluster:
        etcd:
          advertisedSubnets: # listenSubnets defaults to advertisedSubnets if not set explicitly
            - 192.168.0.0/16

**Configure Talos Linux from a Client Ubuntu Server**
---
+ To start with Talos configuration we will need to install the `talosctl` tool.
+ You can automatically install the correct version of talosctl for your operating system and architecture with an installer script.
+ This script won’t keep your version updated with releases and you will need to re-run the script to download a new version

        curl -sL https://talos.dev/install | sh

**Generating configuration Secrets**
---
+ When generating the configuration files for a Talos Linux cluster, it is recommended to start with generating a secrets bundle which should be saved in a secure location.
+ This bundle can be used to generate machine or client configurations at any time:
  
      talosctl gen secrets -o secrets.yaml
> The secrets.yaml can also be extracted from the existing controlplane machine configuration with `talosctl gen secrets --from-controlplane-config controlplane.yaml -o secrets.yaml` command.

- Now, lets go ahead and  generate the machine configuration for each node:

        talosctl gen config --with-secrets secrets.yaml <cluster-name> <cluster-endpoint>
- Note, `cluster-name` is an arbitrary name for the cluster, used in your local client configuration as a label. It should be unique in the configuration on your local workstation.
- The `cluster-endpoint` is the Kubernetes Endpoint you selected from above. This is the Kubernetes API URL, and it should be a complete URL, with https:// and port. (The default port is 6443)
  
>  Example:

      talosctl gen config --with-secrets secrets.yaml my-cluster https://192.168.64.15:6443
      generating PKI and tokens
      created controlplane.yaml
      created worker.yaml
      created talosconfig
- For my set-up I configured a patch file which I used to customize the default generated files, both `control plane` and `worker node` using the command below.
- `control plane`

      talosctl machineconfig patch controlplane.yaml --patch @controlplane-patch --output controlplane-01.yaml
  - https://github.com/danfouk/Talos-Scripts/blob/main/controlplane-patch.yaml

- `worker node`

        talosctl machineconfig patch worker.yaml --patch @worker-patch.yaml --output worker-01.yaml  
   - https://github.com/danfouk/Talos-Scripts/blob/main/controlplane-patch.yaml
