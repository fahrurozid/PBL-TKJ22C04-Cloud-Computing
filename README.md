# Integrasi Proxmox dengan Container Orchestration (Docker dan Kubernetes)

## 🧪 Tema Penelitian
**“Integrasi Proxmox dengan Container Orchestration (Docker dan Kubernetes)”**

## 📌 Latar Belakang
Proxmox VE adalah platform virtualisasi yang mendukung teknologi KVM untuk VM dan LXC untuk container ringan. Namun, belum mendukung native Docker/Kubernetes. Di sisi lain, Kubernetes lebih unggul dalam hal orkestrasi container, sementara Proxmox unggul dalam manajemen VM. Integrasi keduanya menciptakan lingkungan hybrid yang efisien dan fleksibel, terutama untuk kebutuhan aplikasi modern seperti web IoT.

## ❓ Rumusan Masalah
- Bagaimana arsitektur terbaik untuk mengintegrasikan Proxmox, Docker, dan Kubernetes?
- Bagaimana perbandingan performa VM berbasis KVM vs container Docker di Proxmox?
- Apa saja tantangan dalam manajemen hybrid (VM + container) di infrastruktur Proxmox?

## 🔧 Metodologi

### A. Implementasi Proxmox sebagai Host untuk Docker & Kubernetes

1. **Instalasi dan Konfigurasi Proxmox**
   - Install Proxmox VE di server fisik.
   - Konfigurasi jaringan bridge (`vmbr0`) dan penyimpanan.

2. **Pembuatan VM Cluster**
   - Buat 3+ VM di Proxmox menggunakan KVM.
   - OS: Ubuntu Server 20.04/22.04.
   - Spesifikasi minimum per node: 2 vCPU, 2–4 GB RAM, 20+ GB storage.

3. **Instalasi Docker di Tiap VM**
   ```bash
   sudo apt update
   sudo apt install -y ca-certificates curl gnupg
   sudo install -m 0755 -d /etc/apt/keyrings
   curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
   echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
   https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | \
   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
   sudo apt update
   sudo apt install -y docker-ce docker-ce-cli containerd.io

4. **Instalasi Kubernetes (kubeadm, kubelet, kubectl)**
    ```bash
    sudo apt update
    sudo apt install -y apt-transport-https curl
    curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
    echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | \
    sudo tee -a /etc/apt/sources.list.d/kubernetes.list
    sudo apt update
    sudo apt install -y kubelet kubeadm kubectl
    sudo apt-mark hold kubelet kubeadm kubectl


5. **Inisialisasi Kubernetes di Node Master**
    ```bash
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16
    mkdir -p $HOME/.kube
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $(id -u):$(id -g) $HOME/.kube/config

6. **Join Node Worker**
    Gunakan perintah kubeadm join yang dihasilkan dari kubeadm init untuk menambahkan worker node ke cluster.
7. **Deploy Aplikasi Web IoT**
    deploy apliasi pada deployment.yaml
     ```bash
     kubectl apply -f deployment.yaml
8. **Pengujian Performa**
    Benchmark Tools: sysbench, fio, iperf3
    Parameter yang diuji:
    CPU usage, RAM usage
    Disk I/O performance
    Network throughput
    Latency & responsiveness aplikasi