ifndef VERSION
VERSION=15.0
endif

IMAGE_LATEST=ci-5xx-latest:${VERSION}
BUILD_TAG=$(IMAGE_LATEST)

export

.PHONY: all
all:
	bash build.sh

.PHONY: setup
setup:
	bash setup.sh


.PHONY: test
test:
	bash test.sh
