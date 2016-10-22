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
* [build](/docs/objects#build) - a build of code, relates to a service
* [policy](/docs/objects#policy) - an ABAC Policy (tested on object access)
* [policyscope](/docs/objects#policyscope) - an ABAC Policy Scope (tested on object change)
* [apikey](/docs/objects#apikey) - an API Key
* [group](/docs/objects#group) - a grouping of API keys for policy management
* [state](/docs/objects#state) - a general purpose state object

## Flexible Schema

Many of the objects support a NoSQL schema-light model, where you can add your own attributes to them above and beyond what is defined herein.  This is valuable for you to be able to extend things to meet your own needs.  In particular, the [state](#state) object is designed for general ad-hoc purposes.

## Archived Copies

Some of the objects automatically create backups each time they are changed.  These are:

* [pipeline](#pipeline)
* [service](#service)
* [config](#config)
* [policy](#policy)
* [policyscope](#policyscope)

You cannot delete archived copies of objects (by design).  If you must delete them, it is only possible via direct db access to MySQL.

*Todo: Exposing the archived list and copies via the CLI.*

## Soft Relationships

In some cases, such as the [service](#service) and [config](#config) objects, there are internal "soft" relationships that the Reflex Engine supports.  This mechanism works such that if you submit a name of an object as part of an array that it knows about (such as `config.extends`) then at write time the Reflex Engine tries to map out the relationship to an ID.  This is then translated into the format:

{% highlight text %}
name.id
{% endhighlight %}

If it cannot find the object, it puts `notfound` in place of the numeric ID.  This is okay, and is just an indicator to you that it cannot find the referenced object.

Whenever the relationship is resolved, Reflex Engine always will try to lookup by the `id` part of the identifier first (unless it is `notfound`).  If that fails, it will try to lookup by the `name` part of the identifier.

This facilitates both performance and easy renaming of objects.

In some cases there are also *hard* relationships which are mapped by Reflex Engine under the hood.  These will appear in your objects as `something_id` (such as `pipeline_id` on the service object, linking to its pipeline.  You will not be able to change these attributes--they are always remapped at each store of the object, based on the `something` attribute.

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
|target|string|(optional) reference to build object
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

The higher level concepts behind [Secrets and Configuratins](/docs/#secrets-and-configurations) are described separately.

There are two types of Configuration objects: Parameter, and File.  If the type is File, then it should include a content section which describes how to store data as a file.  Conventionally a parameter object exports to a File object.

You have three types of relationships between Config objects: *Extends*, *Imports*, and *Exports*.  These relationships act differently to serve different purposes:

**Extends**

* Goes up a hierarchy, recursively
* Preference given to values lower in tree (child overrides parent)
* Ignored on exported target

**Imports**

* Merges a single object into current
* Preference given to values on imported object, not current
* Imports does not merge 'extends' nor 'imports' values
* Can be used on exported targets

**Exports**

* Exported objects are started as a clone of source object
* Attribute preference is given to target object values (they will override source object values).
* Extends is not processed on target objects (no hierarchy processed)
* Imports is processed on target objects
* Exported objects should be type=file, otherwise nothing happens

## Exporting Configurations

There are a few ways to export configurations:

* A branch of the final configuration object can be inserted to STDIN (ideal)
* A branch of the final configuration object is saved as a JSON file
* Local files are processed for variable substitution: %{VARIABLE}
* An embedded file on a File object is decoded and saved to disk
* Parameters are set as process environment variables (dangerous when using secrets)

## Variable Substitution

* Variables are substituted using the syntax: `%{VARIABLE}`

* The name of the variable is looked up on the configuration object (after it is flattened) by referencing `sensitive.parameters` as well as any other object references defined in the `procvars` array.

* All referenced object values must be strings or numbers.  Arrays or sub-objects are ignored.
* Variables may reference values that in turn have variables.  All variables are fully resolved.  If the following process variables were used:

{% highlight json %}
{
    "sensitive": {
      "parameters": {
        "ENV": "tst",
        "NAME": "manage",
        "ENV-SUFFIX": "-%{ENV}",
        "FULL-NAME": "%{NAME}%{ENV-SUFFIX}"
      }
    }
}
{% endhighlight %}

And the contents of a file to process were:

{% highlight bash %}
hostname="%{FULL-NAME}"
{% endhighlight %}

The result would be:

{% highlight bash %}
hostname="manage-tst"
{% endhighlight %}

### Config Type=parameter

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

### Config Type=file

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|type|string|"file"
|content|object|Content Sub-object

**Config Content sub-object**

{: .table .values }
|Type|  value|  Description
|----|-|-
|dest|string|name of the object
|file|string|"file"
|source|object|(optional) base64 encoded data exported as the file
|ref|object|reference to the json sub-object to export
|varsub|boolean|true or false -- perform variable substitution on the content of the file
|encoding|string|what encoding the data is current stored at.  Options: none, or base64

### Example Config

In the following examples, we reference a set of objects: `bct-tst` (target config from the Service), `bct` (parent config) and `bct-config1`, `bct-config2` and `bct-keystore` (exported objects).  There should be a pre-existing file named local.xml.in, which is processed for variables including %{DB_URL}.  Can you determine what the result of processing this would be?

{% highlight json %}
{
    "name": "bct",
    "type": "parameter",
    "extends": ["common"],
    "exports": ["bct-config1", "bct-config2"],
    "sensitive": {
        "parameters": {
            "MONGO-URI":"mongodb://%{MONGO-HOSTS}/%{MONGO-DBID}"
        }
    },
    "setenv": {
        "MONGO-URI": "%{MONGO-URI}"
    }
}

{
    "name": "bct-tst",
    "type": "parameter",
    "extends": ["bct"],
    "exports": ["bct-keystore"],
    "procvars": ["sensitive.config.db"],
    "sensitive": {
        "parameters": {
            "MONGO-USER":"test_user",
            "MONGO-PASS":"not a good password",
            "MONGO-HOSTS":"test-db",
            "MONGO-DBID":"test_db"
        },
        "config": {
            "db": {
                "server": "%{MONGO-HOSTS}",
                "db": "%{MONGO-DBID}",
                "user": "%{MONGO-USER}",
                "pass": "%{MONGO-PASS}",
                "replset": {
                    "rs_name": "myReplicaSetName"
                }
            }
        }
    }
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
    "name": "bct-config1",
    "type": "file",
    "content": {
        "source": "local.xml.in",
        "dest": "local.xml",
        "varsub": true
    }
}

{
    "name": "bct-config2",
    "type": "file",
    "content": {
        "dest":"local-production.json",
        "ref":"sensitive.config",
        "type":"application/json"
    }
}

{
    "name": "bct-keystore",
    "type": "file",
    "content": {
        "dest":"local.keystore",
        "ref":"sensitive.data",
        "encoding": "base64"
    },
    "sensitive": {
        "data": "bm90IHJlYWxseSBhIGtleXN0b3JlIG9iamVjdAo="
    }
}

{% endhighlight %}

The output from evaluating these configurations with Launch Assist would be:

1. The environment variable `MONGO_URI` is set to: `mongodb://test-db/test_db`
2. The file `local.xml` is created (in the path specified in the Service Object's `cfgdir`), by reading from the pre-existing `local.xml.in` file, performing variable substitution using values from `sensitive.parameters`.
3. The file `local.keystore` is written, using the embedded contents from `sensitive.data`
4. The file `local-production.json` is created, containing the JSON data:

{% highlight json %}
{
    "db": {
        "server": "test-db",
        "db": "test_db",
        "user": "test_user",
        "pass": "not a good password",
        "replset": {
            "rs_name": "myReplicaSetName"
        }
    }
}
{% endhighlight %}

# Instance

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|service|string|name of the service using the instance
|status|string|status of the service: ok or failed
|address|object|a sub-object containing the address values

**Instance Address sub-object**

{: .table .values }
|Type|  value|  Description
|----|-|-
|host|string|internal hostname used by the instance
|port|int|port used by the service (only one port)
|service|string|(optional) public hostname for service, such as if it is in front of a load balancer.

# Build

Builds are useful in tracking software through a continuous delivery cycle.

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|application|string|unique string to identify a single application (often refers to the pipeline, but multiple pipelines may use the same application)
|version|str|version string
|state|string|
|status|object|Includes a key for each of the defined steps with a value from the set(incomplete/started/success/failure/skipped). Useful for tracking complex builds. Example: `compile: success`, or `prepare: skipped`
|type|string|optional "type" of build (i.e. tarball, container, etc)
|link|string|(optional) url to build artifact

*Todo: Insert documentation and links to using builds and the release / promote command*

# Policy

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|policy|string|expression string describing the policy. lightweight python syntax.  Reference [Bringing it together](#bringing-it-together) in the ABAC documentation.

Policies must also be matched to objects with a Policyscope entry.

# Policyscope

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|matches|string|expression string describing the policy. lightweight python syntax.  Reference [Bringing it together](#bringing-it-together) in the ABAC documentation.
|actions|set|The type of action to match on, as a comma separated list of strings, from the set: `read`, `write`, `admin`; where `admin` is both read and write.
|type|enum|What method to use when matching objects.  Either `targetted` or `global`.  `targetted` scopes match individual objects, where `global` scopes apply to the entire object class (table).

# Apikey

To generate a new APIkey, just create a new object with a `name` only, and it will generate the secrets for you.

The APIkey object is the `name` plus `.` and any one of the base64 elements of secrets.

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|description|string|optional string describing the Apikey
|secrets|array|an array of randomly generated secret data.  Generated for you.  If you need to change your secret data, you add to this array and both sets of secrets will be allowed (useful when switching out keys).  Secret data is stored in base64 format.

# Group

Groupings of Apikeys or Pipelines for easier policy management.  When creating and updating a group, add the apikey names only (not secrets) to the `group` array.

{: .table .values }
|Type|  value|  Description
|----|-|-
|name|string|name of the object
|group|array|A mapping of Apikeys or Pipelines (future)
|type|enum|Either `Apikey` or `Pipeline` (specifying what type of object is being grouped)

# State

The State object is a general purpose object.  There are no required fields other than `name`
