# Matomo configuration

Configuration of Matomo on the frontend Kubernetes cluster.

For an overview see [Confluence](https://kb-ramsalt.atlassian.net/l/c/4kaDfkXt).

This repository contains all manifests for the configuration of an OVH managed
Kubernetes cluster as Matomo frontend.

* **System components** (everything under `system/') need to be manually deployed by a cluster admin.
* **Matomo** (Helmchart in `charts/matomo`, configured with files in `values/`) will be upgraded automatically by CircleCI on each push to the repo.

## System Deployment

Change to `system/` and adjust the configuration as necessary.

Run helmfile to apply the changes. For requirements see the [helmfile documentation](https://github.com/roboll/helmfile):

```
helmfile apply
```

## Matomo Deployment

All pushes to the `main` branch trigger the deployment in [.circleci/config.yml](.circleci/config.yml).

The matomo container is a [custom image](https://github.com/ramsalt/matomo) based on [Wodby's Matomo container](https://github.com/wodby/matomo).

## Matomo configuration

* Matomo configuration is in [values/matomo.yaml](values/matomo.yaml).
* Secrets configuration is generated from [values/secrets.yaml.tpl](values/secrets.yaml.tpl).  The `MATOMO_MYSQL_PASS` and DATABASE_ ssl environment variable will be replaced by the password configured in CircleCI on deployment.

SSL certificates for encrypted communication with MySQL have been created with [Ansible](https://bitbucket.org/ramsalt/ansible-playbooks/src/master/).
