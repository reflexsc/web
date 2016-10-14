---
layout: post
title:  Are we building Helicopters?
author: Brandon Gillespie
permalink: /helicopters/
---

# Imagine

Consider the world of server automation as a factory for airplanes… but when a repair is needed, the plane is returned to the factory. This works fine if only one type plane is made; but the real world demands all shapes and functions of flying machines—not just one type of plane.

Some have two wings and a single engine. Others must hold 300 passengers, with four engines to make sure it stays in the air. To make things even more complicated, there is also a team that wants the wings made thin and spun in circles from the top (there always has to be somebody different).

Servers, in this metaphor, also have a wide variety of sizes and shapes. To deal with this, an assortment of software has matured to automate the changes, like Puppet, Chef, Salt, and Ansible. All of this software is excellent at what it does, which is to create run books, robots and a variety of processes for each type of server, or for each type of airframe.

But these systems are fundamentally flawed. They run the factory by sending automated robots out to each individual plane parked in neat rows throughout the factory, the robot makes the repair, then returns for the next required change.

These tools struggle with the challenge of having many different shapes of planes, let alone planes at different points in their lifecycle from new to well used.

What this scenario has missed, is next door to the server factory lies the application factory. It takes the variety of airframes coming from the server factory and adds more than just cushy seats and a new coat of paint. In some cases it replaces the wings, avionics and engines—putting out an entirely new flying machine based on their own needs.

# The Assembly Line

This application factory has also learned something very interesting. Through tool and process efficiencies in assembling and testing the flying machines, they have made a system that automatically creates and tests a new flying machine, regardless of the customer, and it does it as an assembly line.

With this system they can easily make a change to their design, create a new machine, run it down the assembly line of tests and validation and then run it for a test flight. If the machine crashes at the end of the runway, that is okay because they can just make a new one.

This is the important difference which defines the purpose of Ephemeral services.

Rather than bringing back the old flying machine for an update and retrofitting it to meet the changed design, they get a new one from the assembly line and discard the old one.

This brings up a problem for the server factory, because it still wants to bring the old flying machine back for updates. The server factory is wrestling with all of the constant changes introduced by the application factory, and they are frustrated at having so many different types of planes and helicopters.

In their world they have a regular process to update the planes, and they find it extremely challenging to bring back a plane that has been delivered to the passenger airline for an engine update, only to find out the controls have changed such that the engine update no longer works.

# The Future

Fundamentally, things would be much easier if there is only one factory. The automated testing system (assembly line) used by the second factory should be brought into the server factory. It is not necessary to bring a flying machine in for updates, when we can just make a new one and throw the old away.

An innovation in the world of computing—containers—has made it possible to create a special type of polymorphic airframe. With this, it no longer matters if we are making planes or helicopters, let alone the complexity of trying to maintain both a plane and a helicopter in the same factory—the factory simply focuses on the polymorphic airframe, which is disposable, so it never has to update anything.

# Reflex

To make this work well, we need to stop treating our containers like servers.  We need to think about services, not servers or containers.  The service should be addressable programatically, using a common API (not static YML files), the container itself should be polymorphic, so you can change how it behaves simply by how it is started and its environmental configuration is delivered into the container each time it starts--securely and reliably.

## [Next: How it Works?](/docs/)

