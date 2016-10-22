---
layout: docs
title: How it Works
permalink: /docs/
---

Reflex has two basic roles:

* [Service Management](#service-management)
* [Secrets and Configurations](#delivery-of-secrets-and-configurations)

# Service Management

Reflex is Service Oriented, meaning it is focused on Services rather than Servers. This is important for the new world of ephemeral systems. Conventional Configuration management systems focus on servers, but in the world of containers, the server is no longer the asset we shold track.

Instead, Reflex pivots its data around Services, and the instances behind those services can be ephemeral or static.

There are three principles at play with Reflex that allow it to be a powerful Service Management solution:  [Loose Coupling](/docs/loose-coupling/), [Live State Management](/docs/iac/#live-state-management) (for Infrastructure as Code), and [Attribute Based Access Controls](/docs/abac/#live-state-management) (ABAC).

## Services and Pipelines

The challenge most systems face is that it is easy to manage a single service, but once we have to offer a service in general production use, we often want to chain them together.  For instance, if you want to have a Test environment followed by a QA and then Production.  This is a Pipeline.

![batleth example](/docs/summary1.jpg){: .img-wrap-right }

Lets use an example application **Bat'leth Combat Training (BCT)**.  For this application, you want to have to running instances.  One is **Test**, one is **Producton**.  You want to deploy changes to Test so you can verify everything is working prior to getting them into Production.

![batleth example](/docs/summary2.jpg){: .img-wrap-left }

This is where Pipelines come into the picture.  Pipelines group together different services, allowing for staging of changes between each.  Within Reflex Engine both are represented as objects, where the Pipeline is the top level object, and services are the pivot point, referencing the pipeline, as well as any other related objects such as Instances and Configurations.

![batleth example](/docs/summary3.jpg){: .img-wrap-right }

It is recommended that you follow a name convention to help understand the relationships.  In this example, `bct` is the name of the pipeline, and we have named the test service `bct-tst` and the production service `bct-prd`.

## Instances

Behind services are a set of Instances.  These may be defined statically, or dynamically (such as with an integration to Docker, Kubernetes, etc).  Instances should be treated ephemerally, meaning that the data on an instance record is mostly the way to communicate with the instance, and if it is healthy or not.

Furthermore, instances are still service oriented.  They are not servers.  An instance is a combination of an address *and* a port.  So you can have many instances on a single server, for instance, if you have many different services running.

# Secrets and Configurations

As the world becomes more distributed with IaaS, PaaS and other "cloud" like software solutions, the security model of [Attribute Based Access Controls](/docs/abac/#live-state-management) becomes critical in maintaining a safe security posture.

Conventional secret management systems are typically secured with a single "key" or password.  But if this key or password is stolen, then your secrets may be compromised.  The logical step is to lock down your secrets database somehow.  But by locking it down, now it is a challenge to use the valuable cloud services that can help you do your job better, so you can stop re-inventing the wheel.

Reflex gives you this capability through ABAC.  You can easily create policies that define a flexible set of attribute based criteria to grant access to individual secrets.  A simple example is a cloud based container management service.  If your controller is from a third party (such as Docker Cloud) where they run the controller but you host your own container services, you have a few common options:

1. Put your secrets into environment variables, stored in Docker Cloud -- yikes, when somebody hacks Docker Cloud, they have all your secrets.
2. Use a secrets data store that is not accessible externally.  Store the secret to this service in docker cloud -- two drawbacks: you do not want to expose your secrets store, and now you cannot access those secrets from other systems--such as your build service.
3. Use attributes, such as certificates, internal IPs and other data which is contextual to your running environment in addition to the key stored in Docker Cloud, to deliver the sensitive secrets to your service at run time.

This last option is how Reflex works.  When somebody violates your cloud controller they will have your API keys, and you may not even know it.  But they do not have the additional attributes, so while your security posture is lowered, you do not have an immediate data breach.

## Configuration Basics

Reflex Configurations are very flexible, designed to store both configurations, as well as secrets--to be delivered at run-time.

Configuration objects ultimately output configuration data, which can in turn be used by your application.  The Configuration objects are JSON documents supporting deep merging for dictionary elements, with inheritance and references to other objects, and ordered set-unions for arrays.

There are three relationship types: `extends`, `imports`, and `exports`.

![batleth example](/docs/summary4.jpg){: .img-wrap-right }

In the shown example, the application *Batleth Combat Training* named `bct`, the `bct-tst` object extends the `bct` object, which extends the `common` object.  Object keys lower in the tree take priority over those higher when used with extends.  So an attribute defined on `bct-tst` would override one defined on `bct` or `common`.

With inheritance, the exports to `bct-config` is also included in `bct-tst` and `bct-prd`, even though it is not defined on the lower objects.

Imports is a way to merge another object into the current one, where it takes priority instead of the current (lower object).  Furthermore, imports does not follow any hierarchy of the imported object--it is just the single object that is merged.

Exports is used to define the configurations which are output to a file (if any).  It is possible to make a configuration that does not output any data to a file, but rather it is assembled and inserted to STDIN of the running service (this is the most secure method).

You can also test the flattening of your object relationships using the Launch Control command (explained later).  *It is important to note that in this example `launch config` refers to the Service name, not the Config name (this is described in the next section).*

{% highlight bash %}
launch config bct-tst  # prints merged JSON to screen
{% endhighlight %}

Or to have it write-out the configs to disk:

{% highlight bash %}
launch config bct-tst --commit
{% endhighlight %}

Details on [Configuration Objects](/docs/objects#config) are in the Object Reference section.

This overall view of the three object types: [*Pipeline*](/docs/objects/#pipeline), [*Service*](/docs/objects/#service) and [*Configurations*](/docs/objects/#config) shows how the `bct` application may have different objects as they come together.  This example also shows the entry point where [*Launch Assist*](/docs/launch-assist/) pivots from, the *Service Object*. 

![batleth example](/docs/summary5.jpg){: .img-center }

