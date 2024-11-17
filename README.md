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

---
```
