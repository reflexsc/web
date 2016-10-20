---
layout: docs
title: Install
permalink: /docs/install/
---

# Test Drive

For an easy test drive with little commitment, you can use [Docker](https://www.docker.com/products/overview), using a wrapper bash script `demoengine.sh`.  This script runs in two steps--it wraps the server (engine) and the client--each are in containers.

Start by pulling the script and running the Engine:

{% highlight bash %}
curl -sLO https://raw.github.com/reflexsc/reflex/master/.pkg/demoengine.sh
chmod +x demoengine.sh
{% endhighlight %}

Then run the engine:
{% highlight bash %}
./demoengine.sh engine
{% endhighlight %}

After the Engine is ready, it will print a REFLEX_APIKEY.  At this point, you have a reflex engine with some mock data.  Set key and use the `reflex` command from within a container:

{% highlight bash %}
export REFLEX_APIKEY=... # from above
./demoengine.sh reflex engine config list
{% endhighlight %}

# Direct Install

Supported in MacOS and Linux.

Reflex requires python3, pip and virtualenv to exist, then it loads itself into its own virtualenv.

For MacOS, first get an updated python3, and make sure virtualenv is installed:

{% highlight bash %}
sudo brew upgrade python3
sudo pip install virtualenv
{% endhighlight %}

Network "Easy" install (does not require super user privileges):

{% highlight bash %}
curl -sLO https://raw.github.com/reflexsc/reflex/master/.pkg/getreflex.sh && bash ./getreflex.sh
{% endhighlight %}

