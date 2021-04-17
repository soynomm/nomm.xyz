---
title: Bloggo
description: A blog-oriented static site generator, how it came to be and where it might lead.
date: 2021-04-17
public: true
---

[Two months ago I wrote a blog post](https://nomm.xyz/blog/creating-a-static-site-generator-in-python/) on how to create a static site generator in Python, because at the time I was learning Python and thinking I'll find a back-end Python job. In the end of that blog post I wrote, passingly, that I had called the end result of that [Bloggo](https://nomm.xyz/projects/bloggo/) and that it runs this very site. Well, some time has passed and many changes to it have been made since then, but I'm now ready to make it official with a blog post - I have created a static site generator and I'm pretty damn proud of it.

It is no longer written in Python however, partly because I no longer chase a back-end career in it (I do it with Java now instead so give me all your enterprise gigs please!!) and partly because in comparison to Java, Python is just so damn slow. I no longer crave the new and flashy in this life, I crave fast and practical instead. Hence, Bloggo is written in Java 11 and compiled to native executables with [GraalVM](https://www.graalvm.org/) so that you, the user, do not have to know or care about Java at all.

## It's special

Honestly, it's not that that special. It takes in Markdown files and spits out HTML, just like any other static site generator. I did implement one thing however which is that alongside Markdown files you can also have Handlebars files - as content files - allowing you to create dynamic pages within your static website by using all the data available to the generator, which I think is pretty cool. You can [check out the repository of this very website](https://github.com/soynomm/nomm.xyz) to see an example use-cases such as the [Atom Feed](https://github.com/soynomm/nomm.xyz/blob/master/resources/content/feed.xml.hbs) and [sitemap.xml](https://github.com/soynomm/nomm.xyz/blob/master/resources/content/sitemap.xml.hbs) that are powered by those Handlebars content files.

This in itself opens up a lot of possibilities. For example you could use Handlebars content files to create a JSON of all your blog posts, which you can then query on the front-end with JavaScript to create an actual search-engine for your blog! Pretty cool, right?

## Possibilities are endless

Okay maybe not endless, but I have been pondering about the idea of perhaps creating a service on top of Bloggo for easier static site creation - no need to know anything about a CLI and what-not. As with anything I build, I would make it because I want it for myself. I may be a developer, but the whole flow of creating a file and then pushing it to a repo and making sure that repo is connected to a build system is just so darn slow. I want to open a UI, type some words and press a button.

I would even go so far as to say I would be writing blog posts a lot more actively if I had such interface or service for Bloggo. I'm not sure if it would be a native app or a web service, but anyway, food for thought. 

## I'll maintain it forever

I like the idea of simple-_ish_ software that has a fixed feature set, because it keeps things from changing _too much_. In a world where seemingly every week some new chaotic beast is unleashed on this world, products get shut-down or bought and turned to crapware and you never even know if you'll return home ever again after leaving for work because who-knows-what, it's nice to have some certainty. 

Since Bloggo is a fairly simple piece of software and I intend to use it for all of my personal websites, forever, and its feature-set is if not entirely done then in the 99th percentile for sure, I have no problem maintaining it for as long as I'm in this industry. Which according to my investment strategies will not change for the next ~15 years or so at minimum.

---

This whole past few months have been full of changes and self-doubt for me. I moved from Europe to South America, I quit my front-end development gig and no longer wanted anything to do with front-end development. I started getting into back-end, but boy this also has been quite challenging with me first picking Python as an easy language to start with and then realizing midway that Python gigs are not really what I'd like to do with my days and it being rather slow is not ideal either. For times I even had doubts with Java. "Oh but the enterprise", I thought. "Think of the abstractions!", I figured.

But ultimately Java persavered nevertheless, probably because of its _lack of_ hype, absolutely enormous job prospects and, of course, speed. It's really-really fast guys, and while the whole front-end world of 2021 would tell you nobody cares about speed anymore, it's not true. I care. A lot. And this static site generator has been one hell of a good way to crank out any stress and fear for the future I've had these past couple of months. I don't consider it _done_ just yet, but it's really close. Going forward I'd like to work more on software that actually gets finished, it's really nice.





