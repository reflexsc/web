---
layout: docs
title: Install
permalink: /docs/install/
---

# Test Drive

You can use [Docker](https://www.docker.com/products/overview) to get a feel for things.  Start by running the Engine:

{% highlight bash %}
curl -sLO https://raw.github.com/reflexsc/reflex/master/.pkg/demoengine.sh && bash demoengine.sh
{% endhighlight %}

Followed by connecting to it using the `reflexsc/tools` container.  Set the `REFLEX_APIKEY` from above, as well as the `REFLEX_URL` to the local host:

{% highlight bash %}
export REFLEX_APIKEY=...
export REFLEX_URL=http://localhost:54000/
docker run -t reflexsc/tools reflex engine list
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
