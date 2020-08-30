export GO111MODULE=on

DOORAY_HOOK_URL="https://hook.dooray.com/services/{{SERVICE_HOOK}}"

.PHONY: build-image
build-image:
	@echo "Build dooray-bot image..."
	docker build -t deepdiveinwinter/dooraybot:v1.0 -f ./Dockerfile .

.PHONY: push-image
push-image:
	@echo "Push dooray-bot image..."
	docker push deepdiveinwinter/dooraybot:v1.0

.PHONY: run
run: clean
	@echo "Run dooray-bot container..."
	@docker run -d -e DOORAY_HOOK_URL=${DOORAY_HOOK_URL} --name dooray-bot deepdiveinwinter/dooraybot:v1.0

.PHONY: clean
clean:
	@echo "Clean  dooray-bot container..."
	@docker rm -f dooray-bot
