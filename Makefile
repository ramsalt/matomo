MATOMO_VERSION="4.9"
WODBY_TAG="1.42.2"

.PHONY: build
build:
	@docker build --build-arg=LICENSE_KEY=$(LICENSE_KEY) -t ramsalt/matomo:$(MATOMO_VERSION)-local .
