#!/bin/bash

# Define output directory and ensure it exists
OUTPUT_DIR="/metrics"
mkdir -p "$OUTPUT_DIR"

# Get the list of pod IPs behind the node-exporter service
PODS=$(kubectl get endpoints node-exporter-svc -n monitoring -o jsonpath='{.subsets[*].addresses[*].ip}')
# Loop through the list of pod IPs
for POD_IP in $PODS; do
  FILENAME="$OUTPUT_DIR/node-metrics-${POD_IP}-$(date +%Y%m%d%H%M%S).txt"
  
  echo "Fetching metrics from node-exporter pod at IP: $POD_IP"
  
  # Fetch metrics from the node-exporter pod and save it to the file
  curl "http://$POD_IP:9100/metrics" > "$FILENAME"
  
  echo "Metrics saved to $FILENAME"
  echo "----------------------------------------"
done

