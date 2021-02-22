---
title: Creating a static site generator in Python
description: An exercise in learning how to write Python on the road to becoming a Python engineer
public: true
date: 2021-02-15
---

Usually when I start learning a new language I write some sort of a file parser. Not that I really have much utility for one, but because that seems to me to be a quick thing to build to get a general sense of how a language works. Now, [as you may know](https://soynomm.com/blog/i-dont-want-to-do-frontend-anymore/) I've reached a point in my career where I'm doing a bit of a change and so I didn't think something as simple would really work anymore - I'd need to build something a bit more in depth.

First I needed to figure out what it is exactly that I want to do going forward. I knew I wanted to do back-end, but what language? Well, my wife is currently learning Java and I've heard there's lots of jobs in it so I checked Glassdoor for Java positions, lo' and behold, 267 job postings. There's just one problem with Java and it's a big one; I don't like it much. Then, clueless as to how to continue, I went over to the [Stack Overflow 2020 survey results](https://insights.stackoverflow.com/survey/2020) and found that [the most wanted language is Python](https://insights.stackoverflow.com/survey/2020#technology-most-loved-dreaded-and-wanted-languages-wanted). Glassdoor says 300 job postings for Python! That's good news.

Engineers all over the world like Python, but would I? I've certainly heard of it before, but believe it or not I've never written a single line of code in it. I don't think I've ever as much as went on Python's website before. So then first thing I did was to think of what I could create to test Python out, and I remembered that my own blog was a dynamically generated site written in PHP, which while fast still required actual processing power to render, so I decided to turn the dynamic part into static and entirely cut out the middle man. 

I decided to write a static site generator. Yeah, I know, there's millions of them out there - but I have never created one, so it seemed like a pretty good challenge to me. Especially to write in a language I know nothing about.

## It all starts with a .py file

After a quick Google I learned that writing a Python application is as simple as creating a .py file and then executing it with `python -m filename.py`. That sounds simple enough, so I created this:

```python
print('Hello, world')
```

And ran it. To my surprise, it just worked. I was expecting some weird tooling error or what-not, by PyCharm had created a virtualenv for my code and packaged the latest Python with it - as well as whatever else it needed to just run the code. We're in business.

So let's lay out a plan for the static site generator, like what exactly should it do? I figure it should scan through provided Markdown files, extract information from them and then generate good ol' HTML from a provided template file. Sounds simple enough right?

## Defining the content file' structure

I really like what Jekyll does with the yaml-on-top structure for its content files, so I figure I steal the format. Content files would look like this:

```
---
title: Hello, world
date: 2021-02-15
---

**Markdown** content follows here.
```

Meta-data like the title, date of the post and so on would sit on top of the file and the Markdown content below it. Easy-enough to parse as well.

## Finding all of the markdown files

Much like in my dynamic site generator, the file path should correspond to the URL of the final site (because then we don't have to deal with routing), so we should start by finding all of the Markdown files and more importantly, their paths. To do that, I wrote this bit of recursive code:

```python
def get_paths(from_path):
    paths = []
    items = os.listdir(from_path)

    for item in items:
        if item.endswith(".md"):
            complete_path = (from_path + "/" + item)
            path = complete_path.replace(resources_dir + '/content', '')
            paths.append(path)
        else:
            paths.extend(get_paths(from_path + '/' + item))

    return paths
```

What it does is quite simple, it checks all of the files in a given `from_path`, iterates over each to find out if we're dealing with a `.md` file, and if yes, add the path to a list. If not, it's probably a directory and we should start the whole process over again on that new path. So it repeats until we have everything, then returns paths. I should probably make sure that the `else` block actually runs on a directory and not just for anything that _isn't_ a Markdown file, but for now it'll suffice.

## Getting the content from the files

Now that we have all the paths to the files we need and we know what the file structure is supposed to look like, we can move to the hardest bit of this all, which is parsing the file. 

Let's begin with writing a function that takes the YAML-esque structure seen on top of the content file and turns it into a dictionary, like this:

```python
def get_content_meta(content):
    meta_block = re.search('(?s)^---(.*?)---*', content)

    if meta_block:
        match = meta_block.group(0)
        meta_lines = match.splitlines()
        meta_lines = remove_spaces_from_around_items_in_list(meta_lines)
        meta_lines = remove_all_occurrences_from_list(meta_lines, '---')
        meta = {}

        for meta_line in meta_lines:
            if ':' in meta_line:
                key = meta_line.split(':')[0].strip().replace(' ', '_')
                key = re.sub('[^a-zA-Z_]', '', key)
                value = meta_line.split(':')[1].strip()
                meta[key] = value

        return meta
    else:
        return {}
```

It takes the whole content of the file as an input, finds the part that starts with three hyphens and ends with three hyphens (but only the first part like this, because you might have more!). It then continues to parse it into a dictionary, with help of some additional functions like `remove_spaces_from_around_items_in_list` and `remove_all_occurences_from_list`, all of which you can check out [in the final product](https://github.com/soynomm/bloggo/blob/master/bloggo/core.py). In the end it returns a parsed dictionary, or an empty dictionary if our expected structure was not found.

Moving on, we now need to get the Markdown bit of the file, which is a lot easier to get:

```python
def get_content_entry(content):
    entry = re.sub('(?s)^---(.*?)---*', '', content)
    return entry.strip()
```

It uses the exact same regex pattern we used to get the YAML-esque data structure, except we now use it in the opposite way - by deleting that part from the content, because the resulting bit is surely our desired Markdown. 

And now let's stitch this all together into this function:

```python
def get_contents(paths):
    contents = []

    for path in paths:
        with open(resources_dir + "/content" + path, 'r') as reader:
            content = reader.read()
            meta = get_content_meta(content)
            entry = get_content_entry(content)
            contents.append({
                'path': path.replace('.md', ''),
                **meta,
                'entry': markdown.markdown(entry, extensions=['extra'])
            })

    return contents
```

Which takes an input of `paths` that we got with the `get_paths` function, iterates over each path, get's the file contents. It then continues to get the meta-data from it with our `get_content_meta` and `get_content_entry` functions. Once it has that, it puts it all together into a dictionary containing all the meta items, the `path` and the Markdown parsed `entry`. Basically everything we'd need to actually generate our HTML.

## Generating HTML

We are pretty much set with everything we need to create a static site generator now, so let's create a function that creates the actual file:

```python
def generate_file(content, config, template, helpers):
    print('Generating ' + content['path'])
    compiler = pybars.Compiler()
    compiled_template = compiler.compile(template)
    output = compiled_template({**config, **content}, helpers=helpers)
    file_path = out_dir + content['path'] + '/index.html'

    if not os.path.exists(os.path.dirname(file_path)):
        try:
            os.makedirs(os.path.dirname(file_path))
        except OSError as exc:
            if exc.errno != errno.EEXIST:
                raise

    file = open(file_path, 'w')
    file.write(output)
    file.close()
```

There's a few things to note here. One is the the first argument, `content`, which is the dictionary result of a singular item from the `get_contents` function containing various things in it like post title, date, etc. The next argument is `config`, this is also a dictionary containing extra configuration information for the Handlebars template (we'll see more on this in a bit). Then, the third argument is `template`, which is the actual Handlebars file contents we use to put together the final HTML and last we have `helpers`, which is a dictionary of all the Handlebars helpers that we can pass along to it.

It puts this all together, tries to create all the directory paths to the desired end destination and then creates a `index.html` file in it with our generated HTML.

And the bit that actually calls `generate_file` is this:

```python
def generate_files(contents):
    with open(resources_dir + '/template.hbs', 'r') as template_file, \
            open(resources_dir + '/config.json', 'r') as config_file:
        template = template_file.read()
        config = config_file.read()
        blog_paths = get_paths(resources_dir + '/content/blog')
        blog_contents = get_contents(blog_paths)
        helpers = {'format_date': hbs.format_date}
        site_config = json.loads(config)
        post_config = {'is_home': False, 'is_post': True}
        home_config = {
            'is_home': True,
            'is_post': False,
            'posts': blog_contents
        }

        # Generate all content
        for content in contents:
            generate_file(content,
                          {**post_config, **site_config},
                          template,
                          helpers)

        # Generate home page
        generate_file({'path': '/', 'entry': ''},
                      {**home_config, **site_config},
                      template,
                      helpers)
```

Now it should make more sense to you what `generate_file` does as you can see how the `config`, `template` and `helpers` arguments get constructed. It opens two files, both of which we need - the template Handlebars file and the global config.json that you as a user can edit to create new global variables for use within the Handlebars template.

## To conclude

This all makes up a static site generator I have called [Bloggo](https://github.com/soynomm/bloggo), and it runs this very site. There's a bit more to it than this blog post details and if you're curious then [you can go browse all of it on Github](https://github.com/soynomm/bloggo). 

Overall I'm quite happy with the result. I managed to make something I had never made before and also learn a new language. I do realise that this use-case obviously only gives me minimal exposure to the vast ecosystem of Python, but I did learn quite a few things - like how to create a Pypi package, basic syntax and so on. And damn, the language is a pure joy to write. I like it a lot. 
