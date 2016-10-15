---
layout: docs
title: Reflex API
permalink: /docs/api/
---

The API follows similar patterns:

* [Response Messages](#response-messages) -- API responses send an object or a response message
* [Authorizing](#authorizing) -- an [API Key](/docs/apikeys/) is one of the attributes for [ABAC](/docs/abac/).
* [Manipulating Objects](#manipulating-objects) -- using REST/CRUD methods
* [Extended Object Actions](#extended-object-actions) -- additional actions on objects beyond CRUD

# Response Messages

In the case where things did not work properly, or no expected data was to be recieved, the service will include a 'response object'
as JSON, which describes the result.  There at least two attributes: `status`, and `message`.   Status is either `success` or `failed` and
message is a free-form string describing the result.

Example:

{% highlight json %}
    {
        "status": "failed",
        "message": "Unable to find object"
    }
{% endhighlight %}

# Authorizing

Although a variety of attributes may be included as part of the policies, at a minimum an [API Key](/docs/apikeys/) must be used on most APIs.

The process of [authorizing an APIKey is described separately](/docs/apikeys).

If you call an API and you have not authorized an APIKey, the service will send a response of `401 Unauthorized` with a failed [Response Message](#response-messages).

# Manipulating Objects

All objects follow the same pattern, although some of them [have extended actions](#extended-object-actions).

The object types are fully described in the [Reflex Objects Overview](/docs/objects/).

* [pipeline](/docs/objects#pipeline) - The "top level" object which relates to sets of services.
* [service](/docs/objects#service) - A specific service running for a single purpose, lane, region or tenant.
* [config](/docs/objects#config) - configuration management
* [instance](/docs/objects#instance) - an instance of a service.  many instances can relate to a single service
* [release](/docs/objects#release) - a release of code, relates to a service
* [policy](/docs/objects#policy) - an ABAC Policy
* [apikey](/docs/objects#apikey) - an API Key
* [group](/docs/objects#group) - a grouping of API keys for policy management

## List (GET)

	GET /api/v1/{:object-type}/
	GET /api/v1/{:object-type}/?match={:filter}
	GET /api/v1/{:object-type}/?cols={:columns}

On Success: *200 Ok*

Result: application/json array of objects, with default columns (or those requested by cols) and optionally limited by the match filter, which is a glob string.

{% highlight json %}
[
    {"column":"value"},
    {"column":"value"}
]
{% endhighlight %}

Other results may include:

* 401 Unauthorized
* 404 Not Found -- object not found
* 400 Bad Request --  you sent a query that was unparseable (bad filter or cols)

## Read (GET)

	GET /api/v1/{:object-type}/{:object-name}
	GET /api/v1/{:object-type}/{:object-id}

On Success: *200 Ok*

Result: application/json object of requested Reflex Object. Example:

{% highlight json %}
{
    "name": "value",
    "sensitive": {
        "data": "value"
    }
}
{% endhighlight %}

Other results may include:

* 401 Unauthorized -- check logs for further detail
* 404 Not Found -- object not found
* 400 Bad Request --  you sent a query that was unparseable (bad filter or cols)

## Create (POST)

	POST /api/v1/{:object-type}
	
	{:object}

On Success: *201 Created*, with a result object including any warnings.

Creates a new object of `{:object-type}` using the complete object data specified in JSON object `{:object}`

Possible results may include:

* 401 Unauthorized -- check logs for further detail
* 400 Bad Request -- the `{:object}` is not correct.  Details in the result message.

## Update (PUT)

	PUT /api/v1/{:object-type}/{:object-name}
	PUT /api/v1/{:object-type}/{:object-id}

	{:object}

On Success: *200 Ok*, with a result object including any warnings.

Creates a new object of `{:object-type}` using the complete object data specified in JSON object `{:object}`

Possible results may include:

* 202 No Change
* 401 Unauthorized -- check logs for further detail
* 404 Not Found -- specified object does not exist
* 400 Bad Request -- the `{:object}` is not correct.  Details in the result message.

## Patch (PUT)

	PUT /api/v1/{:object-type}/{:object-name}?merge=true
	PUT /api/v1/{:object-type}/{:object-id}?merge=true

	{:delta-object}

On Success: *200 Ok*, with a result object including any warnings.

Merges `{:delta-object}` into complete object already in database.

Possible results may include:

* 202 No Change
* 401 Unauthorized -- check logs for further detail
* 404 Not Found -- specified object does not exist
* 400 Bad Request -- the `{:object}` is not correct.  Details in the result message.

## Delete (DELETE)

	DELETE /api/v1/{:object-type}/{:object-name}
	DELETE /api/v1/{:object-type}/{:object-id}

On Success: *200 Ok*, with a result object.

Possible results may include:

* 401 Unauthorized -- check logs for further detail
* 404 Not Found -- specified object does not exist

# Extended Object Actions

Beyond the basic CRUD actions, some objects (such as Config) support additional calls, described here.

## Config Flatten

Because Config objects are nested and have inheritance, you can call a base object and ask for it to be flattened.


