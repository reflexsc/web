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

The configuration is stored as a JSON object, in the environment variable `REFLEX_ENGINE_CONFIG`.  This can be base64 encoded for easier storing.  The options available are as follows (Note: the #comments are not accepted as part of the config)

{% highlight json %}
{
    "server": {
        "route_base": "/api/v1",     # default base url path
        "port": 54000,               # default port
        "host": "0.0.0.0"            # default bind all
    },
    "heartbeat": 10,                 # how often to verify things are good?
    "cache": {                       # time in seconds for cache management
        "housekeeper": 60,           # default housekeeper interval
        "policies": 300,             # default cache age
        "sessions": 300,             # default cache age
        "groups": 300                # default cache age
    },
    "db": {                          # anything accepted to mysql.connector.connect
        "database": "reflex_engine", # default
        "user": "root",              # default
        "password": "word"           # user password for database
    }
}
{% endhighlight %}

To make this base64, pipe it through the `base64` command:

{% highlight bash %}
# strip comments from example above (cut-n-paste) and store to example 'engine-cfg.json'
sed -e 's/#.*$//;s/  *$//;s/^  *//' > engine_cfg.json
REFLEX_ENGINE_CONFIG=$(cat engine-cfg.json | base64)
echo $REFLEX_ENGINE_CONFIG
ewoic2VydmVyIjogewoicm91dGVfYmFzZSI6ICIvYXBpL3YxIiwKInBvcnQiOiA1NDAwMCwKImhvc3QiOiAiMC4wLjAuMCIKfSwKImhlYXJ0YmVhdCI6IDEwLAoiY2FjaGUiOiB7CiJob3VzZWtlZXBlciI6IDYwLAoicG9saWNpZXMiOiAzMDAsCiJzZXNzaW9ucyI6IDMwMCwKImdyb3VwcyI6IDMwMAp9LAoiZGIiOiB7CiJkYXRhYmFzZSI6ICJyZWZsZXhfZW5naW5lIiwKInVzZXIiOiAicm9vdCIsCiJwYXNzd29yZCI6ICJ3b3JkIgp9Cn0K
{% endhighlight %}

## Reflex Engine in Container

[Setup the configuration](#reflex-engine-configuration) for the container, and then run your container:

{% highlight bash %}
docker run --rm -t \
	 -e REFLEX_ENGINE_CONFIG=$REFLEX_ENGINE_CONFIG \
	 reflexsc/engine reflex-engine "$@"
{% endhighlight %}

Optionally, you may use docker-compose with the mariadb container. You will need to research the mariadb container and learn how to initialize the user and import the volume so it may be reused.

{% highlight yml %}
version: '2'
services:
  engine:
    image: reflexsc/engine
    ports:
      - "54000:54000"
    links:
      - db
    environment:
      - REFLEX_ENGINE_CONFIG=ewoic2VydmVyIjogewoicm91dGVfYmFzZSI6ICIvYXBpL3YxIiwKInBvcnQiOiA1NDAwMCwKImhvc3QiOiAiMC4wLjAuMCIKfSwKImhlYXJ0YmVhdCI6IDEwLAoiY2FjaGUiOiB7CiJob3VzZWtlZXBlciI6IDYwLAoicG9saWNpZXMiOiAzMDAsCiJzZXNzaW9ucyI6IDMwMCwKImdyb3VwcyI6IDMwMAp9LAoiZGIiOiB7CiJkYXRhYmFzZSI6ICJyZWZsZXhfZW5naW5lIiwKInVzZXIiOiAicm9vdCIsCiJwYXNzd29yZCI6ICJ3b3JkIgp9Cn0K
      - PYTHONUNBUFFERED=true
  db:
    image: mariadb
    environment:
      - MYSQL_DATABASE=reflex_engine
{% endhighlight %}

## Reflex Engine in SystemD

Install the code somewhere (such as `/app/reflex`) and setup SystemD like:

{% highlight systemd %}
[Unit]
Description=Reflex Engine
After=named-chroot.service

[Service]
User=reflex
Group=reflex
# loathe
EnvironmentFile=/app/reflex/.env
ExecStart=/app/reflex/bin/reflex-engine
WorkingDirectory=/app/reflex
Restart=always
StandardOutput=syslog
StandardError=syslog

[Install]
WantedBy=multi-user.target
{% endhighlight %}

-

&raquo; [Next: Reflex Tools](/docs/reflex-tools/)
