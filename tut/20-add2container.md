---
layout: tutorial
title: Add Reflex Tools to your Dockerfile TUTORIAL
permalink: /tut/add2container/
---

This Tutorial walks through the process of adding Reflex Tools to your existing container.

Assumptions:

* You understand Docker and Linux.

The steps of this extended demo are:

This step will vary based on the type of container you use.  The simplest approach is to load your container and run the [Easy Install](/docs/install/#easy-install). 

# Alpine Linux

To add to Alpine Linux include:

{% highlight dockerfile %}
RUN apk add --no-cache libffi openssl python3

RUN apk add --no-cache --virtual .build-deps \
        bash curl tar gcc libc-dev libffi-dev \
        linux-headers make python3-dev

# the actual reflex command
RUN pip3 --no-cache-dir install rfxcmd
RUN rm -rf ~/.pip/cache $PWD/build/

RUN apk del .build-deps && rm -rf ~/.cache

ENTRYPOINT ["/usr/bin/launch", "service"]
{% endhighlight %}

# CentOS 7

{% highlight dockerfile %}
FROM centos:7

# history-3
RUN yum -y install epel-release
# history-4
RUN yum -y install libffi openssl python34 mariadb mariadb-libs
# history-5
RUN yum -y install gcc gcc-c++ make curl libffi-devel python34-devel
RUN curl -O https://bootstrap.pypa.io/get-pip.py && python3 get-pip.py

RUN pip3 --no-cache-dir install -U rfxcmd
RUN rm -rf ~/.pip/cache $PWD/build/

# Undo the dev tools on history-5 for a smaller container
RUN yum -y history undo 5 ; true
RUN yum -y clean all ; true

ENTRYPOINT ["/usr/bin/launch", "service"]
{% endhighlight %}

