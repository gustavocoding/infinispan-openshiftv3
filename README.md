Infinispan on OpenShift v3 Demo
===============================

Sample of running infinispan server on OpenShift v3

Requirements:

* Docker

* Vagrant

* VirtualBox

* Golang - on Fedora, run ```yum install golang```

### Clone Openshift v3 from master 

```
git clone https://github.com/openshift/origin.git openshift-origin
```

Build:

```
cd openshift-origin && hack/build-go.sh && cp _output/local/go/bin/openshift /usr/bin/

```

### Creating the cluster

```
export OPENSHIFT_DEV_CLUSTER=true
export OPENSHIFT_NUM_MINIONS=3
vagrant up
```

After a while, there should be 4 VirtualBoxes instances running, one master plus three minions:

```
$ vagrant status
Current machine states:

master                    running (virtualbox)
minion-1                  running (virtualbox)
minion-2                  running (virtualbox)
minion-3                  running (virtualbox)
```

### Deploy Infinispan template

To be able to interact with Kubernates from outside VirtualBox:

```
export KUBECONFIG=kubeconfig/.kubeconfig
```

To deploy 2 infinispan-server pods plus one jgroups gossip pod:

```
./apply-templates.sh
```

To follow the status of the instantiation:

```
$ openshift kube get pods

POD                               IP                  CONTAINER(S)        IMAGE(S)                         HOST                            LABELS                              STATUS
infinispan-controller-mlgdy       10.1.1.2            infinispan-node     gustavonalle/infinispan-server   openshift-minion-2/10.245.2.4   name=infinispan-pod,template=ispn   Running
infinispan-controller-muvca       10.1.0.2            infinispan-node     gustavonalle/infinispan-server   openshift-minion-1/10.245.2.3   name=infinispan-pod,template=ispn   Running
jgroups-gossip-controller-6atuv   10.1.0.3            jgroups-gossip      gustavonalle/jgroups-gossip      openshift-minion-1/10.245.2.3   name=gossip,template=ispn           Running

```

It can take some time to install it given that OpenShift will need to grab the docker images to start containers on each minion.

### Checking the cluster status

To verify that clustering is working as expected, login in via ssh to one of the minions where the infinispan-server is running:

```
vagrant ssh minion-1
```

And obtain the id of the Infinispan server:

```
docker ps | grep infinispan
```


Then to connect to a running container:

```
# Replace 123 for the first letters of the id
docker exec -ti 123 bash
```

Inspect via cli the cluster state:

```
cd infinispan-server/bin
chmod +x jboss-cli.sh
./jboss-cli.sh --connect
[standalone@localhost:9990 /] cd subsystem=infinispan/cache-container=clustered/
[standalone@localhost:9990 cache-container=clustered] read-attribute members
```

### Increasing the number of nodes

To increase the infinispan cluster size, say, to 4 nodes:

```
openshift kube resize --replicas=4 replicationcontrollers infinispan-controller
```
