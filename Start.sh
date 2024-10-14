#!/bin/sh


echo "Disabling swap"
swapoff -a; sed -i '/swap/d' /etc/fstab

echo "Disabling Firewall"
systemctl disable --now ufw

echo "Enabling and Loading Kernel modules"
{
cat >> /etc/modules-load.d/containerd.conf <<EOF
overlay
br_netfilter
EOF

modprobe overlay
modprobe br_netfilter
}

echo "Adding Kernel settings"
{
cat >>/etc/sysctl.d/kubernetes.conf<<EOF
net.bridge.bridge-nf-call-ip6tables = 1
net.bridge.bridge-nf-call-iptables  = 1
net.ipv4.ip_forward                 = 1
EOF

sysctl --system
}

echo "Install Containerd runtime"
{
  apt update
  apt install -y containerd curl gnupg2 software-properties-common apt-transport-https ca-certificates
  mkdir /etc/containerd
  containerd config default > /etc/containerd/config.toml
  sudo sed -i 's/SystemdCgroup \= false/SystemdCgroup \= true/g' /etc/containerd/config.toml
  systemctl restart containerd
  systemctl enable containerd
}

echo "Installing Kubernetes repo"
{
  curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.30/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
  echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.30/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
}

echo "Update the system"
{
  apt update
  apt update && apt install -y kubeadm kubelet kubectl
  sudo apt-mark hold kubelet kubeadm kubectl
}

echo "Done with the Installation and Restarting"
{
  sudo systemctl enable --now kubelet
}

sudo kubeadm init --pod-network-cidr=10.244.0.0/16  --service-cidr 10.96.0.0/12 --skip-phases=addon/kube-proxy
192.168.10.10   kube-master-01
192.168.10.14   kube-worker-01
192.168.10.15   kube-worker-02
192.168.10.16   kube-worker-03


## Resolve Kubelet Pod Termination Issues
   - mkdir /etc/apparmor.d/disable      # only if 'disable' directory is missing
    ln -s /etc/apparmor.d/runc /etc/apparmor.d/disable/
    apparmor_parser -R /etc/apparmor.d/runc
    systemctl restart containerd
