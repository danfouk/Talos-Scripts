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
`Notes :`
- Download the Talos ISO from https://github.com/siderolabs/talos/releases/tag/v1.7.6
- For me I prefere to use the https://factory.talos.dev/ to generate custom ISO Images with the needed system extensions for my environment:
>System Extensions which enable one to extend the Talos Linux base image with additional feature: extra drivers, hardware firmware, container runtimes, guest agents, etc.

 >[!TIP]
 >For a highly available production Kubernetes cluster, it is recommended to use three control plane nodes. Using five nodes can provide greater fault tolerance, but imposes more replication overhead and can result in worse performance.

- Boot all three control plane nodes at this point. They will boot Talos Linux, and come up in maintenance mode, awaiting a configuration.
- 





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
