KIND_CLUSTER_NAME := "kind"
GOPATH = ${HOME}/go/bin

.PHONY: kust-install
kust-install: 
	curl -LO https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv3.5.4/kustomize_v3.5.4_linux_amd64.tar.gz && \
	tar zxvf kustomize_v3.5.4_linux_amd64.tar.gz && mv kustomize $(GOPATH)/

.PHONY: kust-ensure 
kust-ensure: 
	@which $(GOPATH)/kustomize >/dev/null 2>&1 || \
		make kust-install

.PHONY: kustomize
kustomize: kust-ensure 
	@cd manifests/base/ && $(GOPATH)/kustomize edit set image $(DOCKERID)/meshnet:$(VERSION)
	kubectl apply --kubeconfig /etc/rancher/k3s/k3s.yaml -k manifests/base/

.PHONY: kustomize-kops
kustomize-kops: kust-ensure 
	kubectl apply -k manifests/overlays/kops/ 