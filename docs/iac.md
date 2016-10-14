---
layout: docs
title:  Infrastructure as Code
permalink: /docs/iac/
---
Infrastructure as Code is the simple concept that your infrastructure and services should be treated in the same manner as you treat code.

Much time has been spent bringing stability to the development cycle, with testing frameworks, code reviews by peers, separate environments, and automated deployment of code.  Yet this same level of maturity rarely exists at the infrastructure level.  Despite all of the automated systems, people still fall back to manually building clusters, routes, storage, and other bits of the infrastructure.

If we follow the desire that Infrastructure is Code, then we should treat it completely the same -- no infrastructure changes happen without code that has been tested, reviewed by a second person, merged into the master branch, and then delivered into production with a delivery system.

Why is this important?

Cross team communication is a challenge.  It is easiest to just be a solo individual, beholden to nobody.  But ultimately we recognize that together we provide greater value than apart.  In the development cycle, we team code.  We ask for developers to review each other's code before it is merged into the master branch.  This is done for quality as well as stability purposes (hopefully the second set of eyes will help identify any potential problems).

When it comes to our platform, we should treat this no differently.  With Infrastructure as Code (IAC) and Devops concepts, we are able to do the same.  Simply defined:

1. IAC is that changes to infrastructure itself are automated as code.  Nobody is clicking in a GUI or running commands by hand to implement things in production.
2. Devops is a combination of partnering app developers with infrastructure developers, and using frameworks for IAC automation and delivery to facilitate the process.

If we use IAC 100%, then developers can define any changes they need and are in full control of their entire application stack, as long as they can describe it using IAC systems.

Just like app code, with infrastructure code should describe the desired state of the platform along with code to do the migration to that state.  It is explored, evaluated and iterated in a development zone, written as code so it can be reviewed by another individual, and then tested and merged into a common production environment.

Three challenges stand in the way of successful IAC:

1. [Bridging the Gap](#bridging-the-gap) - Platform and Infrastructure
2. [Separating Roles](#separating-roles) - R&D effort from the Sustainment
3. [Live State Management](#live-state-management)

# Bridging the Gap

There is a gap between platform systems (software build and delivery) and infrastructure automation systems.  It is closing, but it exists.  This is largely due to different people working in each space, but recognizing the gap is the first step in reconciling it.

# Separating Roles

The work effort to figure something out is often a process of bodgering, hacking and trying with failure after failure until you have success.  Reading a few blogs you can get a feel for what you want, followed by poking through the GUI and trying five or six different variants, until what you have suddenly works.  But it is harder to figure out how to automate it.  This is is the R&D or engineering effort.

You need to figure out how to make it happen using automation--including how to integrate it with an existing complex ecosystem already in place, in a manner that does not disrupt existing production systems (this is usually 95% of the work effort).  Once you have this built, then it is sustainable.

# Live State Management

Tracking State is the most challenging part of any computer automation system.  Do you store it statically, or live?  A static state system is one where you keep it in an offline form, such as on a filesystem or in a source repository system.  Automating against these is difficult at best.

A live state system is one where you can programatically and easily query a single source of authority to get the current state, and you can just as easily adjust this live state system.  Having a live state is a pre-requisite to successful Infrastructure as Code.

API designed for Reflex was built with the purpose of having a Live State Management system, where it is a single point of authority for different tools to cross integrate. 

For example, if you have a cloud based build service which needs to integrate with an in-house software delivery system running on a secured network, in combination with Docker Cloud managing your container engines, trying to work the integration of each without opening large rifts in your security posture is extremely challenging.

Reflex, however, gives you this capability.

