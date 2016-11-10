---
layout: docs
title: Install
permalink: /docs/install/
---

Please Note!  Reflex is *beta* software.  We would love help from others testing it out and finding kinks in these docs, but understand we are still polishing things up.

Three options:

* [**Easy Install**](#easy-install) &mdash; Install the local commands
* [**Install Engine**](#install-engine) &mdash; Install the Engine
* [**Test Drive**](#test-drive) &mdash; Easy test drive of all parts, using Docker.

# Easy Install

This is supported in MacOS and Linux, with Python version 3.

Use PIP to load the reflex commands:

{% highlight bash %}
pip3 install -U rfxcmd
{% endhighlight %}

Notes:

* This does not load the engine &mdash; see the section [Install Engine](#install-engine)
* On MacOS you may want to use brew to get python3: `sudo brew upgrade python3`

# Install Engine

The engine itself is easily installed with PIP.  Once you have it installed, reference the section [Reflex Engine](/docs/reflex-engine/) for details on configuring it to run.

{% highlight bash %}
pip3 install -U rfxengine
{% endhighlight %}

However, it also uses the Oracle MySQL connector, which must be installed separately (not available directly via PIP).  We have included a command to make this easy:

{% highlight bash %}
get_mysql_connector.py
{% endhighlight %}

## Source Install

Alternatively, you can pull the source code directly and install in developer mode:

{% highlight bash %}
git clone https://github.com/reflexsc/reflex.git
cd reflex
./install.sh develop --engine
{% endhighlight %}

You can also install with `root` instead of `develop`, but this loads the modules from PIP so it may not be as useful.

# Test Drive

For an easy test drive with little commitment, you can use [Docker](https://www.docker.com/products/overview), using a wrapper bash script `demoengine.sh`.  There are a few steps:

1. Install [Docker](https://www.docker.com/products/overview)
2. Download the demo script (it wraps the server and the client containers)
3. Run the server (Reflex Engine)
4. Load sample data (optional)
5. Play with it via the CLI

To make this happen, start by pulling the demo script:

{% highlight bash %}
curl -sLO https://raw.github.com/reflexsc/reflex/master/.pkg/demoengine.sh
chmod +x demoengine.sh
{% endhighlight %}

Then run the engine:

{% highlight bash %}
./demoengine.sh engine
{% endhighlight %}

After the Engine is ready, it will print a `REFLEX_APIKEY`.  This is your master key for the demo database, keep it safe.  If you want to start over, just remove the mariadb container and re-run the engine--it will re-initialize.

Set the key in your environment, by just cutting and pasting the printed value:

{% highlight bash %}
export REFLEX_APIKEY=... # from above
{% endhighlight %}

Next, initialize the mock data, using the tools container, and then try a reflex engine command to see the services:

{% highlight bash %}
./demoengine.sh reflex setup demo --confirm
./demoengine.sh reflex engine service list
./demoengine.sh reflex launch config bct-tst
{% endhighlight %}

Bonus! Some of the data in the demo set is the same data used in the [Object documentation](/docs/objects/).  Additional details on what is supported by the `reflex` command are available in the [Reflex Tools](/docs/reflex-tools/) section.

When you are done, don't forget to cleanup:

{% highlight bash %}
docker-compose down
{% endhighlight %}

Next steps, you can investigate our Tutorials:

* [Reflex Services and Launch Assist](/docs/tutorial-services/)
* [Linking Pipelines](/docs/tutorial-pipeline/)

