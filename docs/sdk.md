---
layout: docs
title: Reflex SDK
permalink: /docs/sdk/
---

Using Reflex in-code is easy with Python, using the rfx.client.Session() class:

{% highlight python %}
    import rfx.client
    rcs = rfx.client.Session().cfg_load()
    cfg = rcs.get("config", "tardis")
{% endhighlight %}

The Session object uses your environment or reflex configuration for:

{% highlight python %}
    REFLEX_URL
    REFLEX_APIKEY
{% endhighlight %}

Methods:

* `.get(object_type, object_name)`
* `.list(object_type, [match=GLOB-PATTERN, cols=["cols","to","include"], raise_error=True|False])`
* `.create(object_type, object_data)` &mdash; "name" must be in object_data
* `.update(object_type, object_name, object_data)` &mdash; object_name already exists, object_data is a complete replacement
* `.patch(object_type, object_name, object_data)` &mdash; object_name already exists, object_data is a delta of changes
* `.delete(object_type, object_name)`

-
