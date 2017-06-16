---
layout: why
title:  The State Challenge
permalink: /why/state/
---

Tracking State is the most challenging part of any computer automation system.  Do you store it statically, or live?  A static state system is one where you keep it in an offline form, such as on a filesystem or in a source repository system.  Automating against these is difficult at best.

A live state system is one where you can programatically and easily query a single source of authority to get the current state, and you can just as easily adjust this live state system.  Having a live state is a pre-requisite to successful Infrastructure as Code.

API designed for Reflex was built with the purpose of having a Live State Management system, where it is a single point of authority for different tools to cross integrate. 

For example, if you have a cloud based build service which needs to integrate with an in-house software delivery system running on a secured network, in combination with Docker Cloud managing your container engines, trying to work the integration of each without opening large rifts in your security posture is extremely challenging.


Consider the challenge:

1. Multiple different monitoring tools on a given service:
    * Some internal (behind HA systems) 
    * Some external (so HA shold work and not alarm if only one of a cluster fails)
2. You want to do a deployment, and this deployment will trigger the internal monitors (as it should).

What if you could easily just mark the state on a service as being in deployment, and suspending internal monitoring notifications?

Reflex gives you this capability.

&raquo; [Next: Loose Coupling](/why/loose-coupling/)<br/>
