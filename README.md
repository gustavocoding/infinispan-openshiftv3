Infinispan on OpenShift v3 Demo
===============================

Sample of running infinispan server on OpenShift v3

Requirements:

* Docker

* Golang. On Fedora, run ```yum install golang```

### Running OpenShift v3 from the sources

```
git clone https://github.com/openshift/origin.git openshift-origin
```

in folder ```openshift-origin```, compile the sources:


```
hack/build-go.sh 
```

If necessary, to clear a previous run: ```./examples/sample-app/cleanup.sh```

After compilation, start OpenShift 'all-in-one'. It will start all cluster-level and node-level services:
```
_output/local/go/bin/openshift start
```

### Creating the infinispan server pod

```
<OPENSHIFT_HOME>/_output/local/go/bin/openshift kubectl create -f infinispan-pod.json
```

The server console can be seen on ```http://localhost:8888/```

### Inspecting via API

The pod details can be seen acessing the Kubernetes API, for example: ```curl http://localhost:8080/api/v1beta2/pods```


### Creating a cluster


