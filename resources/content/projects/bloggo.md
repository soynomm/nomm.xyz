---
title: Bloggo
description: A blog-oriented static site generator
is_project: true
---

A blog-oriented static site generator that supports static content in the form of Markdown files as well as 
dynamic content in the form of Mustache templates, allowing you to create flexible websites.

- [Installation](#installation)
  - [Linux](#linux)
  - [macOS](#macos)
  - [Windows](#windows)
- [Updating](#updating)
- [Usage](#usage)
  - [Directory structure](#directory-structure)
  - [Content files](#content-files)
    - [Markdown](#markdown)
    - [Mustache](#mustache)
  - [Site layout](#site-layout)
  - [Template data](#template-data)
  - [Site configuration](#site-configuration)
  - [Command-line usage](#command-line-usage)
- [Example sites](#example-sites)

## Installation

<a name="linux"></a>
### Linux

1. Download the `bloggo-linux` executable from the [latest release](https://github.com/soynomm/bloggo/releases)
2. Rename it to something more friendly like `bloggo` with `mv bloggo-linux bloggo`
3. Make it executable via `chmod +x bloggo`
4. Run it with `./bloggo` (or move it to `/usr/local/bin` to access globally as `bloggo`)

<a name="macos"></a>
### macOS

1. Download the `bloggo-mac` executable from the [latest release](https://github.com/soynomm/bloggo/releases)
2. Rename it to something more friendly like `bloggo` with `mv bloggo-mac bloggo`
3. Make it executable via `chmod +x bloggo`
4. Run it with `./bloggo` (or move it to `/usr/local/bin` to access globally as `bloggo`)

<a name="windows"></a>
### Windows

1. Download the `bloggo.exe` executable from the [latest release](https://github.com/soynomm/bloggo/releases)
3. Run it with `.\bloggo.exe` (or add it to PATH to access globally as `bloggo`)

<a name="java"></a>
### Java

To run it on any platform that has Java, you'll need Java 11+, download the `bloggo.jar` file and run it with `java -jar bloggo.jar`.

<a name="updating"></a>
## Updating

To update any previous version you might have, simply overwrite/replace your existing Bloggo executable with a new one.

<a name="usage"></a>
## Usage

Using Bloggo is straight-forward in that you just need to have a resources' directory that contains everything your static
website needs, like a `config.json` file for configuration, a `layout.mustache` file for the website template as well as a `content` 
directory inside the resources' directory for all the content files that make up your website.

<a name="directory-structure"></a>
### Directory structure

By default, Bloggo is looking for a resources' directory called `resources` (you can specify any other directory by calling `bloggo -r {directory}` or `bloggo --resources {directory}`).
The resources' directory structure needs to look like this:

- resources/
  - content/
    - hello-world.md
    - author/
      - john.md
  - config.json
  - layout.mustache
  
<a name="site-layout"></a>
### Site layout

The site layout of your static website lives inside a [Mustache](https://mustache.github.io/mustache.5.html) template file `layout.mustache` in the root of the resources' directory.
That layout file has all the [template data](#template-data) available to it just like all Mustache content files do, and just
like all Mustache content files, it also can have any structure you want it to have. 

You can check out [my own website' layout.mustache](https://github.com/soynomm/nomm.xyz/layout.mustache) for an example use-case.

<a name="content-files"></a>
### Content files

All the content files reside inside the `content` directory. There are two types of content files - Markdown ({filename}.md) and Mustache ({filename}.mustache).
Markdown content files are meant for static content, such as blog posts and pages. Mustache
content files are meant for custom, dynamic pages.

<a name="markdown"></a>
#### Markdown

A Markdown content file looks like this:

```markdown
---
title: Hello, World
date: 2020-12-01
---

Hi there, world.
```

Meta-data of each Markdown content file goes in-between 3 hyphens, and the entry of the content file itself will go below the meta-data.
Markdown content file data is available to you via `{{metakey}}` Mustache templating, for example the above content file would be
available via the following Mustache variables:

- `{{title}}` - renders the meta-data title value
- `{{date}}` - renders the default date in the format of `EEE, dd MMM yyyy HH:mm:ss Z`
- `{{date_unparsed}}` - renders the date as it is in the content file
- `{{pretty_date}}` - renders the date in the format of `MMM dd, yyyy`
- `{{pretty_date_without_year}}` - renders the date in the format of `MMM dd`
- `{{{entry}}}` - renders the entry-block Markdown into HTML. Yes, needs 3 brackets.
- `{{url}}` - renders the fully-qualified URL of the content item (https://example.com/hello-world/)
- `{{path}}` - renders the content item's path (/hello-world/)

The filename determines the eventual path of the content item. For example a file with a name of `hello-world.md` will be 
compiled into `/hello-world/index.html`, and thus be accessible via the URL https://example.com/hello-world/.

<a name="mustache"></a>
#### Mustache

A Mustache content file can have any structure you want. You can check out [my own website content files](https://github.com/soynomm/nomm.xyz) for example use-cases. 

It's important to note that unlike a Markdown content file, a Mustache content file does not use site layout 
and thus enables (and encourages) an entirely new layout for each Mustache content file.

Just like in the case of a Markdown content file, the filename of Mustache template file also determines the eventual path of the content item. 
But unlike a Markdown content file, a Mustache content file will not be compiled into a HTML file. Instead, it will be 
compiled into whatever format you want. For example a file with a name of `feed.xml.mustache` will be compiled into `feed.xml`, 
thus allowing you to determine the file format.

<a name="template-data"></a>
### Template data

In all of your Mustache files (including content files and site layout), the following data is available for use:

#### `is_home`

Returns true if the user visits the home page of the site.

Example usage:

```
{{#is_home}}
<p>Hi! Welcome to my website.</p>
{{/is_home}}
```

**Note:** this will never return true when used in a Mustache content file, because content files will never be 
shown on the home page.

#### `is_post`

Returns true if the user visits any of the content files.

Example usage:

```
{{#is_post}}
  <h2>{{title}}></h2>
  <div class="date">{{pretty_date}}</div>
  <div class="entry">{{{entry}}}</div>
{{/is_post}}
```

#### `posts`

Returns a collection of content items inside the `content/blog` directory that you can use for looping.

Example usage:

```
<ul class="posts">
{{#posts}} 
    <li class="year">{{year}}</li>
    {{#entries}}
      <li>
          <h3><a href="{{url}}" title="{{title}}">{{title}}</a></h3>
          <div class="date">{{pretty_date_without_year}}</div>
      </li>
    {{/entries}}
{{/posts}}
</ul>
```

#### `last_update`

Returns the date of the last created content item inside the `content/blog` directory in `EEE, dd MMM yyyy HH:mm:ss Z` format.

<a name="site-configuration"></a>
### Site configuration

Site configuration lives inside the `config.json` file in the root of the resources' directory. It can contain anything you'd 
like to have there, but these three things are required:

- `site_url` - URL of your website (example: https://example.com)
- `site_title` - title of your website
- `site_description` - description of your website

All the items inside the `config.json` file are also available globally in all of your Mustache template files, 
including `layout.mustache` as well as any content file with the `.mustache` file extension.

<a name="command-line-usage"></a>
### Command-line usage

To see the full CLI usage of Bloggo, run Bloggo with `bloggo -h` or `bloggo --help`. 

<a name="example-sites"></a>
## Example sites

- [Nomm](https://nomm.xyz) ([Github repository](https://github.com/soynomm/nomm.xyz))
