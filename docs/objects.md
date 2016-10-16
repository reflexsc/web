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
|active-instances|array|list of active instances used by services, compiled from `static-instances` and `dynamic-instances`.  Typically external services update static and dynamic, where active instances is referenced for the current list.
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
  "name": "bct-tst",
  "active-instances":[
    "bct-p1ap1-blue"
  ],
  "static-instances":[ ],
  "dynamic-instances":[
    "bct-p1ap1-blue"
  ],
  "lane":"prd",
  "pipeline":"bct",
  "region":"saas1",
  "target":"bct-1610-0017",
  "tenant":"blue",
  "version-url":"https://{service}/api/v1/health"
}
{% endhighlight %}

# Config

The concepts behind [Secrets and Configuratins](/docs/#secrets-and-configurations) are fully described separately.  Herein are simply the object definitions.

There are two types of Config object: parameter, and file.

### Type=parameter

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|type|string|"parameter"
|procvars|array|A list of object references at which to perform variable substitution.  Default `["sensitive.parameters"]`
|sensitive|object|data in this object is encrypted at rest
|setenv|object|key-value pairs added to environment
|exports|array|A list of object names to export
|extends|array|A list of object names to extend
|imports|array|A list of object names to import

Example:
{% highlight json %}
{
    "name": "bct-tst",
    "type": "parameter",
    "extends": ["bct"],
    "procvars": ["sensitive.parameters"],
    "sensitive": {
        "parameters": {
            "MONGO-HOSTS":"test-db",
            "MONGO-DBID":"test_db",
            "MONGO-PASSWORD":"asdf",
            "MONGO-URI":"mongodb://%{MONGO-HOSTS}/%{MONGO-DBID}"
        }
    },
    "setenv": {
        "MONGO-URI": "%{MONGO-URI}"
    }
}

{
    "name": "bct",
    "type": "parameter",
    "extends": ["common"],
    "imports": ["bct-config"],
    "exports": ["bct-file"]
}

{
    "name": "common",
    "type": "parameter",
    "sensitive": {
        "parameters": {
            "SHARED-SECRET":"moar"
        }
    }
}

{
    "name": "bct-config",
    "type": "parameter",
    "sensitive": {
        "parameters": {
            "GROUP-CONFIG":"moar"
        },
        "config": {
            "db": {
                "uri": "%{MONGO-URI}"
            }
        }
    }
}

{% endhighlight %}

### Type=file

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|type|string|"file"
|content|object|Content Sub-object


#### Content sub-object

{: .table .values }
|Type|  value|  Description
|----|-|-
|dest|string|name of the object
|file|string|"file"
|source|object|(optional) base64 encoded data exported as the file
|ref|object|reference to the json sub-object to export
|varsub|boolean|true or false -- perform variable substitution on the content of the file
|encoding|string|what encoding the data is current stored at.  Options: none, or base64

Example:

{% highlight json %}

{
    "name": "bct-config",
    "type": "file",
    "content": {
        "dest":"local-production.json",
        "ref":"sensitive.config",
        "type":"application/json"
    }
}

{% endhighlight %}


# Instance
# Release
# Policy
# Apikey
# Group
