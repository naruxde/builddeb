FROM arm64v8/debian:bullseye

ARG DEBIAN_FRONTEND=noninteractive

# Needed to add apt key
RUN apt-get update \
&& apt-get -y install \
	gnupg

ADD "https://raw.githubusercontent.com/RevolutionPi/imagebakery/4081bdde108259e97b04b50b7afbd50b23908a56/templates/revpi.list" etc/apt/sources.list.d/revpi.list
ADD "https://github.com/RevolutionPi/imagebakery/raw/master/templates/revpi.gpg" revpi.gpg
RUN apt-key add revpi.gpg \
&& rm revpi.gpg

# install build basics
RUN apt-get dist-upgrade -y \
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

RUN install -d /work
RUN install -d -m 0700 /root/gnupg

COPY ./run.sh /
CMD ["/run.sh"]
