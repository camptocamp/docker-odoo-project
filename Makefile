ifndef VERSION
$(error VERSION is not set)
endif

ifeq ($(TARGET), GHCR)
    NAME=ghcr.io/camptocamp/odoo-project
else
    NAME=camptocamp/odoo-project
endif

IMAGE=$(NAME):$(VERSION)
IMAGE_LATEST=$(IMAGE)-latest
BUILD_TAG=$(IMAGE_LATEST)

export

all: build

.PHONY: setup
setup:
	bash setup.sh

.PHONY: build
build:
	bash build.sh

.PHONY: tag
tag:
	docker tag $(BUILD_TAG) $(IMAGE)-$(TAG)


.PHONY: push
push:
	docker push $(IMAGE)-$(TAG)


.PHONY: tag_latest_main
tag_latest_main:
	docker tag $(BUILD_TAG) $(NAME):latest


.PHONY: push_latest_main
push_latest_main:
	docker push $(NAME):latest


.PHONY: test
test:
	bash test.sh
