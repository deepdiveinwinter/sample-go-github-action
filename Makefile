export GO111MODULE=on

DOORAY_BOOT_IMAGE_NAME="deepdiveinwinter/dooraybot"
DOORAY_BOOT_IMAGE_VERSION="v1.0"
DOORAY_HOOK_URL="https://hook.dooray.com/services/{{SERVICE_HOOK}}"

.PHONY: build-image
build-image:
	@echo "Build dooray-bot image..."
	@docker build -t ${DOORAY_BOOT_IMAGE_NAME}:${DOORAY_BOOT_IMAGE_VERSION} -f ./Dockerfile .

.PHONY: push-image
push-image:
	@echo "Push dooray-bot image..."
	@docker push ${DOORAY_BOOT_IMAGE_NAME}:${DOORAY_BOOT_IMAGE_VERSION}

.PHONY: run
run: clean
	@echo "Run dooray-bot container..."
	@docker run -d -e DOORAY_HOOK_URL=${DOORAY_HOOK_URL} --name dooray-bot ${DOORAY_BOOT_IMAGE_NAME}:${DOORAY_BOOT_IMAGE_VERSION}

.PHONY: clean
clean:
	@echo "Clean  dooray-bot container..."
	@docker rm -f dooray-bot
