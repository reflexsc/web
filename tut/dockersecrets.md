---
layout: tutorial
title: Using Docker Secrets with Reflex
permalink: /tut/dockersecrets/
---

Reflex can leverage Docker Secrets for its initial key management, which adds an additional layer of protection.

[Docker Secrets](https://docs.docker.com/engine/swarm/secrets/) are a feature of Docker Swarm -- reference the documentation at docker for a more indepth explanation.

Simply put, Reflex will first look for its key variables in the following order:

1. mapped as a Docker Secret
2. in the os environment
3. in the local config - least desireable

These variables include:

* REFLEX_APIKEY
* REFLEX_URL
* REFLEX_SERVICE

To setup docker and use secrets in this manner, start by configuring the secret:

{% highlight bash %}
echo keyname.keydata | docker secret create myservice-p1-apikey -
echo https://reflex-location.example.com/api/v1 | docker secret create reflex-url -
{% endhighlight %}

Then include in your docker compose stackfile the secret definition:

{% highlight yml %}
version: '3.2'
services:
  web:
    image: myservice
    environment:
      - REFLEX_SERVICE=dmz-proxy-d1
    ports:
      - 80:80
    secrets:
      - source: myservice-p1-apikey
        target: REFLEX_APIKEY
      - source: reflex-url
        target: REFLEX_URL
secrets:
  myservice-p1-apikey:
    external: true
  reflex-url:
    external: true
{% endhighlight %}

As you can see in this definition, you have the flexibility to mix-and-match to suite.  The service is defined as an environment variable, where the apikey and url are secrets.  The url is a secret that is shared across many containers, where the apikey is unique to this specific container.

