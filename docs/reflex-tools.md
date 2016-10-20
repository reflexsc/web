---
layout: docs
title: Reflex Tools
permalink: /docs/reflex-tools/
---

Reflex Tools are the combination of CLI commands available to interface with the Reflex Engine.  You can run them either with the `reflexsc/tools` container, or by doing a [Direct Install](/docs/install#direct-install).  To run from a container, try:

{% highlight bash %}
    docker run --rm -t \
                 -e REFLEX_URL=$REFLEX_URL \
                 -e REFLEX_APIKEY=$REFLEX_APIKEY \
                 reflexsc/tools reflex {...args...}
{% endhighlight %}

The commands are self-describing (run without arguments for syntax information).

At a high level:


