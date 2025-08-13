# QLC+ Art-Net to DMX Converter
This is a container for QLC+ software. It converts Art-Net to DMX signals. It is based on Debian 13 trixie.  

## How to use
### Docker/Podman
Start the container:
```bash
$ podman run -p 9999:9999 --name qlcplus ghcr.io/TechnoTUT/qlcplus-artnet-to-dmx-converter
```
Connect to the Web UI at `http://<SERVER_IP>:9999`.  

Stop the container:
```bash
$ podman stop qlcplus
```

Remove the container:
```bash
$ podman rm qlcplus
```

### Kubernetes
Create a deployment:
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: qlcplus
  namespace: qlcplus
spec:
  replicas: 1
  selector:
    matchLabels:
      app: qlcplus
  template:
    metadata:
      labels:
        app: qlcplus
    spec:
      containers:
      - name: qlcplus
        image: ghcr.io/TechnoTUT/qlcplus-artnet-to-dmx-converter
        ports:
        - containerPort: 7000
        - containerPort: 9999
        restartPolicy: Always
```

Create a service:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: qlcplus
  namespace: qlcplus
  annotations:
    external-dns.alpha.kubernetes.io/hostname: qlcplus.kube.technotut.net
spec:
  selector:
    app: qlcplus
  type: LoadBalancer
  loadBalancerIP: 10.33.31.1
  ports:
  - name: osc
    protocol: UDP
    port: 7000
    targetPort: 7000
  - name: http
    protocol: TCP
    port: 80
    targetPort: 9999
```

Create a HostPath Volume
```yaml
apiVersion: v1
kind: Pod
metadata:
  name: qlcplus-hostpath
spec:
  containers:
  - name: qlcplus
    securityContext:
      privileged: true
    volumeMounts:
    - name: qlcplus-hostpath
      mountPath: /dev/ttyUSB0
  volumes:
  - name: qlcplus-hostpath
    hostPath:
      path: /dev/ttyUSB0
```