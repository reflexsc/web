---
layout: docs
title: Install
permalink: /docs/install/
---

# Test Drive

You can use [Docker](https://www.docker.com/products/overview) to get a feel for things.  Start by running the Engine:

{% highlight bash %}
curl -sLO https://raw.github.com/reflexsc/reflex/master/.pkg/demoengine.sh && bash demoengine.sh start
{% endhighlight %}

Followed by connecting to it using the `reflexsc/tools` container.  Set the `REFLEX_APIKEY` from above:

{% highlight bash %}
eval $(./demoengine.sh address) # this sets REFLEX_URL
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

