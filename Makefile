SHELL: /bin/bash

build:
	docker build . -f Containerfile -t code.kevinisageek.org/kevin/mastobackup
# :${git rev-parse --short HEAD}

push:
	docker image push code.kevinisageek.org/kevin/mastobackup
#:${git rev-parse --short HEAD}

.PHONY: build upload