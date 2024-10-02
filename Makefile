#Makefile for Helm Operations
REPO ?= unstructured-api
GIT_TAG = $(shell git describe --tags $(git rev-list --tags --max-count=1) | sed s/v//g)
VERSION ?= $(shell cat ${REPO}/Chart.yaml | grep "version:" | awk -F': ' '{print $$2}')
NEXT_VERSION ?= $(shell echo ${VERSION} | awk -F. -v OFS=. '{$$NF += 1 ; print}')

package: ## Packages the helm chart
	helm package charts/${REPO} --destination charts/

.PHONY: package

index: ## Packages the helm chart
	Helm repo index --url https://kkacsh321.github.io/unstructured-api-helm-chart .  

.PHONY: package

push: ## Pushes helm chart to ECR
	helm push ${REPO}-${VERSION}.tgz oci://${REGISTRY}/

.PHONY: push

template: ## Runs helm template with default values
	helm template charts/${REPO}

.PHONY: template

template-test: ## Runs helm template with default values
	helm template charts/${REPO} -f test-values.yaml

.PHONY: template

lint: ## Runs helm lint
	helm lint charts/${REPO}

.PHONY: lint

check-version: ## Checks for the required version bump
	@echo "\033[36m"Checking Version"\033[0m"; \
	if [ "${GIT_TAG}" == "${VERSION}" ]; then \
	echo "\033[0;31mVersion is equal to current tag ${VERSION}, please update it!\033[0m"; \
	else \
	echo "\033[0;32mVersion is not equal to current tag ${VERSION}, good to go\033[0m"; \
	fi
	@echo "\033[36m"Version Check Complete"\033[0m"
.PHONY: check-version

bump-version: ## bump minor version
	@echo "Current version in repo is \033[0;31m${VERSION}\033[0m"; \
	echo "New version will be \033[0;32m${NEXT_VERSION}\033[0m"; \
	sed 's/'${VERSION}'/'${NEXT_VERSION}'/g' ./charts/${REPO}/Chart.yaml > Chart.tmp; \
	rm ./cahrts/${REPO}/Chart.yaml; \
	mv Chart.tmp ./charts/${REPO}/Chart.yaml; \
	echo "Version now set to \033[36m${NEXT_VERSION}\033[0m"
.PHONY: bump-version

version: ## Prints Current Version
	@echo "Current version in repo is \033[0;31m${VERSION}\033[0m"
.PHONY: version

prepare-pr: lint check-version package index ## Runs helm lint, and version check for before your PR
	@echo "\033[36m"Done Running PR Checks"\033[0m"
.PHONY: prepare-pr

help: ## show this usage
	@echo "\033[36mHelm Makefile:\033[0m\nUsage: make [command]\n"; \
	grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

.PHONY: help

.DEFAULT_GOAL := help