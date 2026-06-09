ifndef VERSION
$(error VERSION is not set)
endif
ifndef IMAGE_LATEST
IMAGE_LATEST=ci-latest:${VERSION}
endif
BUILD_TAG=$(IMAGE_LATEST)

export

all: build

.PHONY: setup
setup:
	bash setup.sh

.PHONY: build
build:
	bash build.sh

.PHONY: test
test:
	bash test.sh
