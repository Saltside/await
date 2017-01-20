.DEFAULT_GOAL := test-ci

REPO := saltside/await

# Version
VERSION := 0.1.0
MAJOR   := $(word 1, $(subst ., ,$(VERSION)))
MINOR   := $(word 2, $(subst ., ,$(VERSION)))

BIN_FILES := $(wildcard bin/*)
TEST_FILES := $(wildcard test/*.bats)

ENVIRONMENT := tmp/environment

$(ENVIRONMENT): docker-compose.yml Dockerfile
$(ENVIRONMENT): $(BIN_FILES) $(TEST_FILES)
	docker-compose build
	docker-compose up -d mongodb redis http dynamodb mysql memcached
	mkdir -p $(@D)
	touch $@

.PHONY: build
build: $(ENVIRONMENT)

.PHONY: test-bin
test-bin: build
	docker-compose run --rm await bats $(TEST_FILES)

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

.PHONY: push
push:
	docker build -f Dockerfile -t $(REPO):$(VERSION) .
	docker tag $(REPO):$(VERSION) latest
	docker tag $(REPO):$(VERSION) $(REPO):$(MAJOR)
	docker tag $(REPO):$(VERSION) $(REPO):$(MAJOR).$(MINOR)
	docker push $(REPO)
