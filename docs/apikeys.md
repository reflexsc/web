---
layout: docs
title:  Reflex APIKeys
permalink: /docs/apikeys/
---

Reflex Engine is an [Attribute Based Access Control (ABAC)](/docs/abac/) solution, supporting policies which can use any number of attributes for authorization.  However, one of the more common supported attributes is an authentication token with API keys.

There are two types of data used in this process:

* **[Reflex API Key](#reflex-api-key)** -- a two part string providing your unique identification and a shared secret used for authentication
* **[Reflex API Token](#reflex-api-token)** -- a single use token sent to a server, after authorization of the session is established

Calls made to the API's must use the *[Reflex API Token](#reflex-api-token)* which is specific to a session, where the session is established using the information from the *Reflex API Key*.  This is a two-step process:

1. [Create your Session](#create-your-session): Send the identifier portion of the API key, in a JWT, using the secret portion of the API Key to sign the JWT.
  * In response you are given a session cookie and a session secret.
2. Make [Authorized API Calls](#authorized-api-calls), send a *[Reflex API Token](#reflex-api-token)* with each API Call, for the duration of the session.

# Reflex API Key
The ApiKey is provided with two parts, separated with a period:

	your-identifier.your-secret

Example:

	8f152510-7645-11e6-8bc2-001c4244de11.V1xn1eDdW7McbLG4k7OuNixZvO8qrRQfiapEuH20b9y80QIX+0rbJ9cZFY4hUcImgal/b2/7DNSSSWvqhInrK2RQ

The secret portion is base64 encoded random data, and should be decoded before being used as a secret for a jwt.

However, it is not sent verbatim.  You send it as a JWT with the following payload:

	jti: your-identifier
	seed: 256 bytes of random data
	exp: 5 minutes from now

It is signed by the base64 decoded secret part of the API key, and is sent to the authorization endpoint in the header `X-ApiKey`.

# Reflex API Token

A Reflex API Token is a JWT created using the session information provided by Authorizing the *[Reflex API Key](#reflex-api-key)*, and signed with the session secret provided at the same time.  The Reflex API Token is a one-time use JWT, and includes the following information:

	jti: unique request ID
	exp: 1 minute from now

This JWT is then sent to Reflex Engine's auth endpoint in the `X-ApiToken` header, using the secret part of your apikey to sign the JWT.

# Create Your Session

The first step is to get an Authorized Session.  Use the *[Reflex API Key](#reflex-api-key)* to create an API Key JWT as described in the *[Reflex API Key](#reflex-api-key)* section.

Example (Node.js):

{% highlight javascript %}
var apikey = "8f152510-7645-11e6-8bc2-001c4244de11.V1xn1eDdW7McbLG4k7OuNixZvO8qrRQfiapEuH20b9y80QIX+0rbJ9cZFY4hUcImgal/b2/7DNSSSWvqhInrK2RQ".split(".")
var api_id, api_secret = apikey.split(".")
var secret = new Buffer(api_secret, 'base64')
var jwt = require('jwt-simple');
var seed = require('crypto').randomBytes(256).toString('base64')
var expires = ((new Date).getTime() / 1000) + 300 

var token = jwt.encode({ 'exp': 'jti': api_id, 'seed': seed}, secret)
{% endhighlight %}

This JWT is then sent as a GET to Reflex Engine's auth endpoint in the `X-ApiKey` header, using the secret part of your apikey to sign the JWT. 

The service will respond with either 401 Unauthorized, a 403 Forbidden (your API Key is not allowed), or 200 OK with a content-type of `application/json` and a payload including two keys:

{% highlight json %}
{"secret": "...base64...",
 "session": "session ID - same as cookie",
 "expires_at": posix time session expires,
 "jti": id to send back as the jti,
 "status": "success"}
{% endhighlight %}

Example:

	>>> GET /reflex/api/v1/auth HTTP/1.1
    >>> X-ApiKey: .....

    <<< 200 Ok
    <<< Set-Cookie: ...
	<<< Content-Type: application/json
    <<<
    <<< {"status": ...}

The session ID is also reflected in a Cookie identified as `sid`  The secret and cookie must be used for any API key authentication.

Sessions are limited to the originating IP address, and may not be used across different originating IP's.

# Authorized API Calls

After successfully getting Session Authorization, you should now have a session cookie and session secret.  At this point you can call any API's with the [Reflex API Token](#reflex-api-token), sent in the header `X-ApiToken`.

# Troubleshooting

If your session key is expired or otherwise not working, you should receive a 401 response.  You will need to re-establish a new session if this ocurrs.
