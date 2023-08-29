# Matomo k8s cluster system configuration

The files in this directory configure global cluster settings needed for [Matomo](../).

Run helmfile to apply the changes. For requirements see the [helmfile documentation](https://github.com/helmfile/helmfile):

```
helmfile apply
```

> ***Note:** changes in `namespaces` and `rbac` are not managed by helmfile and need to be applied with the usual `kubectl apply -f`
