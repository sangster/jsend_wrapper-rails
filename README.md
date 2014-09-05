# Rails JSend Wrapper

[![Build Status](https://travis-ci.org/sangster/jsend_wrapper-rails.svg?branch=master)](https://travis-ci.org/sangster/jsend_wrapper-rails)

## Usage

Add the following lines to your Gemfile:

```ruby
gem 'jsend_wrapper-rails'
gem 'jbuilder' # optional
```

### render jsend: ...

```ruby
# Success
render jsend: @object
render jsend: { success: @object }

# Fail
render jsend: { fail: 'too bad' }

# Error
render jsend: { error: 'too bad' }
render jsend: { error: 'too bad', code: 123 }
render jsend: { error: 'too bad', data: @object }
render jsend: { error: 'too bad', code: 123, data: @object }
```

The elements `code` and `data` are optional for JSend Error containers. If you
leave them out, they will be absent from the rendered JSON. Note the differences
in these two examples:

```ruby
render jsend: {error: 'too bad'}`
```

**Result**:
```json
{
  "status": "error",
  "message": "too bad"
}
```

```ruby
render jsend: {error: 'too bad', data: nil}`
```

**Result**:
```json
{
  "status": "error",
  "message": "too bad",
  "data": null
}
```


### Templates (optional)

If [JBuilder](https://rubygems.org/gems/jbuilder) is available, you can create
view files with a `.jsend` (example: `app/views/posts/show.json.jsend`)
extension. These views are rendered by `Jbuilder`, exactly as if they were
named with a `.jbuilder` extension instead. These views will be wrapped in a
JSend Success container.

**Example**: `app/views/posts/show.json.jsend`
```ruby
json.title 'The Pragmatic Programmer'
json.year  1999
```

**Result**:
```json
{
  "status": "success",
  "data": {
    "title": "The Pragmatic Programmer",
    "year": 1999
  }
}
```

### Tips

#### Handling Errors

You can use `rescue_from` to automatically handle errors:

```ruby
rescue_from ActiveRecord::RecordNotFound do
  render status: :not_found, jsend: {
    error: 'record not found', code: 404, data: { id: params[:id] } }
end
```

**Example**: `GET /posts/1234.json`:
```json
{
  "status": "error",
  "message": "record not found",
  "code": 404,
  "data": {
    "id": "1234"
  }
}
```

#### Use Renderers directly

If you have some other purpose in mind, you can access the renderers directly:

```ruby
require 'jsend_wrapper/renderers/success_renderer'
require 'jsend_wrapper/renderers/fail_renderer'
require 'jsend_wrapper/renderers/error_renderer'

# or, for all three:
require 'jsend_wrapper/renderers'
```

##### Usages

To use these renderers, construct them with the same arguments as you pass to
the `render` statements listed above.

```ruby
renderer = JsendWrapper::SuccessRenderer.new @data
renderer = JsendWrapper::FailRenderer.new 'a message'
renderer = JsendWrapper::ErrorRenderer.new 'a message', code: 123, data: @data

json = renderer.to_s
hash = renderer.to_h
```

## JSend Specification

*This section is copied from [omniti.com](http://labs.omniti.com/labs/jsend)
under via a modified BSD License (see below).*

 * **What?** - Put simply, JSend is a specification that lays down some rules
   for how [JSON](http://json.org) responses from web servers should be
   formatted. JSend focuses on application-level (as opposed to protocol- or
   transport-level) messaging which makes it ideal for use in
   [REST](http://en.wikipedia.org/wiki/Representational_State_Transfer)-style
   applications and APIs.
 * **Why?** - There are lots of web services out there providing JSON data,
   and each has its own way of formatting responses.  Also, developers writing
   for JavaScript front-ends continually re-invent the wheel on communicating
   data from their servers.  While there are many common patterns for
   structuring this data, there is no consistency in things like naming or types
   of responses.  Also, this helps promote happiness and unity between backend
   developers and frontend designers, as everyone can come to expect a common
   approach to interacting with one another.
 * **Hold on now, aren't there already specs for this kind of thing?** -
   Well... no.  While there are a few handy specifications for dealing with JSON
   data, most notably [Douglas Crockford](http://www.crockford.com/)'s
   [JSONRequest](http://www.json.org/JSONRequest.html) proposal, there's nothing
   to address the problems of general application-level messaging.  More on this
   later.
 * **(Why) Should I care?** - If you're a library or framework developer, this
   gives you a consistent format which your users are more likely to already be
   familiar with, which means they'll already know how to consume and interact
   with your code.  If you're a web app developer, you won't have to think about
   how to structure the JSON data in your application, and you'll have existing
   reference implementations to get you up and running quickly.
 * **Discuss** - [Mailing list](http://lists.omniti.com/mailman/listinfo/jsend-users)

### So how's it work?

A basic JSend-compliant response is as simple as this:
```json
{
  "status": "success",
  "data": {
    "post": {
      "id": 1,
      "title": "A blog post",
      "body": "Some useful content"
     }
  }
}
```

When setting up a JSON API, you'll have all kinds of different types of calls
and responses.  JSend separates responses into some basic types, and defines
required and optional keys for each type:

<table>
  <thead>
    <tr>
      <th>Type</th>
      <th>Description</th>
      <th>Required Keys</th>
      <th>Optional Keys</th>
    </tr>
  </thead>
  <tbody>
    <tr>
      <td>success</td>
      <td>All went well, and (usually) some data was returned.</td>
      <td>status, data</td>
      <td></td>
    </tr>
    <tr>
      <td>fail</td>
      <td>
        There was a problem with the data submitted, or some pre-condition of
        the API call wasn't satisfied.
      </td>
      <td>status, message</td>
      <td></td>
    </tr>
    <tr>
      <td>error</td>
      <td>
        An error occurred in processing the request, i.e. an exception was
        thrown.
      </td>
      <td>status, message</td>
      <td>code, data</td>
    </tr>
  </tbody>
</table>

### Example response types

**Success**: When an API call is successful, the JSend object is used as a
simple envelope for the results, using the {{{data}}} key, as in the following:

**`GET /posts.json`:**
```json
{
  "status": "success",
  "data": [
    {
      "id": 1,
      "title": "A blog post",
      "body": "Some useful content"
    },
    {
      "id": 2,
      "title": "Another blog post",
      "body": "More content"
    },
  ]
}
```

**`GET /posts/2.json`:**
```json
{
  "status": "success",
  "data": {
    "id": 2,
    "title": "Another blog post",
    "body": "More content"
  }
}
```

**`DELETE /posts/2.json`:**
```json
{
  "status": "success",
  "data": null
}
```

Required keys:
 * status: Should always be set to "success".
 * data: Acts as the wrapper for any data returned by the API call.  If the call
   returns no data (as in the last example), data should be set to null.

**Fail**: When an API call is rejected due to invalid data or call conditions,
the JSend object's data key contains an object explaining what went wrong,
typically a hash of validation errors.  For example:

**`POST /posts.json`** (with data `body: "Trying to creating a blog post"`):
```json
{
  "status": "fail",
  "data": {
    "title": "A title is required"
  }
}
```

Required keys:
 * status: Should always be set to "fail".
 * data: Again, provides the wrapper for the details of why the request failed.
   If the reasons for failure correspond to `POST` values, the response
   object's keys *should* correspond to those `POST` values.

**Error**: When an API call fails due to an error on the server.  For example:

**`GET /posts.json`**:
```json
{
    "status": "error",
    "message": "A title is required"
}
```

Required keys:
 * status: Should always be set to "error".
 * message: A meaningful, end-user-readable (or at the least log-worthy)
   message, explaining what went wrong.

Optional keys:
 * code: A numeric code corresponding to the error, if applicable
 * data: A generic container for any other information about the error, i.e. the
   conditions that caused the error, stack traces, etc.

### Whither HTTP?

But wait, you ask, doesn't HTTP already provide a way to communicate response
statuses?  Why yes, astute reader, it does.  So how does the notion of
indicating response status in the message body fit within the context of HTTP?
Two things:
 * The official HTTP spec has 41 status codes, and there are many
   interpretations on how to use each one.  JSend, on the other hand, defines a
   more constrained set of status codes, specifically related to handling JSON
   traffic in the context of a dynamic web UI.
 * The spec is meant to be as small, constrained, and generally-applicable as
   possible.  As such, it has to be somewhat self-contained.  A common pattern
   for implementing JSON services is to load a JavaScript file which passes a
   JSON block into a user-specified callback.  JSON-over-XHR handling in many
   JavaScript frameworks follows similar patterns.  As such, the end-user
   (developer) never has a chance to access the HTTP response itself.

So where does that leave us?  Accounting for deficiencies in the status quo does
not negate the usefulness of HTTP compliance.  Therefore it is advised that
server-side developers use both: provide a JSend response body, and whatever
HTTP header(s) are most appropriate to the corresponding body.

### License

The JSend specification is covered under a
[License modified BSD License](http://labs.omniti.com/labs/jsend/wiki/License)
