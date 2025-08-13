# QLC+ Art-Net to DMX Converter
This is a container for QLC+ software. It converts Art-Net to DMX signals. It is based on Debian 13 trixie.  

## How to use
### Docker/Podman
Start the container:
```bash
$ podman run -p 9999:9999 --privileged --name qlcplus ghcr.io/technotut/qlcplus-artnet-to-dmx-converter:main
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
        image: ghcr.io/technotut/qlcplus-artnet-to-dmx-converter:main
        securityContext:
          privileged: true
        ports:
        - containerPort: 7000
        - containerPort: 9999
        volumeMounts:
        - name: qlcplus-hostpath
          mountPath: /dev/ttyUSB0
      volumes:
      - name: qlcplus-hostpath
        hostPath:
          path: /dev/ttyUSB0
```

Create a service:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: qlcplus
  namespace: qlcplus
spec:
  selector:
    app: qlcplus
  type: LoadBalancer
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

Apply the configuration:
```bash
$ kubectl apply -f <your-deployment-file>.yaml
$ kubectl apply -f <your-service-file>.yaml
```

Check the status of the deployment and service:
```bash
$ kubectl get deployment -n qlcplus
$ kubectl get svc -n qlcplus
```

Access the Web UI at `http://<SERVICE_IP>`.

## Setup
On Web UI, open the "Configuration". Configure Universe 1.  
- Input: [Art-Net] 10.xx.xx.xx
- Output: [DMX USB] FT232R USB UART (S/N: ********)
- Check "Passthrough" 

After configuring, send Art-Net signals to server or loadbalancer.