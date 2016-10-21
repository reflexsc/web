---
layout: docs
title: Reflex Services and Lauch Assist TUTORIAL
permalink: /docs/tutorial-services/
---

This Tutorial walks through the process of using the Reflex Engine demo setup with Launch Assist to run a container.

You should already have an understanding of Docker before proceeding.

Assumptions:

* You have a docker service running.  This can be a standalone server, or a managed service of some sort.  For the purpose of the example, I will refer to using `Docker Cloud` (Free controller for one node).
* You have docker installed locally as well (Mac or Linux).
* You have tried the [Test Drive](/docs/install/#test-drive)

The steps of this extended demo are:

1. [Setup Reflex Tools](/docs/reflex-tools/) locally
2. [Setup a Reflex Engine](#setup-reflex-engine)
3. [Build a Service](#build-the-service) to use Reflex
4. [Build a Pipeline](#build-the-pipeline) (with external actions)

# Setup Reflex Tools

These steps are described in the [Reflex Tools](/docs/reflex-tools/) section.

# Setup Reflex Engine

1. Create a MariaDB database service.  Identify the db server name, database name, and the user/password with DDL rights.
2. Create configuration for Reflex Engine.  Example below (You can use any arguments available to the [MySQL connector](https://dev.mysql.com/doc/connector-python/en/connector-python-connectargs.html)):

{% highlight bash %}
    cfg=$(base64
    { "db": {
      "database": "reflex_engine",
      "host": "reflex-db",
      "user": "root",
      "password": "FZ@m5GZP1KJf0Tp9ARCr"
    }}
    END
    )
    echo REFLEX_ENGINE_CONFIG=$cfg
{% endhighlight %}

3. Define your Reflex Engine service.  In Docker cloud you could create a stack using the following configuration:

{% highlight yaml %}
reflex-engine:
    image: reflexsc/engine:latest
    environment:
        - 'REFLEX_ENGINE_CONFIG=eyAiZGIiOiB7CiAgImRhdGFiYXNlIjogInJlZmxleF9lbmdpbmUiLAogICJob3N0IjogInJlZmxleC1kYiIsCiAgInVzZXIiOiAicm9vdCIsCiAgInBhc3N3b3JkIjogIkZaQG01R1pQMUtKZjBUcDlBUkNyIgp9fQo='
    ports:
        - "54000:54000"
    autoredeploy: true
    sequential_deployment: true
{% endhighlight %}

4. Deploy the engine and verify it connects to its database and can communicate on its service port (54000).
5. Optionally: setup SSL in front of Reflex Engine (with a load balancer or nginx).  For production it is strongly urged to run this behind an SSL service.
6. Identify the `REFLEX_URL`, which will be the service address, port, and `/api/v1`.  Example: `http://myservice.location:54000/api/v1`.
7. Use reflex tools to set your REFLEX_URL/APIKEY and then populate Reflex Engine with demo data:

{% highlight bash %}
reflex setup set REFLEX_URL=...  # note: this will not work if running reflex tools in a container
reflex setup set REFLEX_APIKEY=...  # note: this will not work if running reflex tools in a container
reflex setup demo
{% endhighlight %}

# Build the Service

Todo: Make bringing Reflex Tools into an existing container easier (pip install).

***Step-1: Create a docker hello-world***

Create a new container named `bct-tst` -- this will use the demo service of the same name.  For this example we will extend the reflexsc/engine container (because it already has reflex tools as well as the engine).  Create a new Dockerfile:

{% highlight yml %}
FROM reflexsc/engine

RUN yum -y install nginx && yum clean all

RUN touch /usr/share/nginx/html/local.xml.in

ENTRYPOINT ["/app/reflex/bin/launch", "service"]
{% endhighlight %}

The first thing you may notice is the unique Entrypoint.  This is how Reflex works in an Infrastructure as Code polymorphic manner, and the tool is [Launch Assist](/docs/launch-assist/).  Instead, we set how the service launches on the [Pipeline](/docs/objects/#pipeline).

***Step-2: Build the container***

Standard docker build.  Try something like:

{% highlight bash %}
    docker build -t hello-world .
{% endhighlight %}

***Step-2: Setup the bct pipeline***

In the `Dockerfile` we specified an ENTRYPOINT for Launch Assist.  Now we need to define what the containe will actually do.  We set the entrypoint on the `bct` pipeline with:

{% highlight bash %}
    reflex engine pipeline merge bct <<END
	 {
	  "launch": {
	   "cfgdir":"/var/www/html",
	   "exec":["/usr/sbin/httpd", "-DFOREGROUND"],
	   "rundir":"/"
	  }
	 }
END
{% endhighlight %}

This establishes how the container should be run (see the [Pipeline](/docs/objects/#pipeline) for additional info).  Notably, we are telling Launch Assist that our "config" directory is the nginx root, and we are telling it how to execute with `exec` (similar to `ENTRYPOINT` in the dockerfile.

With this approach, when the container is run launch assist calls out to Reflex Engine, gets the launch information above, and executes in that context.  Because it is running from within the container, it has an opportunity to lay down configurations and run other commands as desired, while still maintaining the ephemeral nature of the container, as well as security (as you have not had to store your configurations in environment variables, nor within the container image itself).

We tell Launch Assist what service to run through the environment variable `REFLEX_SERVICE`, which points to the Reflex Engine [Service Object](/docs/objects/#service), and that in turn pulls in the [Pipeline](/docs/objects/#pipeline) and any [Configuration](/docs/objects/#config) objects.

You will also notice we used the action `merge`.  This allows us to make incremental changes.  We could also have run `edit` and reflex would have brought us into an editor, or `update` which would take the complete object from the CLI.

***Step-3: Test the configuration***

You can test what will happen by running launch assist yourself, with the `config` argument instead of `service`.  You also have the option of including the service on the command line, which will override the environment variable:

{% highlight bash %}
	launch config bct-tst --commit
{% endhighlight %}

It will likely error and fail, as the `--commit` argument tells it to write any changes to disk, and your local machine may not refelect the same `cfgdir`.  You can leave off `--commit` and it will just resolve the objects and print the combined result to your screen.

***Step-5: Run the container***

Now just launch the container.  You need to include the three environment variables, even if you have set them locally, because this is telling Docker to let the container use those variables.  If running locally try one of the following (the second option is useful when your configurations are stored):

{% highlight bash %}
    docker run --rm -it \
         -e REFLEX_URL=$REFLEX_URL \
         -e REFLEX_APIKEY=$REFLEX_APIKEY \
         -e REFLEX_SERVICE=bct-tst \
         --publish 80:80 \
         hello-world
{% endhighlight %}

{% highlight bash %}
    docker run --rm -it \
         -e REFLEX_URL=$(reflex setup get REFLEX_URL) \
         -e REFLEX_APIKEY=$(reflex setup get REFLEX_APIKEY) \
         -e REFLEX_SERVICE=bct-tst \
         --publish 80:80 \
         hello-world
{% endhighlight %}

**A note on docker networking**: The container is likely running on a bridge network, and if your `REFLEX_URL` is set to `localhost` it will not be able to route appropriately!  You will need to set your `REFLEX_URL` to something which the bridge network can talk to, such as your external IP address.

For a Docker Cloud stack file, you would need to push `hello-world` to your registry and try something like:

{% highlight yaml %}
hello-engine:
    image: you/hello-world
    entrypoint:
        - 'REFLEX_URL=http://your-engine-address:54000/api/v1'
        - 'REFLEX_APIKEY=master.abcdefg...'
        - 'REFLEX_SERVICE=bct-tst'
    ports:
        - "80:80"
    autoredeploy: true
    sequential_deployment: true
{% endhighlight %}

When this is run, the logfile may look something like:

{% highlight text %}
2016-10-21 23:08:20 Processing config object bct-tst
2016-10-21 23:08:20 Processing config object bct-config1
2016-10-21 23:08:20 CONFIG bct-config1 into /var/www/html/local.xml
2016-10-21 23:08:20 Processing config object bct-config2
2016-10-21 23:08:20 CONFIG bct-config2 into /var/www/html/local-production.json
2016-10-21 23:08:20 Processing config object bct-keystore
2016-10-21 23:08:20 CONFIG bct-keystore into /var/www/html/local.keystore
2016-10-21 23:08:20 export APP_CFG_BASE=/var/www/html
2016-10-21 23:08:20 export APP_PIPELINE=bct
2016-10-21 23:08:20 export APP_RUN_BASE=/
2016-10-21 23:08:20 export APP_SERVICE=bct-tst
2016-10-21 23:08:20 export MONGO-URI=mongodb://test-db/test_db
2016-10-21 23:08:20 export TMPDIR=.
2016-10-21 23:08:20 Launch Env:
  APP_PIPELINE=bct
  APP_CFG_BASE=/var/www/html
  MONGO-URI=mongodb://test-db/test_db
  APP_RUN_BASE=/
  TMPDIR=.
  APP_SERVICE=bct-tst

2016-10-21 23:08:20 Launch working directory:
  /
2016-10-21 23:08:20 Launch exec:
  '/usr/sbin/httpd', '-DFOREGROUND'
AH00558: httpd: Could not reliably determine the server's fully qualified domain name, using 172.17.0.2. Set the 'ServerName' directive globally to suppress this message
{% endhighlight %}

Note: the error given is normal for apache under this circumstance.

At this point, you can test if all worked well by using curl to pull the "secret" config file (normally you would never put cfgdir as your public files folder):

{% highlight bash %}
curl http://localhost/local-production.json
{% endhighlight %}

And the resulting output should look like the db section of your configuration, which Launch Assist extracted from Reflex Engine (where it was stored encrypted) and then saved to the local container:

{% highlight bash %}
{"db":{"pass":"not a good password","replset":"{'rs_name': 'myReplicaSetName'}","server":"test-db","db":"test_db","user":"test_user"}}
{% endhighlight %}

Note: there is an option to have Launch Assist send the configuration directly to STDIN of your process.  &gt;todo: future docs&lt;

Next Tutorial:

* [Linking Pipelines](/docs/tutorial-pipeline/)
