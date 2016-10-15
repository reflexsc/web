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

Lets use an example application Bat'leth Combat Training (BCT). 

![batleth example](/docs/summary1.jpg)

# Secrets and Configurations

As the world becomes more distributed with IaaS, PaaS and other "cloud" like software solutions, the security model of [Attribute Based Access Controls](/docs/abac/#live-state-management) becomes critical in maintaining a safe security posture.

Conventional secret management systems are typically secured with a single "key" or password.  But if this key or password is stolen, then your secrets may be compromised.  The logical step is to lock down your secrets database somehow.  But by locking it down, now it is a challenge to use the valuable cloud services that can help you do your job better, so you can stop re-inventing the wheel.

Reflex gives you this capability through ABAC.  You can easily create policies that define a flexible set of attribute based criteria to grant access to individual secrets.  A simple example is a cloud based container management service.  If your controller is from a third party (such as Docker Cloud) where they run the controller but you host your own container services, you have a few common options:

1. Put your secrets into environment variables, stored in Docker Cloud -- yikes, when somebody hacks Docker Cloud, they have all your secrets.
2. Use a secrets data store that is not accessible externally.  Store the secret to this service in docker cloud -- two drawbacks: you do not want to expose your secrets store, and now you cannot access those secrets from other systems--such as your build service.
3. Use attributes, such as certificates, internal IPs and other data which is contextual to your running environment in addition to the key stored in Docker Cloud, to deliver the sensitive secrets to your service at run time.

This last option is how Reflex works.  When somebody violates your cloud controller they will have your API keys, and you may not even know it.  But they do not have the additional attributes, so while your security posture is lowered, you do not have an immediate data breach.

