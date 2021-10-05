FROM praqma/network-multitool:extra

RUN apk update \
	&& apk add \
	python3 \
	py3-pip

RUN pip3 install --no-cache-dir ipython scapy
