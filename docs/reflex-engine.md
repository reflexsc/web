---
layout: docs
title: Reflex Engine
permalink: /docs/reflex-engine/
---

Reflex Engine is a ABAC based REST service providing the [Reflex API](/docs/api/). Most objects are implicitly versioned, it runs atomically, and each individual service is stateless allowing for easy scale

It is simple to Install, described in the [Installation Documentation](/docs/install/#install-engine).

Reflex engine delivers secrets, but cannot deliver to itself.  This means you ultimately will need to configure the db connections for reflex in a less secure manner (storing files, etc).

Configuration is stored as a json object in an environment variable (optionally base64 encoded).  Details are on the section on [Reflex Engine Configuration](#reflex-engine-configuration)

The Reflex Engine is a stateless 12-factor web service that can be built to scale or run standalone. 

The Database used on the backend of Reflex Engine is MariaDB (but may work with any MySQL database). On first start Reflex Engine expects the database to be defined, but no tables.  If it see's no tables, it will initialize its schema, generate a new master key with abac policies, and will print this key to the console log.

## Reflex Engine Configuration

The configuration is stored as a JSON object, in the docker secret or environment variable `REFLEX_ENGINE_CONFIG`.  This can be base64 encoded for easier storing.  The options shown are also the defaults--you can leave out any part of this configuration to receive the default (Note: the #comments are not accepted as part of the config)

```
{
    "server": {
        "route_base": "/api/v1",     # default base url path. add to this for entropy
        "port": 54000,               # default port
        "host": "0.0.0.0"            # default bind all internal
    },
    "heartbeat": 10,                 # how often to drive internal checks?  this is an okay default
    "cache": {                       # time in seconds for cache management
        "housekeeper": 60,           # default housekeeper interval - how often reflex checks cache and other things
        "policies": 300,             # default cache age for policies
        "sessions": 300,             # default cache age for sessions
        "groups": 300                # default cache age for groups
    },
    "db": {                          # anything accepted to mysql.connector.connect
        "database": "reflex_engine", # default
        "user": "root",              # default
        "password": "word"           # user password for database
    },
    "crypto": {
        "001": {                     # each key is just enumerated.  Add more as you need
            "key": "",               # create: dd if=/dev/urandom bs=32 count=1 | base64 -w0
            "default": true          # only one should be true.  All others are for decoding old data
        }
    }
}
```

To make this base64, pipe it through the `base64` command:

{% highlight bash %}
# strip comments from example above (cut-n-paste) and store to example 'engine-cfg.json'
sed -e 's/#.*$//;s/  *$//;s/^  *//' > engine_cfg.json
REFLEX_ENGINE_CONFIG=$(cat engine-cfg.json | base64)
echo $REFLEX_ENGINE_CONFIG
ewoic2VydmVyIjogewoicm91dGVfYmFzZSI6ICIvYXBpL3YxIiwKInBvcnQiOiA1NDAwMCwKImhvc3QiOiAiMC4wLjAuMCIKfSwKImhlYXJ0YmVhdCI6IDEwLAoiY2FjaGUiOiB7CiJob3VzZWtlZXBlciI6IDYwLAoicG9saWNpZXMiOiAzMDAsCiJzZXNzaW9ucyI6IDMwMCwKImdyb3VwcyI6IDMwMAp9LAoiZGIiOiB7CiJkYXRhYmFzZSI6ICJyZWZsZXhfZW5naW5lIiwKInVzZXIiOiAicm9vdCIsCiJwYXNzd29yZCI6ICJ3b3JkIgp9Cn0K
{% endhighlight %}

* See [Install Reflex Engine](/docs/install/#install-reflex-engine) for more information on installing Reflex (inside or outside of a container)

-

&raquo; [Next: Reflex Tools](/docs/reflex-tools/)
