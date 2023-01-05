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

### CircleCI Kubernetes authentication

CircleCI identifies to the Matomo Kubernetes cluster via OIDC. See:

* https://circleci.com/docs/openid-connect-tokens
* https://docs.ovh.com/ie/en/kubernetes/configure-oidc-provider

Due to the way this is implemented by both CircleCI and OVH the job identifies as the user who initiated the current CI run. 
The format of the username (`sub` field) is ["org/ORGANIZATION_ID/project/PROJECT_ID/user/USER_ID"](https://circleci.com/docs/openid-connect-tokens/#format-of-the-openid-connect-id-token).

So for any user who should be allowed to initiate Matomo deployments, their username needs to be added to the [RoleBinding](system/rbac/rolebinding_circle-ci.yaml) by a cluser admin.

## Matomo configuration

* Matomo configuration is in [values/matomo.yaml](values/matomo.yaml).
* Secrets configuration is generated from [values/secrets.yaml.tpl](values/secrets.yaml.tpl).  The `MATOMO_MYSQL_PASS` and DATABASE_ ssl environment variable will be replaced by the password configured in the CircleCI context `matomo` on deployment.

SSL certificates for encrypted communication with MySQL have been created with [Ansible](https://bitbucket.org/ramsalt/ansible-playbooks/src/master/roles/_local.small_ca).

# Secrets

Secrets are created by helmfile in a systems deployment (see above).
Secrets are gpg encrypted with sops. If the gpg key for decryption is not available, the easiest solution is to re-create the secrets in their respective systems and update the secrets files accordingly.

## Cloudflare access token for External-DNS

External-DNS needs this token to be able to update records in Cloudflare.

file: `system/secrets/external-dns.yaml`

```yaml
cloudflareToken: <TOKEN>
# vim: sw=2 ts=2 syntax=yaml
```

## GitHub container registry username and token

As our matomo container image contains paid plugins it cannot be made publically available. So a username and token with access to the package in ghcr is needed.
(See [Creating a personal access token](https://docs.github.com/en/authentication/keeping-your-account-and-data-secure/creating-a-personal-access-token))

file: `system/secrets/ghcr-token.yaml`

```yaml
ghcr:
    user: <USERNAME>
    token: <TOKEN>
# vim: sw=2 ts=2 syntax=yaml
```
