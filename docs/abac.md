---
layout: docs
title:  Attribute Based Access Controls (ABAC)
permalink: /docs/abac/
---

# What is ABAC?

ABAC is attribute based access controls.  It is the modern way to support security in the world of cloud computing, where assets exist across many different places.  With ABAC it is the combination of several attributes that makes for a final security decision, rather than a single password, apikey, or similar.

ABAC is critical to Reflex's functionality, because you can load an APIKey as one attribute into a saas provider, but have additional attributes in order for the secrets to be divulged, such as the hosting IP address, client certificates, headers and other parts of the ecosystem that may exist.

Because of this, your secrets store can be accessible from many sources, and parts of your access credentials can be in less secure systems (such as a build system hosted off your network) and yet the delivery of secrets at run-time are still protected.  If your build system is compromised and your APIKeys are lost, access to the secrets are still not possible.

# Bringing it together

Every time an object is accessed, the ABAC *policies* are evaluted using the *attributes* relevant to the requesting session.  The policy is evaluated as a logical expression, using limited python syntax.  The namespace available includes the following.  Some attributes may be zero length strings, if they are not in the current session.

* __obj__ -- the object in question
* __rx__ -- regular expression library (re from python)
* __cert_cn__ -- common name of the client SSL certificate *pending implementation*
* __user_name__ -- the HTTP Basic Auth username *pending implementation*
* __ip__ -- the client IP address (as a string)
* __token_nbr__ -- the internal number of the authorized token
* __token_name__ -- the name of the authorized token
* __http_headers__ -- a dictionary containing the HTTP headers of the current session
* __groups__ -- a sub dictionary containing all of the available groups of tokens
* __sensitive__ -- a boolean expression defining if the current access request is for sensitive data or not (to be decrypted).  If a policy of this nature evaluates false, the data element is not decrypted, but the overall object may still be returned.

There are two data elements that are used to define a complete ABAC scenario for an object:

* __The Policy__ -- where the access expression is defined
* __The Policy Scope__ -- an object that defines how the policy is matched to other objects

The Policy Scope is a separate expression that is used to limit policies to specific data.

Policies should be focused on analyzing data unique to the session, not the object.  Where Policy Scopes should be focused on the object itself.  Scope expressions are evaluated whenever an object changes, where Policy objects are evaluated when an object is accessed.

Example Policy Expressions:

{% highlight python %}
    token_name == "master"     # the master user (i.e. root)
    re.search(r'^10\.0', ip)
    token_name in groups.dev_team
{% endhighlight %}

Example Scope Expressions:

{% highlight python %}
    obj.name[:3] == "res"
    obj.type == "parameter"
    re.search("-common-", obj.name)
{% endhighlight %}

