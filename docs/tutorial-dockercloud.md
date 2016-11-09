---
layout: docs
title: Reflex Docker Cloud TUTORIAL
permalink: /docs/tutorial-dockercloud/
---

This Tutorial walks through the process of using the Reflex Engine in Docker Cloud.

Assumptions:

* You understand Docker and Linux.
* You have a [Docker Cloud](https://cloud.docker.com/) cluster already functioning.
* You have a MariaDB running and available connectable to your Docker Cloud instance.

The steps of this extended demo are:

1. Add Reflex Tools to your service Container (for this example we use hello world).
2. Create a Reflex Engine Stack in Docker Cloud
3. Define your Service in Docker Cloud

# Add Reflex Tools to your Container

This step will vary based on the type of container you use.  The simplest approach is to load your container and run the [Easy Install](/docs/install/#easy-install).  For this example, we will extend an existing container--however, these same steps can be embedded in your original Dockerfile.

{% highlight dockerfile %}
FROM dockercloud/helloworld

# so it will load dependencies
RUN apk add --no-cache python3 libffi openssl
RUN apk add --no-cache --virtual .build-deps \
        bash curl tar gcc libc-dev libffi-dev \
        linux-headers make python3-dev
# the actual reflex command
RUN pip3 install rfx rfxcmd
# cleanup unneeded dependencies
RUN apk del .build-deps && rm -rf ~/.cache

ENTRYPOINT ["/usr/bin/launch"]
{% endhighlight %}

## Setup the service in Reflex Engine

## Launch the container

Other Tutorials:

* [Reflex Services](/docs/tutorial-services/)
* [Linking Pipelines](/docs/tutorial-pipeline/)
