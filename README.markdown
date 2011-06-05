haml and sass (for python)
=================

***Note: sass is currently not implemented, but it's coming***

There are a few other implementations, but didn't seem to support as many
features of haml as well as integrating well with typical python template
languages.  This was written with Django in mind, but made room for other
python web frameworks to integrate.  Eventually, modules similar to the
`haml/dj.py` for Django will be included with this package for each framework
because easy integration is important for adoption.

Probably the main difference between this library and the actual haml ruby
implementation is that this implementation strives to "compile" into a
different template language and let the underlying template engine (like
Jinja2 and Django's default) do what they do best.

Django Installation/Setup
=========================

In `settings.py`, modify `TEMPLATE_LOADERS` like:

    TEMPLATE_LOADERS = (
        'haml.dj.FSLoader',
        'haml.dj.AppLoader',
    )

These replace your usual Django loaders:

    django.template.loaders.filesystem.Loader
    django.template.loaders.app_directories.Loader

Now simply name your templates with a `.haml` extension and this haml compiler
will do the rest.  Any templates with other extensions will not be compiled
with the haml compiler.

Quick Overview
=========================

Simple document
---------------

    %element
        %subelement
            some text

Compiles to:

    <element>
        <subelement>
            some text
        </subelement>
    </element>

Embedded HTML
-------------

    %p
        <div id="blah">embedded html</div>

Compiles to:

    <p>
        <div id="blah">embedded html</div>

    </p>

Attributes
----------

    %link{ref="stylesheet", type="text/css", href="media/css/style.css"}

Compiles to:

    <link href="media/css/style.css" ref="stylesheet" type="text/css" />

Or with a template variable:

    %link{ref="stylesheet", type="text/css", href=STATIC_URL + "css/style.css"}

Compiles to:

    <link href="{{ STATIC_URL }}css/style.css" ref="stylesheet" type="text/css" />

DOCTYPE
-------

    !html

Compiles to:

    <!DOCTYPE html>

***Note: Ruby implementation uses "!!!..." where "..." is a shortcut. This
implementation does not provide these shortcuts, but allows anything after the
exclamation to be passed through directly***

Classes and IDs
---------------

    %div.myclass
        %div#myid
            %div.class1.class2
                text

Compiles to:

    <div class="myclass">
        <div id="myid">
            <div class="class1 class2">
                text
            </div>
        </div>
    </div>

As a shortcut, `div` is assumed.  The following also compiles to the above:

    .myclass
        #myid
            .class1.class2
                text

Self-Closing Tags
-----------------

    %mytag/

Compiles to:

    <mytag />

Many tags are automatically closed
(`meta`, `img`, `link`, `br`, `hr`, `input`, `area`, `param`, `col`, `base`):

    %br

Compiles to:

    <br />

Whitespace Removal
------------------

Consume space inside tag:

    %blockquote<
        %div
            foo

Compiles to:

    <blockquote><div>
            foo
    </div></blockquote>

Consume space outside tag:

    %img
    %img>
    %img

Compiles to:

    <img /><img /><img />


Put it all together:

    %img
    %pre><
        foo
        bar
    %img

Compiles to:

    <img /><pre>foo
        bar</pre><img />

Comments
--------

    / html comment

Compiles to:

    <!-- html comment -->

And a block comment:

    /
        an
        html
        block
        comment

Compiles to:

    <!-- 
        an
        html
        block
        comment
     -->

Conditional Comments
--------------------

    /[if IE]
        %link{ref="stylesheet", type="text/css", href="media/css/ie.css"}

Compiles to:

    <!--[if IE]>
        <link href="media/css/ie.css" ref="stylesheet" type="text/css" />
    <![endif]-->


haml comments
-------------

    -# haml comment

The compiler ignores these.

Filters
-------

Filters preserve everything indented below them and wrap their contents in some
kind of tag (sometimes).

Example filter:

    :javascript
        $(function() {
            alert("document loaded");
        });

Compiles to:

    <script type="text/javascript">
        $(function() {
            alert("document loaded");
        });
    </script>

Supported Filters:

    :css
        ...

Compiles to:

    <style type="text/css">
        ...
    </style>

The `:plain` filter simply ignores all formatting that would normally be
interpreted by the haml compiler.

    :plain
        ...

Compiles to:

        ...

    :javascript
        ...

Compiles to:

    <script type="text/javascript">
        ...
    </script>

Django Template Integration
---------------------------

Template Variables:

    %p= variable

Compiles to:

    <p>{{ variable }}</p>

    %p
        = one
        = two
        = three

Compiles to:

    <p>
        {{ one }}
        {{ two }}
        {{ three }}
    </p>


Template Tags:

    - if variable
        %p some text

Compiles to:

    {% if variable %}
        <p>some text</p>
    {% endif %}

    - extends "base.html"

Compiles to:

    {% extends "base.html" %}

There is a list of common tags that require an **end** tag, however, if this
module doesn't currently auto-end a tag, file an issue for common tags and/or
work around it like this:

    - mytag variable
        some text
    - endmytag

Compiles to:

    {% mytag variable %}
        some text
    {% endmytag %}

Example Django Project
===============

See the `example/` subdirectory for an example project that uses this.
