apiVersion: storage.k8s.io/v1
kind: StorageClass
metadata:
  name: openebs-zfspv
allowVolumeExpansion: true
parameters:
  recordsize: "128k"
  compression: "off"
  dedup: "off"
  fstype: "zfs"
  poolname: "zfspv-pool"
provisioner: zfs.csi.openebs.io
volumeBindingMode: WaitForFirstConsumer




## Eip
---
apiVersion: network.kubesphere.io/v1alpha2
kind: Eip
metadata:
  name: eip-pool
spec:
  address: 192.168.8.30-192.168.8.50
  protocol: layer2
  disable: false
  interface: ens192

---
  kubectl label namespace default \istio-injection=enabled


  annotations:
    lb.kubesphere.io/v1alpha1: openelb
    protocol.openelb.kubesphere.io/v1alpha1: layer2
    eip.openelb.kubesphere.io/v1alpha2: eip-pool


 PS C:\Users\danfo> helm install kubeapps --namespace kubeapps bitnami/kubeapps
NAME: kubeapps
LAST DEPLOYED: Sat Jan 27 06:55:32 2024
NAMESPACE: kubeapps
STATUS: deployed
REVISION: 1
TEST SUITE: None
NOTES:
CHART NAME: kubeapps
CHART VERSION: 14.3.0
APP VERSION: 2.9.0** Please be patient while the chart is being deployed **

Tip:

  Watch the deployment status using the command: kubectl get pods -w --namespace kubeapps

Kubeapps can be accessed via port 80 on the following DNS name from within your cluster:

   kubeapps.kubeapps.svc.cluster.local

To access Kubeapps from outside your K8s cluster, follow the steps below:

1. Get the Kubeapps URL by running these commands:
   echo "Kubeapps URL: http://127.0.0.1:8080"
   kubectl port-forward --namespace kubeapps service/kubeapps 8080:80

2. Open a browser and access Kubeapps using the obtained URL.


"KRB5_TRACE=/dev/stdout /usr/sbin/adcli -vv join .... --show-details"

kubectl create --namespace default serviceaccount kubeapps-operator
kubectl create clusterrolebinding kubeapps-operator --clusterrole=cluster-admin --serviceaccount=default:kubeapps-operator

kubectl get --namespace default secret kubeapps-operator-token -o go-template='{{.data.token | base64decode}}'