---
layout: why
title:  Modern Security
permalink: /why/security/
---

The Modern computing world has a challenge.  Everything is always on, and there is a broad reach of interconnectivity.  This makes it difficult to easily manage secrets across a variety of systems you may not always control (such as various SaaS providers).

Attribute Base Access Control (ABAC) is the modern way to support security in the world of cloud computing, where assets exist across many different places.  With ABAC it is the combination of several attributes that makes for a final security decision, rather than a single password, apikey, or similar.

Another way of looking at it is that Role Based Access Control (RBAC) -- the way we've authenticated things historically -- is a *Single Factor* type authentication system, where ABAC is more in parallel with a *Multi Factor* authentication system.  Each attribute (or factor) compounds the level of security, if applied properly.

ABAC is critical to Reflex's functionality, because you can load an APIKey as one attribute into a saas provider, but have additional attributes in order for the secrets to be divulged, such as the hosting IP address, client certificates, headers and other parts of the ecosystem that may exist.

Furthermore, Reflex Engine applies ABAC ***at the object/row level***.  What this means is that each ABAC policy may be applied individually to each object, rather than as a service in general.  If you think of how a conventional database works, it applies RBAC type security at a database wide or perhaps table level.  Once you have access to a table, you can see anything in that table.  With the Reflex Engine ABAC, you can granularly grant access to individual objects within a table, and even to attributes on an object--such as sensitive data!

Because of this, your secrets store can be accessible from many sources which may be globally distributed, and parts of your access credentials can be in less secure systems (such as a build system hosted off your network) and yet the delivery of secrets at run-time are still protected.  If your build system is compromised and your APIKeys are lost, access to the secrets are still not possible.

-

&raquo; [Next: Ephemeral Applications](/why/ephemeral/)<br/>
