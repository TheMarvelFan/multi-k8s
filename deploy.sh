docker build -t themarvelfan616/multi-client-k8s:latest -t themarvelfan616/multi-client-k8s:$SHA -f ./client/Dockerfile ./client
docker build -t themarvelfan616/multi-server-k8s:latest -t themarvelfan616/multi-server-k8s:$SHA -f ./server/Dockerfile ./server
docker build -t themarvelfan616/multi-worker-k8s:latest -t themarvelfan616/multi-worker-k8s:$SHA -f ./worker/Dockerfile ./worker

docker push themarvelfan616/multi-client-k8s:latest
docker push themarvelfan616/multi-server-k8s:latest
docker push themarvelfan616/multi-worker-k8s:latest

docker push themarvelfan616/multi-client-k8s:$SHA
docker push themarvelfan616/multi-server-k8s:$SHA
docker push themarvelfan616/multi-worker-k8s:$SHA

kubectl apply -f k8s
kubectl set image deployments/server-deployment server=themarvelfan616/multi-server-k8s:$SHA
kubectl set image deployments/client-deployment client=themarvelfan616/multi-client-k8s:$SHA
kubectl set image deployments/worker-deployment worker=themarvelfan616/multi-worker-k8s:$SHA


# Without any way to identify the latest version of the image, it becomes the same problem as it was locally.
# kubectl will not detect any changes and hence will not rebuild
# It is tedious to add build version number each time when rebuilding
# Whenever we commit to git, a GIT_SHA is assigned to represent the HEAD. This position defines the most latest commit in the git repo
# This is always unique as each commit must be recognized with a unique identity
# So, it is very sensible to recognize image build versions using GIT_SHA
# Using helm to install nginx ingress inside the GKE container as Helm is used to install 3rd party applications inside container
