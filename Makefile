NAME=camptocamp/odoo-project
ifndef VERSION
$(error VERSION is not set)
endif

IMAGE=$(NAME):$(VERSION)
IMAGE_LATEST=$(IMAGE)-latest
ODOO_URL=https://github.com/odoo/odoo/archive/$(VERSION).tar.gz

all: build


.PHONY: build
build:
	$(eval TMP := $(shell mktemp -u))
	cp -r $(VERSION) $(TMP)
	cp -r bin/ $(TMP)
	docker build --no-cache -t $(IMAGE_LATEST) $(TMP)
	rm -rf $(TMP)


.PHONY: tag
tag:
	docker tag $(IMAGE_LATEST) $(IMAGE)-$(TAG)


.PHONY: push
push:
	docker push $(IMAGE)-$(TAG)


.PHONY: tag_latest_main
tag_latest_main:
	docker tag $(IMAGE_LATEST) $(NAME):latest


.PHONY: push_latest_main
push_latest_main:
	docker push $(NAME):latest


.PHONY: test
test:
	$(eval TMP := $(shell mktemp -u))
	cp -r example $(TMP)
	rm -rf $(TMP)/odoo/src
	wget -nv -O /tmp/odoo.tar.gz $(ODOO_URL)
	tar xfz /tmp/odoo.tar.gz -C $(TMP)/odoo/
	mv $(TMP)/odoo/odoo-$(VERSION) $(TMP)/odoo/src
	sed 's|FROM .*|FROM $(IMAGE_LATEST)|' -i $(TMP)/odoo/Dockerfile
	cat $(TMP)/odoo/Dockerfile
	cd $(TMP) && docker-compose run --rm -e LOCAL_USER_ID=$(shell id -u) odoo odoo --stop-after-init
	cd $(TMP) && docker-compose down
	rm -f /tmp/odoo.tar.gz
	rm -rf $(TMP)
