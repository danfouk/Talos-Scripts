## Deploying Cilium CNI in Kubenert without Kube-Proxy
The kubenerts cluster so far provisioned thus not include `KUBE-PROXY`. Let configure this Kubernetes cluster without `kube-proxy`,to use Cilium CNI to fully replace it.
+ Deploy `kubenerts cluster` without kube-proxy was achived by patching configuration file with the config below

        cluster:
          network:
            cni:
              name: none
          proxy:
            disabled: true
> [!NOTE]
>Due to the fact that our cluster is without kube-proxy and as a consequence,the Cilium agent needs to be made aware of `KUBERNETES_SERVICE_HOST` and `KUBERNETES_SERVICE_PORT` with a ClusterIP of the kube-apiserver service.

    API_SERVER_IP=<your_api_server_ip>
    # Kubeadm default is 6443
    API_SERVER_PORT=<your_api_server_port>
    helm install cilium cilium/cilium --version 1.14.15 \
        --namespace kube-system \
        --set kubeProxyReplacement=true \
        --set k8sServiceHost=${API_SERVER_IP} \
        --set k8sServicePort=${API_SERVER_PORT}

The next step is to use `Cilium CLI`,let start by install it on our linux jumpbox.

    CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
    CLI_ARCH=amd64
    if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
    curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
    sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
    sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
    rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
      
 >[!NOTE] 
 > It is recommended to template the cilium manifest using helm and use it as part of Talos machine config, but if you want to install Cilium using the Cilium CLI, you can follow the steps below.

    cilium install \
    --set ipam.mode=kubernetes \
    --set kubeProxyReplacement=true \
    --set securityContext.capabilities.ciliumAgent="{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}" \
    --set securityContext.capabilities.cleanCiliumState="{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}" \
    --set cgroup.autoMount.enabled=false \
    --set cgroup.hostRoot=/sys/fs/cgroup \
    --set k8sServiceHost=localhost \
    --set bpf.datapathMode=netkit \
    --set hubble.relay.enabled=true \
    --set hubble.ui.enabled=true \
    --set hubble.enabled=true \
    --set hubble.metrics.enabled="{dns,drop,tcp,flow,icmp,http}" \
    --set hubble.ui.service.type=NodePort \
    --set hubble.relay.service.type=NodePort \
    --set k8sServicePort=7445

> [!IMPORTANT]
> ***This put your cluster is a ready state and fully functional now.***

# How to add more nodes to a Talos Linux cluster.

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
