NAME=camptocamp/odoo-project
ifndef VERSION
$(error VERSION is not set)
endif

IMAGE=$(NAME):$(VERSION)
ifeq ($(BATTERIES), True)
  $TAG=$(TAG)-batteries
  IMAGE_LATEST=$(IMAGE)-latest-batteries
  DOCKERFILE=Dockerfile-batteries
else
  IMAGE_LATEST=$(IMAGE)-latest
  DOCKERFILE=Dockerfile
endif

export

all: build


.PHONY: build
build:
	bash build.sh


.PHONY: tag
tag:
	docker tag $(IMAGE_LATEST) $(IMAGE)-$(TAG)
	docker tag $(IMAGE_LATEST)-onbuild $(IMAGE)-$(TAG)-onbuild


.PHONY: push
push:
	docker push $(IMAGE)-$(TAG)
	docker push $(IMAGE)-$(TAG)-onbuild


.PHONY: tag_latest_main
tag_latest_main:
	docker tag $(IMAGE_LATEST) $(NAME):latest
	docker tag $(IMAGE_LATEST)-onbuild $(NAME)-onbuild:latest


.PHONY: push_latest_main
push_latest_main:
	docker push $(NAME):latest
	docker push $(NAME)-onbuild:latest


.PHONY: test
test:
	bash test.sh
