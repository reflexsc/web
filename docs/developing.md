---
layout: docs
title: Developing Reflex
permalink: /docs/developing/
---

Notes to help with developing Reflex:

* Clone the [Github Repository](https://github.com/reflexsc/reflex)
* Modules are in `src/{modulename}`
* Configure for development:
{% highlight bash %}
	./setup.sh develop
{% endhighlight %}
* Activate the development virtual env:
{% highlight bash %}
	source setup.sh env
{% endhighlight %}

* Using defaults, start a local MariaDB (no pass on root), create a database `reflex_engine`, run the service:

{% highlight bash %}
    reflex-engine
{% endhighlight %}

* Connect to local engine by setting vars:

{% highlight bash %}
    export REFLEX_URL=http://localhost:54000/api/v1
    export REFLEX_APIKEY=....from reflex-engine output....

    engine config list
{% endhighlight %}

