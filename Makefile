IMAGE=choffmeister/ci
TAG=1.0.0

build:
	docker build --pull -t $(IMAGE):$(TAG) -f Dockerfile .

versions: build
	docker run --rm -it --entrypoint git $(IMAGE):$(TAG) --version
	docker run --rm -it --entrypoint docker $(IMAGE):$(TAG) --version
	docker run --rm -it --entrypoint java $(IMAGE):$(TAG) -version
	docker run --rm -it --entrypoint scala $(IMAGE):$(TAG) -version
	docker run --rm -it --entrypoint sbt $(IMAGE):$(TAG) sbtVersion
	docker run --rm -it --entrypoint node $(IMAGE):$(TAG) --version
	docker run --rm -it --entrypoint npm $(IMAGE):$(TAG) --version
	docker run --rm -it --entrypoint yarn $(IMAGE):$(TAG) --version

push: build
	docker push $(IMAGE):$(TAG)
	docker tag $(IMAGE):$(TAG) $(IMAGE):latest
	docker push $(IMAGE):latest
