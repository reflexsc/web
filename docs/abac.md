---
layout: docs
title:  What is ABAC?
permalink: /docs/abac/
---
ABAC is attribute based access controls.  It is the modern way to support security in the world of cloud computing, where assets exist across many different places.  With ABAC it is the combination of several attributes that makes for a final security decision, rather than a single password, apikey, or similar.

ABAC is critical to Reflex's functionality, because you can load an APIKey as one attribute into a saas provider, but have additional attributes in order for the secrets to be divulged, such as the hosting IP address, client certificates, headers and other parts of the ecosystem that may exist.

Because of this, your secrets store can be accessible from many sources, and parts of your access credentials can be in less secure systems (such as a build system hosted off your network) and yet the delivery of secrets at run-time are still protected.  If your build system is compromised and your APIKeys are lost, access to the secrets are still not possible.
