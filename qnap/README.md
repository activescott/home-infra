# QNAP

Here lies scripts and noters for my QNAP.

## Hardware Summary

- Model: QNAP TS-453D.
- Memory: 32GB
- CPU: Intel(R) Celeron(R) J4125 CPU @ 2.00GHz
- Drives: 4x HITACHI HUS724040ALE640 3.64 TB (4 TB) 6Gbps SATA

## Scripts & Tricks

### Using Auto-updating Let's Encrypt Certs with QNAP

The [update-qnap-certs.sh](update-qnap-certs.sh) script does the qnap-specific stuff for updating certificates. The certificates themselves are updated using a cron job as described in my [cron container](/containers/cron/README.md)
