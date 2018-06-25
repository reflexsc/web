---
layout: docs
title: Install
permalink: /docs/install/
---

There are two parts to Reflex: The Tools (Client) and the Engine (Server).

Three different guides are available:

* [**Test Drive**](#test-drive) &mdash; Easy test drive of all parts, using Docker.
* [**Install Client**](#install-reflex-tools-client) &mdash; Install the Tools (Client)
* [**Install Engine**](#install-reflex-engine) &mdash; Install the Engine

# Test Drive

For an easy test drive with little commitment, you can use [Docker](https://www.docker.com/products/overview), using a wrapper bash script `demoengine.sh`.  There are a few steps:

1. Install [Docker](https://www.docker.com/products/overview)
2. Download the demo script (it wraps the server and the client containers)
3. Run the server (Reflex Engine)
4. Load sample data (optional)
5. Play with it via the CLI

To make this happen, start by pulling the demo script:

```
curl -sLO https://raw.github.com/reflexsc/reflex/master/.pkg/demoengine.sh
chmod +x demoengine.sh
```

Then run the engine:

```
./demoengine.sh engine
```

After the Engine is ready, it will print a `REFLEX_APIKEY`.  This is your master key for the demo database, keep it safe.  If you want to start over, just remove the mariadb container and re-run the engine--it will re-initialize.

Set the key in your environment, by just cutting and pasting the printed value:

```
export REFLEX_APIKEY=... # from above
```

Next, initialize the mock data, using the tools container, and then try a reflex engine command to see the services:

```
./demoengine.sh reflex setup demo --confirm
./demoengine.sh reflex engine service list
./demoengine.sh reflex launch config bct-tst
```

Bonus! Some of the data in the demo set is the same data used in the [Object documentation](/docs/objects/).  Additional details on what is supported by the `reflex` command are available in the [Reflex Tools](/docs/reflex-tools/) section.

When you are done, don't forget to cleanup:

```
docker-compose down
```

# Install Reflex Tools (Client)

Reflex Tools are supported in MacOS and Linux, with Python version 3.  Some Reflex Tool functionality also works in Python 2, but it is not a supported feature set.

Use PIP to load the reflex commands:

```
pip3 install -U rfxcmd
```

Note: On MacOS you may want to use brew to get python3: `sudo brew upgrade python3`

If you are adding this to an existing docker image, you can extend the container with a Dockerfile like:

```
FROM myfavalpine-image
RUN apk add --no-cache python3 && pip3 install -U rfxcmd
ENTRYPOINT /usr/local/bin/launch
```

After which you move onto service configuration of your container (the `launch` entrypoint will look at Reflex for the rest of what to do).

# Install Reflex Engine

Reflex engine requires MariaDB exist somewhere--this is up to you to get working.  It requires a user which can edit the schema of its own database (have this ready for later during configuration).

## Reflex Engine on Docker

1. Build and push the image for your-repo (Referencing the sample [Dockerfile](https://github.com/reflexsc/reflex/blob/master/doc/swarm/Dockerfile)):
```
docker build -t your-repo/reflex-engine:prd .
docker push your-repo/reflex-engine:prd
```
2. [Configure Reflex Engine](/docs/reflex-engine/)
3. Deploy in Docker Swarm:
   * Deploy the configuration secret:
```
docker secret create REFLEX_ENGINE_CONFIG < REFLEX_ENGINE_CONFIG.json
```
   * Adjust and deploy from the sample [docker-compose.yml](https://github.com/reflexsc/reflex/blob/master/doc/swarm/docker-compose.yml)
```
docker stack deploy -c docker-compose.yml
```

## Reflex Engine - Standalone:

To install it outside of Docker, follow three steps:

1. Install using the pip package:
```
pip3 install -U rfxengine
```

2. Install MySQL Connector
```
get_mysql_connector.py
```

3. [Configure Reflex Engine](/docs/reflex-engine/)

## Source Install

Alternatively, you can pull the source code directly and install in developer mode:

```
git clone https://github.com/reflexsc/reflex.git
cd reflex
./install.sh develop --engine
```

You can also install with `root` instead of `develop`, but this loads the modules from PIP so it may not be as useful.

-

&raquo; [Next: Reference -> Developing](/docs/developing/)

