NAME=camptocamp/odoo-project
ifndef VERSION
$(error VERSION is not set)
endif

ifeq ($(TARGET), "GHCR" ]
    NAME=ghcr.io/$(NAME)
endif

IMAGE=$(NAME):$(VERSION)
IMAGE_LATEST=$(IMAGE)-latest
BUILD_TAG=$(IMAGE_LATEST)

export

all: build


.PHONY: build
build:
	bash build.sh


.PHONY: tag
tag:
	docker tag $(BUILD_TAG) $(IMAGE)-$(TAG)
	docker tag $(BUILD_TAG)-onbuild $(IMAGE)-$(TAG)-onbuild
	docker tag $(BUILD_TAG)-batteries $(IMAGE)-$(TAG)-batteries
	docker tag $(BUILD_TAG)-batteries-onbuild $(IMAGE)-$(TAG)-batteries-onbuild


.PHONY: push
push:
	docker push $(IMAGE)-$(TAG)
	docker push $(IMAGE)-$(TAG)-onbuild
	docker push $(IMAGE)-$(TAG)-batteries
	docker push $(IMAGE)-$(TAG)-batteries-onbuild


.PHONY: tag_latest_main
tag_latest_main:
	docker tag $(BUILD_TAG) $(NAME):latest
	docker tag $(BUILD_TAG)-onbuild $(NAME):latest-onbuild
	docker tag $(BUILD_TAG)-batteries $(NAME):latest-batteries
	docker tag $(BUILD_TAG)-batteries-onbuild $(NAME):latest-batteries-onbuild


.PHONY: push_latest_main
push_latest_main:
	docker push $(NAME):latest
	docker push $(NAME):latest-onbuild
	docker push $(NAME):latest-batteries
	docker push $(NAME):latest-batteries-onbuild


.PHONY: test
test:
	bash test.sh
