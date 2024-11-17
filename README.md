```markdown
# Fetch Metrics Demo

This project demonstrates a basic architecture for collecting metrics from Kubernetes nodes using a **Node Exporter** DaemonSet and a custom **CronJob**. The collected metrics are stored in a PersistentVolume for later use. This setup is deployed on a **K3d cluster** and managed using **k9s** for visualization and debugging.  

**Note:** This project is intended for **demo purposes only** and is **not suitable for production environments**.

---

## **Overview**

### **Architecture**
1. **Node Exporter**: A DaemonSet deploys `prom/node-exporter` on all Kubernetes nodes to expose metrics at port `9100`.
2. **CronJob**: Runs every 5 minutes to fetch metrics from the Node Exporter pods using the `fetch-metrics.sh` script. Metrics are stored in a PersistentVolume.
3. **PersistentVolume**: A host-path-based volume (`metrics-pv`) is used to persist the metrics data.
4. **RBAC**: A Role and RoleBinding ensure that the CronJob can interact with the Node Exporter service.
5. **Namespace**: All resources are organized under the `monitoring` namespace for better management.
6. **Cluster**: The setup is tested on a **K3d cluster**, a lightweight Kubernetes environment for local development.

---

## **Project Structure**

```plaintext
/
├── app/
│   ├── Dockerfile         # Dockerfile for building the CronJob image
│   ├── fetch-metrics.sh   # Script to fetch metrics from Node Exporter pods
│
└── manifest/
    ├── namespace.yaml         # Namespace definition
    ├── Role.yaml              # RBAC Role for accessing endpoints
    ├── RoleBinding.yaml       # RoleBinding to bind the Role to a ServiceAccount
    ├── metrics-pv.yaml        # PersistentVolume definition
    ├── metrics-pvc.yaml       # PersistentVolumeClaim definition
    ├── node-exporter.yaml     # DaemonSet for Node Exporter
    ├── node-exporter-svc.yaml # Service exposing Node Exporter pods
    ├── cronjob.yaml           # CronJob for fetching metrics
```

---

## **Usage**

### **Prerequisites**
- A running **K3d cluster**.
- **K9s** installed for managing and monitoring Kubernetes resources.
- A PersistentVolume directory on the cluster nodes at `/mnt/metrics`.

### **Steps**
1. **Create a K3d Cluster**:
   ```bash
   k3d cluster create demo-cluster
   ```

2. **Deploy the Namespace**:
   ```bash
   kubectl apply -f ./manifest/namespace.yaml
   ```

3. **Create PersistentVolume and Claim**:
   ```bash
   kubectl apply -f ./manifest/metrics-pv.yaml
   kubectl apply -f ./manifest/metrics-pvc.yaml
   ```

4. **Set up RBAC**:
   ```bash
   kubectl apply -f ./manifest/Role.yaml
   kubectl apply -f ./manifest/RoleBinding.yaml
   ```

5. **Deploy Node Exporter**:
   ```bash
   kubectl apply -f ./manifest/node-exporter.yaml
   kubectl apply -f ./manifest/node-exporter-svc.yaml
   ```

6. **Deploy the CronJob**:
   ```bash
   kubectl apply -f ./manifest/cronjob.yaml
   ```

7. **Use K9s for Monitoring**:
   Launch `k9s` to view and monitor your Kubernetes resources:
   ```bash
   k9s
   ```

---

## **Disclaimer**

This project is **intended for demo purposes only** and should not be used in a production environment. The PersistentVolume uses `hostPath`, which is not recommended for production-grade setups. Additionally, ensure proper security and monitoring configurations before using this in real-world scenarios.

---

```
