.DEFAULT_GOAL := test-ci

TAG:=$(shell git rev-parse --short HEAD)
ENVIRONMENT:=tmp/environment

$(ENVIRONMENT): docker-compose.yml
	docker-compose build
	docker-compose up -d mongodb redis http
	mkdir -p $(@D)
	touch $@

.PHONY: test-bin
test-bin: $(ENVIRONMENT)
	docker-compose run --rm await bats test/await_test.bats

.PHONY: test-lint
test-lint:
	docker run --rm -v $(CURDIR):/data:ro -w /data nlknguyen/alpine-shellcheck \
		bin/await

.PHONY: test-ci
test-ci: test-lint test-bin

.PHONY: clean
clean: 
	docker-compose down
	rm -rf $(ENVIRONMENT)
