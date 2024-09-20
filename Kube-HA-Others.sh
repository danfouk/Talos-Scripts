192.168.8.10 kubemaster-01 kubemaster-01.home.local
192.168.8.11 kubemaster-02 kubemaster-02.home.local
192.168.8.12 kubemaster-03 kubemaster-03.home.local
192.168.8.13 kubelb-01 kubelb-01.home.local
192.168.8.14 kubelb-02 kubelb-02.home.local
192.168.8.15 kubeworker-01 kubeworker-01.home.local
192.168.8.16 kubeworker-02 kubeworker-02.home.local
192.168.8.17 kubeworker-03 kubeworker-03.home.local
192.168.8.18 kubeworker-04 kubeworker-04.home.local


apt install keepalived haproxy psmisc -y





helm install cilium ./cilium \
    --namespace kube-system \
    --set kubeProxyReplacement=true \
    --set loadBalancer.algorithm=maglev \
    --set loadBalancer.mode=dsr \
    --set loadBalancer.dsrDispatch=geneve \
    --set k8sServiceHost=vip-kubemaster \
    --set enableCiliumEndpointSlice=true \
    --set k8sServicePort=6443

    To enable the bandwidth manager on an existing installation, run

    helm upgrade cilium ./cilium \
  --namespace kube-system \
  --reuse-values \
  --set bandwidthManager.enabled=true
  
kubectl -n kube-system rollout restart ds/cilium


helm upgrade cilium ./cilium \
    --namespace kube-system \
    --reuse-values \
    --set ingressController.enabled=true \
    --set loadBalancer.l7.backend=envoy \
    --set ingressController.loadbalancerMode=dedicated
kubectl -n kube-system rollout restart deployment/cilium-operator
kubectl -n kube-system rollout restart ds/cilium



helm repo add cilium https://helm.cilium.io/
helm upgrade --install cilium cilium/cilium --version 1.14.6 \
    --namespace kube-system \
     \
     \
     \
     \
   \
    \
   

    cilium install --version=v1.14.6 --set sctp.enabled=true --set hubble.enabled=true --set hubble.metrics.enabled="{dns,drop,tcp,flow,icmp,http}" --set hubble.relay.enabled=true --set hubble.ui.enabled=true  --set hubble.ui.service.type=NodePort --set hubble.relay.service.type=NodePort