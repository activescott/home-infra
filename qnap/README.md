# QNAP

Here lies scripts and noters for my QNAP.

## Hardware Summary

- Model: QNAP TS-453D.
- Memory: 32GB
- CPU: Intel(R) Celeron(R) J4125 CPU @ 2.00GHz
- Drives: 4x HITACHI HUS724040ALE640 3.64 TB (4 TB) 6Gbps SATA

## Scripts & Tricks

### Auto-Update Let's Encrypt Certs with QNAP

The [update-qnap-certs.sh](update-qnap-certs/update-qnap-certs.sh) script does the qnap-specific stuff for updating certificates. The certificates themselves are updated using a cron job as described in my [cron container](/containers/cron/README.md). This script packs them into a special file that QNAP requires and restarts the needed QNAP processes. More details are in the comments within the script itself.
The [deploy-update-qnap-certs.sh](update-qnap-certs/deploy-update-qnap-certs.sh) script deploys it from the dev machine with this repo to the QNAP host via SSH/rsync.

### Backing up QNAP NAS to Local Disk & Cloud

See [k8s-backuper/readme.md](k8s-backuper/readme.md)