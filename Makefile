NAME=robertredcor/odoo-project
ifndef VERSION
$(error VERSION is not set)
endif

IMAGE=$(NAME):$(VERSION)
IMAGE_LATEST=$(IMAGE)-latest

export

all: build


.PHONY: build
build:
	bash build.sh


.PHONY: tag
tag:
	docker tag $(IMAGE_LATEST) $(IMAGE)-$(TAG)
	docker tag $(IMAGE_LATEST)-onbuild $(IMAGE)-$(TAG)-onbuild
	docker tag $(IMAGE_LATEST)-batteries $(IMAGE)-$(TAG)-batteries
	docker tag $(IMAGE_LATEST)-batteries-onbuild $(IMAGE)-$(TAG)-batteries-onbuild


.PHONY: push
push:
	docker push $(IMAGE)-$(TAG)
	docker push $(IMAGE)-$(TAG)-onbuild
	docker push $(IMAGE)-$(TAG)-batteries
	docker push $(IMAGE)-$(TAG)-batteries-onbuild


.PHONY: tag_latest_main
tag_latest_main:
	docker tag $(IMAGE_LATEST) $(NAME):latest
	docker tag $(IMAGE_LATEST)-onbuild $(NAME):latest-onbuild
	docker tag $(IMAGE_LATEST)-batteries $(NAME):latest-batteries
	docker tag $(IMAGE_LATEST)-batteries-onbuild $(NAME):latest-batteries-onbuild


.PHONY: push_latest_main
push_latest_main:
	docker push $(NAME):latest
	docker push $(NAME):latest-onbuild
	docker push $(NAME):latest-batteries
	docker push $(NAME):latest-batteries-onbuild


.PHONY: test
test:
	bash test.sh
