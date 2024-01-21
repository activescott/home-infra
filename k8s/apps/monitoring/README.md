# Monitoring: Prometheus & Grafana

### Usage

To scrape metrics with Prometheus on a pod, use the following pod-level annotation:

```yaml
# the prometheus config is configured to look for this
prometheus.io/scrape: "true"
```

To scrape metrics with Prometheus on a specific port or path can optionally use the below annotations:

```yaml
prometheus.io/port: "3000"
```

```yaml
prometheus.io/path: "/metrics"
```

This works due to relabels in the prometheus.yml configuration.

To determine these values it depends entirely on the app, so will need to read their docs. Sometimes others publish their own "exporters" for exporting metrics from an app in a proprietary way and publishing them in a way prometheus can consume.

## Grafana

Guide: https://grafana.com/docs/grafana/latest/setup-grafana/installation/kubernetes/

## Prometheus

Guide: https://phoenixnap.com/kb/prometheus-kubernetes
Reference: https://prometheus.io/docs/prometheus/latest/installation/

## Todo:

- transmission metrics: https://github.com/sandrotosi/simple-transmission-exporter

## Notes to self

### Why not Prometheus Operator?

I looked at https://github.com/prometheus-operator/prometheus-operator and https://grafana.com/blog/2023/01/19/how-to-monitor-kubernetes-clusters-with-the-prometheus-operator/ and found the docs hard to follow. E.g. there is no reference on the CRDs. I found some simple articles on prometheus setup and configuring it with configmaps that looked more straightforward for now.
