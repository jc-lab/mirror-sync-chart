#!/bin/bash

set -e

HELM_COMMAND_DEF=$(which helm3 || echo microk8s.helm3)

DOCKER_REGISTRY=${DOCKER_REGISTRY:-localhost:32000}
HELM_COMMAND=${HELM_COMMAND:-${HELM_COMMAND_DEF}}
NAMESPACE=${NAMESPACE:-default}
RELEASE_NAME=${RELEASE_NAME:-mirror}

(cd image && \
	docker build --tag=${DOCKER_REGISTRY}/jc-lab/mirror-server:latest . -f server.Dockerfile && \
	docker build --tag=${DOCKER_REGISTRY}/jc-lab/mirror-syncer:latest . -f syncer.Dockerfile && \
	docker push ${DOCKER_REGISTRY}/jc-lab/mirror-server:latest && \
	docker push ${DOCKER_REGISTRY}/jc-lab/mirror-syncer:latest
)

[ -e updater ] || ssh-keygen -m PEM -t ecdsa -f updater -N ""

${HELM_COMMAND} -n ${NAMESPACE} delete ${RELEASE_NAME} 2>/dev/null || true
(cd chart && \
	${HELM_COMMAND} -n ${NAMESPACE} install ${RELEASE_NAME} . -f values.yaml --set updater.sshPrivateKey="$(cat ../updater)" --set updater.sshPublicKey="$(cat ../updater.pub)" --set server.image.registry="${DOCKER_REGISTRY}" --set syncer.image.registry="${DOCKER_REGISTRY}")

