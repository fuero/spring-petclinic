# vim: set filetype=make noet :
SHELL := bash
.SHELLFLAGS := -eua -o pipefail -c
.ONESHELL:
.DELETE_ON_ERROR:
MAKEFLAGS += --warn-undefined-variables
MAKEFLAGS += --no-builtin-rules

.PHONY: help
help: # see https://diamantidis.github.io/tips/2020/07/01/list-makefile-targets
	@grep -hE '^[a-zA-Z0-9_.-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| sed -n 's/^\(.*\): \(.*\)##\(.*\)/\1|\3/p' \
	| column -t  -s '|'

.PHONY: all
all: clean app

.PHONY: clean
clean: ## Clean up
	mvn clean

.PHONY: update
update: ## Updates pom file to current versions
	mvn versions:update-properties -DallowMajorUpdates=true -DallowMinorUpdates=true
	mvn versions:display-plugin-updates -DallowMajorUpdates=true -DallowMinorUpdates=true

.PHONY: app
app: ## Builds java app and Container
	mvn -DskipTests=true package
	buildah bud -t petclinic-otel:latest .
