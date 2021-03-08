
SOURCES := $(shell find ./website -type f)

# build the webpage and deploy a container
all: docker-build

docker-build: .make/built-docker

.make/built-docker: .make/ Dockerfile Makefile ./conf/nginx.conf ${SOURCES}
	@echo "==> building docker container"
	docker build -t smangels/hugo-website .
	@touch $@


.make/:
	@mkdir -p $@

clean:
	rm -rf .make/
