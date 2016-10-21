---
layout: docs
title:  Attribute Based Access Controls (ABAC)
permalink: /docs/abac/
---

# What is ABAC?

Attribute Base Access Control (ABAC) is the modern way to support security in the world of cloud computing, where assets exist across many different places.  With ABAC it is the combination of several attributes that makes for a final security decision, rather than a single password, apikey, or similar.

Another way of looking at it is that Role Based Access Control (RBAC) -- the way we've authenticated things historically -- is a *Single Factor* type authentication system, where ABAC is more in parallel with a *Multi Factor* authentication system.  Each attribute (or factor) compounds the level of security, if applied properly.

ABAC is critical to Reflex's functionality, because you can load an APIKey as one attribute into a saas provider, but have additional attributes in order for the secrets to be divulged, such as the hosting IP address, client certificates, headers and other parts of the ecosystem that may exist.

Furthermore, Reflex Engine applies ABAC ***at the object level***.  What this means is that each ABAC policy may be applied individually to each object, rather than as a service in general.  If you think of how a conventional database works, it applies RBAC type security at a database wide or perhaps table level.  Once you have access to a table, you can see anything in that table.  With the Reflex Engine ABAC, you can granularly grant access to individual objects within a table, and even to attributes on an object--such as sensitive data!

Because of this, your secrets store can be accessible from many sources which may be globally distributed, and parts of your access credentials can be in less secure systems (such as a build system hosted off your network) and yet the delivery of secrets at run-time are still protected.  If your build system is compromised and your APIKeys are lost, access to the secrets are still not possible.


# Bringing it together

Every time an object is accessed, the ABAC *policies* are evaluted using the *attributes* relevant to the requesting session.  The policy is evaluated as a logical expression, using limited python syntax.  The namespace available includes the following.  Some attributes may be zero length strings, if they are not in the current session.  Some attributes may also use a "dictlib.Obj" syntax where you can use `obj.name` syntax instead of `obj['name']` -- for performance, this is not available in all cases.

* __`re`__ -- regular expression library (re from python)
* __`rx()`__ -- shortcut for re.search
* __`cert_cn`__ -- common name of the client SSL certificate *pending implementation*
* __`user_name`__ -- the HTTP Basic Auth username *pending implementation*
* __`ip`__ -- the client IP address (as a string)
* __`token_nbr`__ -- the internal number of the authorized token
* __`token_name`__ -- the name of the authorized token
* __`http_headers`__ -- a dictionary containing the HTTP headers of the current session (dictlib.Obj dot parameter notation is available)
* __`groups`__ -- a sub dictionary containing all of the available groups of tokens (dictlib.Obj dot parameter notation is available)
* __`action`__ -- the action being performed (read, write)
* __`sensitive`__ -- a boolean expression defining if the current access request is for sensitive data or not (to be decrypted).  If a policy of this nature evaluates false, the data element is not decrypted, but the overall object may still be returned.
* __`obj_type`__ -- the type of object (config, instance, service, etc)
* __`obj`__ -- the object in question

There are two data elements that are used to define a complete ABAC scenario for an object:

* __The Policy__ -- where the access expression is defined
* __The Policy Scope__ -- an object that defines how the policy is matched to other objects

The Policy Scope is a separate expression that is used to limit policies to specific data.

Policies should be focused on analyzing data unique to the session, not the object.  Where Policy Scopes should be focused on the object itself.  Scope expressions are evaluated whenever an object changes, where Policy objects are evaluated when an object is accessed.

Example Policy Expressions:

{% highlight python %}
    token_name == "master"     # the master user (i.e. root)
    rx(r'^10\.0', ip)
    token_name in groups.dev_team
    token_name in groups.dev_team and sensitive == True and rx(r'^10\.0', ip)
{% endhighlight %}

Example Scope Expressions:

{% highlight python %}
    obj['name'][:3] == "res"
    obj_type == "config"
    rx("-common-", obj.name)
{% endhighlight %}

