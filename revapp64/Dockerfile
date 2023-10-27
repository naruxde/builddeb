FROM arm64v8/python:buster

ARG DEBIAN_FRONTEND=noninteractive

# install build basics
RUN apt-get update \
&& apt-get dist-upgrade -y \
&& apt-get -y install \
	apt-utils \
	build-essential \
	fakeroot \
	devscripts \
	equivs \
	git-buildpackage \
	eatmydata \
&& apt-get clean \
&& rm -rf /var/lib/apt/lists/*

# Install latest rust environment
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs --output rustup.sh \
&& sh rustup.sh -y

RUN install -d /work
RUN install -d -m 0700 /root/gnupg

COPY ./run.sh /
CMD ["/run.sh"]
