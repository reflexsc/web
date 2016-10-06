---
layout: hpage
title: Install
permalink: /install/
---

Reflex has multiple components.  Notably, the [Reflex Tools](#reflex-tools), and
the [Reflex Engine](#reflex-engine).  For an easy test drive, try the containers.

You can install [Using Containers](#using-containers) or [directly into MacOS or Linux](#direct-install).

# Using Containers

Run the Engine:

{% highlight bash %}
docker run reflexsc/engine
{% endhighlight %}

# Direct Install

Supported in MacOS and Linux.

Reflex requires python3, pip and virtualenv to exist, then it loads itself into its own virtualenv.

For MacOS, first get an updated python3, and make sure virtualenv is installed:

{% highlight bash %}
sudo brew upgrade python3
sudo pip install virtualenv
{% endhighlight %}

Install from the network (does not require super user privileges):

{% highlight bash %}
curl -sLO https://raw.github.com/reactorsc/reactor/master/.pkg/getreactor.sh &&\
 bash ./getreactor.sh
{% endhighlight %}

## Install Reactor Core

Reactor Core is the back-end database and REST api.  This is not yet GA.
