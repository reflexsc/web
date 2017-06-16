---
layout: docs
title: Reflex Tools
permalink: /docs/reflex-tools/
---

Reflex Tools are the combination of CLI commands available to interface with the Reflex Engine.  You can run them either with the `reflexsc/tools` container, or by doing a [Direct Install](/docs/install#easy-install). 

All commands center around `reflex` as a base command, but some of them also may be run individually as a sub command.  Watch for these shortcuts.

The commands are self-describing (run without arguments for syntax information).

# Command Usage

In the command syntaxes shown below, anything after a question mark is optional, and the pipe `|` character shows alternate options.

## General Setup

Reflex tools supports a few settings in a local config file (encrypted), if you would rather do this than use environment, it can ease common use.  This is not recommended for production use &mdash; although the local config is encrypted, it is not a strong security.

The available setup options:

{% highlight text %}
    reflex setup l?ist|ls        # list configured values
    reflex setup set key=        # set a key, but ask for the value on stdin
    reflex setup set key=value   # set a key to value
    reflex setup get key         # get a key
    reflex setup unset key       # unset a key
    reflex setup wiz?ard         # ask for the main keys interactively
    reflex setup demo            # populate a database with demo data
{% endhighlight %}

## Api Key Management

The apikey, although also available to manipulate with the direct `reflex engine` command, may be more directly managed with this command.

{% highlight text %}
    reflex apikey list
    reflex apikey delete {name}
    reflex apikey create {name}
{% endhighlight %}

## Launch Control

This is used to launch a service &mdash; either within a container, or even from SystemD.  You may use `reflex launch {args}` or `launch {args}`.  If [service-name] is not provided as an argument, it is sought as an environment variable `REFLEX_SERVICE`.

{% highlight text %}
    launch service|app [service-name]           # launch a service
    launch env [service-name]                   # show just the environ
    launch config|cfg [service-name] [--commit] # show just the config
{% endhighlight %}

In the case of `launch config`, it does not manipulate any local files, unless you include `--commit`.

## Reflex Actions

Reflex Actions are a way to localize commonly run commands or steps, for any number of purposes.  They are grouped into a single configuration file for easy management.  Full details are available in the section [Reflex Actions](/docs/reflex-actions/).

{% highlight text %}
    reflex action {args}
    action {args}
    act {args}
{% endhighlight %}

## Configure an Application

An easy templating process to build out a new application, this command will fill in the Pipeline, Service and Configuration objects with boilerplate settings.

{% highlight text %}
    reflex app {args}
    app {args}
{% endhighlight %}

## Reflex Engine

This command is used to directly manipulate objects in the Reflex Engine.  Full details on these objects are available in the [Reflex Objects](/docs/objects) section of the manual.

You may use any of the commands:

{% highlight text %}
    reflex engine {args}
    engine {args}
    rxe {args}
{% endhighlight %}

A more indepth breakdown:

{% highlight text %}
Usage: rxe {object} {action} [args & options]

    {object} is one of:

        pi?peline|se?rvice|svc|co?nfig|cfg|re?lease|in?stance|api?key|policy|policyscope|group|state

    {action} is one of:

        li?st|ls|cr?eate|get|ed?it|up?date|merge|set|del?ete|rm|co?py|cp|sl?ice

Arguments and options vary by action:

=> rxe {object} li?st|ls [name-filter] [-e=expr] [-s=col,col]
   [name-filter] is a regex to limit name matches
   --ex?presssion|-e provides a logical expression referencing obj.{key} in
       dot notation (i.e. obj.stage="STG").  python expression syntax.
   --sh?ow|-s is a comma list of available columns: name, title, id, updated

=> rxe {object} cr?eate {name} [-c=json]
   If --c?ontent|-c is not specified, reads content from stdin.

=> rxe {object} get {name} [key]
   {name} is the absolute name of the object
   [key] is an optional key in dot notation (.e. obj.name)

=> rxe {object} ed?it {name}
   edit object named {name} in your environment's $EDITOR.  If $EDITOR is
   undefined, defaults to vim

=> rxe {object} up?date {name} [-c=json]
   Updates {name} with full json object
   If --c?ontent|-c is not specified, reads content from stdin.

=> rxe {object} merge|set {name} [-c=json]
   Updates {name} with a dictionary merge of content
   If --c?ontent|-c is not specified, reads content from stdin.

=> rxe {object} del?ete {name}

=> rxe {object} co?py|cp {from-name} {to-name}

=> rxe {object} slice {name-filter} {limit-expression} {key}
   create a cross sectinoal set-union of {key} values on all objects matching
   {name-filter} and {limit-expression}
{% endhighlight %}

# From Container

To run from a container, try the following (Make sure you have `REFLEX_URL` and `REFLEX_APIKEY` set in your environment)

{% highlight bash %}
    docker run --rm -it \
                 -e REFLEX_URL=$REFLEX_URL \
                 -e REFLEX_APIKEY=$REFLEX_APIKEY \
                 reflexsc/tools reflex {...args...}
{% endhighlight %}

Or if you are in bash, you can simiplify this by making 'reflex' a function that calls docker:

{% highlight bash %}
    reflex() {
        docker run --rm -it \
                 -e REFLEX_URL=$REFLEX_URL \
                 -e REFLEX_APIKEY=$REFLEX_APIKEY \
                 reflexsc/tools reflex "$@"
    }

    reflex engine service list
{% endhighlight %}

-

&raquo; [Next: Reflex Actions](/docs/reflex-actions/)
