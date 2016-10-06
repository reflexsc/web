---
layout: post
title:  Are we building Helicopters?
author: Brandon Gillespie
date:   2016-10-04 07:56:19 -0600
categories: overview
---
# Imagine

Imagine the world of server automation as a factory for airplanes. But when a change or repair is needed, the plane is returned to the factory. This works fine, if only one type plane is made; but the real world demands all shapes and functions of flying machines—not just one type of plane.  They are needed for a variety of things, and this means they are shaped differently.

Some have two wings, a single engine, and a slender fuselage for two people. Another needs a large hull to hold 300 passengers, with extended wings and four engines to make sure it stays in the air. To make things even more complicated, there is also a team that wants the wings made thin and spun in circles from the top--not much like a normal airplane at all.

Servers, in this metaphor, also have a wide variety of sizes and shapes.  To deal with this, an assortment of software has matured to automate the changes, like Puppet, Chef, Salt, and Ansible. All of this software is excellent at what it does, which is to create run books, robots and a variety of processes for each type of server, or to continue the metaphor, for each type of airframe.

But these systems are fundamentally flawed.  They run the factory by sending automated robots out to each individual plane, making the repair, then returning for the next required change.  

These tools struggle with the challenge of having many different assembly lines, when a single change applies to all of them. In addition to this, there is usually no process to manage updating the automation itself.  This presents a maintenance problem: should another system be made to maintain the automation?

# The Application Factory

What this scenario has missed, is next door to the server factory lies the application factory.  It takes the variety of airframes coming from the server factory and adds more than just avionics, cushy seats for the passengers, and a new coat of paint. In some cases it replaces the wings and engines—putting out an entirely new flying machine.

The important distinction is this application factory produces a different variant on the flying machines, uniquely tailored to meet each of its customer’s needs. With some customers, such as a passenger airline, the expectation is very high that there are no problems, so the flying machine is run through a variety of tests both on the ground and in the air before it is put into use. But sometimes the customers are the very workers themselves, who don’t mind the occasional crash—so they take things out for a frequent solo test flight, just to see how well it works.

# The Assembly Line

This application factory has also learned something very interesting. Through tool and process efficiencies in assembling and testing the flying machines, they have made a system that automatically creates and tests a new flying machine, regardless of the customer.

With this system they can easily make a change to their design, create a new machine and run it for a test flight. If the machine crashes at the end of the runway, that is okay because they can just make a new one.

This is the important difference, that defines the purpose of Ephemeral containers and services.

Rather than bringing back the old flying machine for an update, they get a new one from the assembly line, and discard the old one. This process is known as a continuous delivery and DevOps application automation. The point of DevOps and continuous delivery is to have automation around changes and tests as part of a pipeline which can be evaluated in different phases with different data to verify things are okay.

This brings up a problem for the server factory, because it still wants to bring the old flying machine back for updates. The server factory is wrestling with all of the constant changes introduced by the application factory, and they are frustrated at having so many different assembly lines. In their world they have a regular process of updates to the flying devices, they focus on each individual plane, and they find it extremely challenging to bring back a plane that has been delivered to the passenger airline for an engine update, only to find out the controls have changed such that the engine update no longer works.

# The Future

Fundamentally, things would be much easier if there is only one factory. The automated testing system used by the second factory should be brought into the server factory. It is not necessary to bring a flying machine in for updates, when we can just make a new one and throw the old away. An innovation in the world of computing—containers—has made it possible to create a special type of polymorphic airframe that can be easily adjusted to any type of application. With this, it no longer matters if we are making planes or helicopters, let alone the complexity of trying to maintain both a plane and a helicopter in the same factory—the factory simply focuses on the polymorphic airframe, which is disposable, so it never has to update anything.

# The Passengers

For all of this to work, there is one fundamental principal that need to be dealt with, and that is the passengers—or in other words the data our applications manipulate. If you are mid-flight and the plane needs to be replaced by a new updated version… what do you do with the passengers? Throwing away the old plane and putting a new one in the air is fine, until it lands and somebody wants to meet Grandma who was on the old plane.

With the new world of continuous delivery we want to replace the plane mid-flight, but the passengers have to remain. Not only do they have to remain, but they cannot notice that the plane was changed.

Fortunately, with the new tools and processes it has become possible to do this without the passengers even noticing, as long as it is built correctly—and this is easily done when one involves the concepts of Ephemeral Applications.

To get into the nuts and bolts of the computer automation… the data used by the application must be abstracted from the application, so that the application can be Ephemeral.

Ask yourself the question—can your service be removed and transparently replaced without data loss?

This process also becomes much simpler and efficient when there is only one factory, not two. The same concepts of DevOps automation and pipelines around applications can be leveraged for servers as well. The result is a service where the applications and servers themselves are a single unit, interchangeable, immutable, stackable, and easy to update through simple replacement.

In this world, when a change is made to the application or infrastructure, it is bundled into a single package called a container. This container includes all of the relevant bits that make up that specific version of the final product (such as the web-server and language stack), and the same container is used in all testing scenarios so you know everything works well together. First, the developers run it through its paces, then the same version is launched with a safe copy of temporary data and flown around a little more. After everybody is confident that it will not be a problem, then the same version again is put into production. When an update comes out, regardless of if it is for the application, web-server or language stack, a new container is made and the process is repeated. The container is never updated. Not only does this reduce administrative complexities, but it makes for very easy roll-back and roll-forward for any type of change, and business continuance is also simplified.

# Reflex

With this model we no longer need to think about if we are building Planes or Helicopters and the complexities that goes with them–instead, we use principles of DevOps and continuous deployment at all levels, treating what was once servers in the same manner as applications, and a lot of the need for legacy server automation fades away.
