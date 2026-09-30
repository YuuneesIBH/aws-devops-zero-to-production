# Disk full

**Symptoms:** `No space left on device`, failed writes, evictions or database storage alarms. **Impact:** data ingestion and persistence can stop; deleting unknown files can make recovery worse.

## Immediate checks

Identify the full filesystem and its owner: container ephemeral storage, node disk, PVC, EBS volume or RDS allocated storage. Check both bytes and inodes, growth rate, recent logs and whether data is durable elsewhere.

```sh
df -h
df -i
du -xhd1 /var/log 2>/dev/null
kubectl describe node NODE
kubectl describe pod POD -n NAMESPACE
kubectl get pvc -n NAMESPACE
```

Run host commands only on an authorized host; a Pod filesystem is not the RDS filesystem. For RDS, inspect CloudWatch `FreeStorageSpace` and storage autoscaling settings rather than trying to log into its host.

## Causes and mitigation

Possible causes: growing logs, temporary files, image layers, backups, unbounded uploads or full database storage. Rotate or remove **identified disposable** data after checking retention and ownership. Expand a volume through its supported process only after reviewing filesystem growth and cost. Avoid deleting database files or Terraform state to free space. Verify writes, free space and growth rate.

**Long-term fixes:** retention limits, capacity forecasts and alerts before exhaustion. **Escalate** immediately for database storage exhaustion, suspected data loss or an unknown full volume.
