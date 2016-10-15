---
layout: docs
title: Reflex Objects
permalink: /docs/objects/
---

A variety of object types may be used within Reflex Engine.  This describes the attributes of each.

A higher level overview of some of the objects is available in the [Overview](/docs/).

* [pipeline](/docs/objects#pipeline) - The "top level" object which relates to sets of services.
* [service](/docs/objects#service) - A specific service running for a single purpose, lane, region or tenant.
* [config](/docs/objects#config) - configuration management
* [instance](/docs/objects#instance) - an instance of a service.  many instances can relate to a single service
* [release](/docs/objects#release) - a release of code, relates to a service
* [policy](/docs/objects#policy) - an ABAC Policy
* [apikey](/docs/objects#apikey) - an API Key
* [group](/docs/objects#group) - a grouping of API keys for policy management

# Pipeline

The Pipeline is the top level object.  Services refer to the Pipeline for their launch information.

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string
|title|string|full title for product
|launch|object|Launch Sub-object
|monitor|array|Array of Monitor Sub-objects

Example:

{% highlight json %}
{
    "name": "bct",
    "title": "Bat'leth Combat Training",
    "launch": {  },
    "monitor": [  ]
}
{% endhighlight %}

### Launch Sub-object

{: .table .values }
|Type|  value|  Description
|----|-|-
|cfgdir|string|base path to where configurations are stored
|rundir|string|base path to change into before starting process
|exec  |array |elements

Example:

{% highlight json %}
{
    "launch": {
        "cfgdir": "/app/bct/config",
        "rundir": "/app/bct",
        "exec": [ "/usr/bin/node", "index.js" ]
    }
}
{% endhighlight %}

### Monitor Sub-object

Used with the [Monitor module](/docs/reflex-monitor).

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|base path to where configurations are stored
|type|string|"http" is the only supported type
|expect|object|Sub-object including response-code (with int value)
|query|object|see example
|retry|int|how long to wait before trying on a failure
|timeout|int|how long to wait before giving up on a response

Example:

{% highlight json %}
    {
        "name": "bct-heartbeat",
        "expect": {
            "response-code": 204
        },
        "query": {
            "headers": {
                "Host": "the-hostname.cold.org"
            },
            "method": "GET",
            "path": "/api/v1/health"
        },
        "retry": 30,
        "timeout": 2,
        "type": "http"
    }
{% endhighlight %}

# Service

The central pivot point referencing other objects.

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|active-instances|array|list of active instances used by services, compiled from `static-instances` and `dynamic-instances`
|static-instances|array|list of statically set instances
|dynamic-instances|array|list of dynamically created instances (such as from a container management plugin service)
|lane|string|the lane in the pipeline, for the current stage
|region|string|(optional) region string, to help separate regions (if needed)
|target|string|(optional) reference to release object
|tenant|string|(optional) string for tenant (in a multi-tenant environment)
|version-url|string|(optional) string used by [Reflex Version-Check module](/docs/version-check)
|pipeline|string|link to the name of the pipeline

Example:

{% highlight json %}
    {
        "type": "http"
    }
{% endhighlight %}

# Config
# Instance
# Release
# Policy
# Apikey
# Group
