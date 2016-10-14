---
layout: docs
title: Roles
permalink: /docs/roles/
---

Three modules facilitate the roles of Reflex:

* Launch Assist
* Reflex Engine
* Reflex Tools

# Launch Assist

Launch Assist is a simple tool to help with managing containers.  It fulfills three roles:
1. Delivers secrets and configurations at run time, safely and securely.
2. Flexible startup -- the details of how a given container may run are pulled from Reflex Engine, allowing for you to easily re-use the same images at different lanes and even in different ways (such as run as a webservice, db migration tool, etc, all based on how it is called).
3. Pre-init steps -- it allows you to run other actions prior to starting your application, such as mounting a network volume into the container.

this works by simply making the entry point be reflex launch, and the service is defined as an environment variable.  For example, in a Dockerfile:

{% highlight docker %}
ENTRYPOINT ["/usr/local/bin/launch"]
{% endhighlight %}

And then runnig the services:

{% highlight bash %}
docker run -e REFLEX_SERVICE=my-stg-service \
           -e REFLEX_URL=https://.../api/v1 \
           -e REFLEX_APIKEY=xxxx.yyyyy \
           --name=myservice \
           myimage
{% endhighlight %}

Or with Docker Compose:

{% highlight yaml %}
version: '2'
services:
  myservice:
    image: myimage
    entrypoint: ["/usr/local/bin/launch"]
    environment:
      - REFLEX_SERVICE=my-stg-service
      - REFLEX_URL=https://.../api/v1
      - REFLEX_APIKEY=xxxx.yyyyy
{% endhighlight %}

Assuming you have configured your Service in the Reflex Engine, on startup Launch Assist then:

* Queries the Reflex Engine to learn how to execute your service (looking up the REFLEX_SERVICE inside Reflex Engine).  This is similar to things you may define within a static yml file, or a static service, but instead are dynamic (Infrastructure as Code).
* pulls and stores your configurations wherever your app expects them (each time you run).
* Runs any actions if desired (other pre-steps)
* Launches your service

Launch Assist gives you ephemeral containers where you do not need to store any environmental, lane or other specific data to how the container runs, within the container.

# Reflex Engine

Reflex Engine is a database service providing the [Reflex API](/docs/api/). Most objects are implicitly versioned, it runs atomically, and each individual service is stateless allowing for easy scale

# Reflex Tools

Reflex Tools are the combination of [Reflex CLI](/docs/cli/) commands available to interface with the Reflex Engine.


# Roadmap

Things in the labs but not yet released:

<li> <b>Reflex Hooks</b> -- callbacks based on changes and events to objects in Reflex Engine, using expressions similar to ABAC policies
<li> <b>Reflex Check</b> -- a container that can run within your infrastructure and do deep level version checks on sets of services (with full regex output)
<li> <b>Reflex UI</b> -- a front-end user interface
