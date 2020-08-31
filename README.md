# Dooray Messenger Bot Client

Dooray Incoming Hook을 사용해 Dooray Bot이 메세지를 보내도록 할 수 있습니다.

일정한 주기로 반복적으로 보내야하는 공지사항 발송을 자동화하기 위해 만들어졌습니다.
 
## 개발 환경 구성
* Go 1.13.14
* docker-ce 19.03.12

## 로컬 개발 환경에서 실행하는 방법

Makefile에 DOORAY_HOOK_URL 값을 수정한다.
```
DOORAY_HOOK_URL="https://hook.dooray.com/services/{{SERVICE_HOOK}"
```

make 명령어를 사용해 docker 이미지를 빌드한다.
```
make build-image
```

빌드된 이미지를 기반으로 컨테이너를 생성해 메세지를 발송한다.

만약 dooray-bot이라는 이름의 컨테이너가 기존에 존재할 경우, 해당 컨테이너를 자동 삭제하고 재생성한다.
```
make run
```

컨테이너를 통해 Dooray bot 메세지가 정상적으로 도착했다면, 해당 이미지를 Docker Hub에 등록한다.
```
make push-image
```

## Kubernetes 개발 환경에서 실행하는 방법

dooray-bot  컨테이너 이미지를 Job 또는 CronJob으로 등록해 메세지를 보낸다.

예제) 매 주 월요일 오전 10시에 특정 메세지를 발송하도록 CronJob 등록

```yaml
apiVersion: batch/v1beta1
kind: CronJob
metadata:
  name: dooray-bot
spec:
  schedule: "0 10 * * 1"
  jobTemplate:
    spec:
      template:
        spec:
          containers:
            - name: dooray-bot
              image: deepdiveinwinter/dooraybot:{version}
              env:
                - name: DOORAY_HOOK_URL
                  value: https://hook.dooray.com/services/{{SERVICE_HOOK}
          restartPolicy: OnFailure
```
