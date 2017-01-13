FROM ppc64le/ubuntu:16.04
MAINTAINER Tom Denham <tom@projectcalico.org>
ADD dist/libnetwork-plugin /libnetwork-plugin
ENTRYPOINT ["/libnetwork-plugin"]

