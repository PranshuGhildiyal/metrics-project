## **Architecture**
![Architecture Diagram](images/architecture.drawio.svg)

---

## **Overview**:

1. **Kubernetes Cluster Setup**:
   - A **K3d cluster** is created as the local Kubernetes environment for testing and deployment.

2. **Namespace and Resources Creation**:
   - A **Namespace** called `monitoring` is created where all the resources (Pods, Services, Persistent Volumes, etc.) will reside.
   - **Persistent Volume (PV)** and **Persistent Volume Claim (PVC)** are defined to store metrics data on the cluster nodes using a `hostPath`, which points to `/mnt/metrics` on the nodes.

3. **Role-Based Access Control (RBAC)**:
   - A **Role** (`pod-reader`) is created in the `monitoring` namespace to allow `get` and `list` access to the **endpoints** resource. This is necessary to fetch information about the `node-exporter` Pods.
   - A **RoleBinding** binds the `pod-reader` role to the default **ServiceAccount** in the `monitoring` namespace, granting it the necessary permissions.

4. **Node Exporter Deployment**:
   - **Node Exporter** is deployed using a **DaemonSet** to ensure that a pod runs on every node in the cluster.
   - The **Node Exporter** exposes system metrics (CPU, memory, disk, etc.) at port `9100`.
   - A **Service** (`node-exporter-svc`) is created to expose the Node Exporter pods to other resources within the cluster, allowing the CronJob to query metrics from the exporter pods.

5. **CronJob for Fetching Metrics**:
   - A **CronJob** is created to run every 5 minutes.
   - The **CronJob** fetches metrics from the Node Exporter pods and stores them in the mounted **Persistent Volume** (`metrics-pvc`).
   - The **CronJob** runs a Docker container with the custom image (`pranshughildiyal123/fetch-metrics:latest`).
   - The container contains a script (`fetch-metrics.sh`) that:
     - Queries the `node-exporter-svc` to get a list of IPs of the Node Exporter pods.
     - For each pod, it fetches the metrics via HTTP (e.g., `curl http://<POD_IP>:9100/metrics`).
     - The fetched metrics are saved as text files in the `/metrics` directory, which is mounted from the Persistent Volume.
     - The files are named with the pod's IP and a timestamp to keep track of when the metrics were collected.

6. **Monitoring with K9s**:
   - The user can use **K9s**, a terminal-based tool, to interact with the Kubernetes cluster and monitor the resources.
   - K9s provides real-time monitoring of the **Node Exporter pods**, **CronJob executions**, and the overall status of the deployment.

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

This project is **intended for demo purposes only** and should not be used in a production environment. Additionally, ensure proper security and monitoring configurations before using this in real-world scenarios.

---
```
metrics-project/
├── images/
│   └── architecture.drawio.svg   # Architecture diagram image
├── app/
│   ├── Dockerfile         # Dockerfile for building the CronJob image
│   ├── fetch-metrics.sh   # Script for fetching and storing metrics
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
