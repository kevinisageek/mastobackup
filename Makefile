all:
	docker build . -f Containerfile -t code.kevinisageek.org/kevin/mastobackup
	docker image push code.kevinisageek.org/kevin/mastobackup
#:${git rev-parse --short HEAD}
