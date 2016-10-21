---
layout: docs
title: Reflex Tools
permalink: /docs/reflex-tools/
---

Reflex Tools are the combination of CLI commands available to interface with the Reflex Engine.  You can run them either with the `reflexsc/tools` container, or by doing a [Direct Install](/docs/install#easy-install). 

# From Container

To run from a container, try the following (Make sure you have `REFLEX_URL` and `REFLEX_APIKEY` set in your environment)

{% highlight bash %}
    docker run --rm -it \
                 -e REFLEX_URL=$REFLEX_URL \
                 -e REFLEX_APIKEY=$REFLEX_APIKEY \
                 reflexsc/tools reflex {...args...}
{% endhighlight %}

Or if you are in bash, you can simiplify this by making 'reflex' a function that calls docker:

{% highlight bash %}
    reflex() {
        docker run --rm -it \
                 -e REFLEX_URL=$REFLEX_URL \
                 -e REFLEX_APIKEY=$REFLEX_APIKEY \
                 reflexsc/tools reflex "$@"
    }

    reflex engine service list
{% endhighlight %}

The commands are self-describing (run without arguments for syntax information).

# Configuration

Reflex can store its APIKEY and URL in a local encrypted file.  This isn't perfect security, but it is better than plain files.  If you do this, then you no longer need to include the APIKEY and URL in the environment.  Note: this will not work properly in the ephemeral container (as it is destroyed after each run).

{% highlight bash %}
reflex setup wizard
{% endhighlight %}

More docs coming soon.

* Running local: set config

