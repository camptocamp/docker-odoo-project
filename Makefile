ifndef VERSION
$(error VERSION is not set)
endif

IMAGE_LATEST=ci-4xx-latest:${VERSION}
BUILD_TAG=$(IMAGE_LATEST)

export

all: build

.PHONY: setup
setup:
	bash setup.sh


.PHONY: test
test:
	bash test.sh
