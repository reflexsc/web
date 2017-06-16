---
layout: docs
title:  Reflex Policies (Bringing it together)
permalink: /docs/policies/
---

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
* __`pwin(password, group)`__ -- true if password matches any of the hashes in the designated group object

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

-

&raquo; [Next: Install](/docs/install/)
