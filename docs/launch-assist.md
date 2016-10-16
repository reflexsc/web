---
layout: docs
title: Launch Assist
permalink: /docs/launch-assist/
---

Launch Assist is a simple tool to help with managing services.  It fulfills three roles:

1. Delivers secrets and configurations at run time, safely and securely.
2. Flexible startup -- the details of how a given container may run are pulled from Reflex Engine, allowing for you to easily re-use the same images at different lanes and even in different ways (such as run as a webservice, db migration tool, etc, all based on how it is called).
3. Pre-init steps -- it allows you to run other actions prior to starting your application, such as mounting a network volume into the container.

You use Launch Assist through the launch command.  Conventionally, launch is run by a service such as Docker or SystemD, and it in turn determines how to run the service through the Service and Pipeline description in Reflex Engine, deploys any configurations as required, and then runs the service (or optionally triggers Actions).  This sequence of events:

1. System Startup (Docker or SystemD) runs ephemer/launch
2. Reflex Launch Assist preps the environment, using information from DSE
3. Reflex Launch Assist runs the service or triggers [Actions](/docs/reflex-actions/)

With containers, the Dockerfile looks like:

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

## Integrating with other config tools

Other configuration tools, such as Node Config, are easy to integrate with.

If you are using one of these tools, merely have Launch Assist store your configuration as the last step in their file hierarchy, such as `local-production.json`.

