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


> [!NOTE]
> Useful information that users should know, even when skimming content.

> [!TIP]
> Helpful advice for doing things better or more easily.

> [!IMPORTANT]
> Key information users need to know to achieve their goal.

> [!WARNING]
> Urgent info that needs immediate user attention to avoid problems.

> [!CAUTION]
> Advises about risks or negative outcomes of certain actions.

- George Washington
* John Adams
+ Thomas Jefferson
