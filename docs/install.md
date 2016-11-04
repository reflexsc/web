---
layout: docs
title: Install
permalink: /docs/install/
---

Please Note!  Reflex is *beta* software.  We would love help from others testing it out and finding kinks in these docs, but understand we are still polishing things up.

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

# Easy Install

If you would rather install things yourself, this is supported in MacOS and linux.

Reflex requires python3, pip and virtualenv to exist, then it loads itself into its own virtualenv.

For MacOS, first get an updated python3, and make sure virtualenv is installed:

{% highlight bash %}
sudo brew upgrade python3
sudo pip install virtualenv
{% endhighlight %}

Network easy install (does not require super user privileges).  This only configures the client by default.

{% highlight bash %}
curl -sLO https://raw.github.com/reflexsc/reflex/master/.pkg/getreflex.sh && bash ./getreflex.sh
{% endhighlight %}

Notes:

* Pull updates at any time with: `reflex update`
* By default this does not configure the engine
* Reflex is stored at: `$HOME/.reflex/current`, you can always cd there and re-run the install script (see [Source Install](#source-install))
* For more details on the engine, see the section [Reflex Engine](/docs/reflex-engine)

# Source Install

For full control, you can do a simple source install from github:

{% highlight bash %}
git clone https://github.com/reflexsc/reflex.git
cd reflex
./install.sh local --engine
{% endhighlight %}

