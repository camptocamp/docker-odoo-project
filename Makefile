NAME=camptocamp/odoo-project
ifndef VERSION
$(error VERSION is not set)
endif

ifeq ($(FULL), True)
  IMAGE=$(NAME):$(VERSION)-full
  DOCKERFILE='Dockerfile-full'
else
  IMAGE=$(NAME):$(VERSION)
  DOCKERFILE='Dockerfile'
endif
IMAGE_LATEST=$(IMAGE)-latest
ODOO_URL=https://github.com/odoo/odoo/archive/$(VERSION).tar.gz

all: build


.PHONY: build
build:
	$(eval TMP := $(shell mktemp -u))
	cp -r $(VERSION) $(TMP)
	cp -r bin/ $(TMP)
	cp -r common/* $(TMP)
	sed -i "1i FROM $(IMAGE_LATEST)" $(TMP)/Dockerfile-onbuild
	sed -i "1i FROM $(NAME):$(VERSION)-latest" $(TMP)/Dockerfile-full
	cp -r install/ $(TMP)
	cp -r start-entrypoint.d/ $(TMP)
	cp -r before-migrate-entrypoint.d/ $(TMP)
	docker build --no-cache -f $(TMP)/$(DOCKERFILE) -t $(IMAGE_LATEST) $(TMP)
	docker build --no-cache -f $(TMP)/Dockerfile-onbuild -t $(IMAGE_LATEST)-onbuild $(TMP)
	rm -rf $(TMP)


.PHONY: tag
tag:
	docker tag $(IMAGE_LATEST) $(IMAGE)-$(TAG)
	docker tag $(IMAGE_LATEST)-onbuild $(IMAGE)-onbuild-$(TAG)


.PHONY: push
push:
	docker push $(IMAGE)-$(TAG)
	docker push $(IMAGE)-onbuild-$(TAG)


.PHONY: tag_latest_main
tag_latest_main:
	docker tag $(IMAGE_LATEST) $(NAME):latest
	docker tag $(IMAGE_LATEST) $(NAME)-onbuild:latest


.PHONY: push_latest_main
push_latest_main:
	docker push $(NAME):latest
	docker push $(NAME)-onbuild:latest


.PHONY: test
test:
	$(eval TMP := $(shell mktemp -u))
	cp -r example $(TMP)
	rm -rf $(TMP)/odoo/src
	wget -nv -O /tmp/odoo.tar.gz $(ODOO_URL)
	tar xfz /tmp/odoo.tar.gz -C $(TMP)/odoo/
	mv $(TMP)/odoo/odoo-$(VERSION) $(TMP)/odoo/src
	sed 's|FROM .*|FROM $(IMAGE_LATEST)-onbuild|' -i $(TMP)/odoo/Dockerfile
	cat $(TMP)/odoo/Dockerfile
	cd $(TMP) && docker-compose -f docker-compose.yml run --rm -e LOCAL_USER_ID=$(shell id -u) odoo odoo --stop-after-init
	cd $(TMP) && docker-compose -f docker-compose.yml run --rm -e LOCAL_USER_ID=$(shell id -u) odoo runtests
	cd $(TMP) && docker-compose -f docker-compose.yml down
	rm -f /tmp/odoo.tar.gz
	rm -rf $(TMP)
