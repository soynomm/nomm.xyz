---
title: What's coming in Python 3.10
description: A short overview of some of the more notable changes coming in Python 3.10 that I find useful
public: true
date: 2021-03-05
---

Python is evolving at a comfortable pace, if you ask me. Some folks may be [a bit negative towards Python](https://towardsdatascience.com/why-python-is-not-the-programming-language-of-the-future-30ddc5339b66), but I haven't been in this ecosystem long enough to have grown bitter just yet. And as a non-bitter person, I can look at Python for what it is rather than what I would like it to be. Also, [from what I can gather](https://stackoverflow.blog/2017/09/06/incredible-growth-python/) it seems that Python should be just fine as a bread-maker in the 10 years to come.

As a newly babptised Pythonista I try to keep myself up to date on all-things-Python, to be a better engineer, and I figured I'll review all the updates that are coming in Python 3.10 that I myself would most definitely use.

## Parenthesized context managers

You can have comma-separated, multi-line context managers, like this:

```python
with (
	open('file1.txt', 'r') as file1,
	open('file2.txt', 'r') as file2
):
```

This is very cool because previously if you wanted to have multi-line context managers you had to resort to using a backslash to wrap the lines, like this:


```python
with open('file1.txt', 'r') as file1, \
	open('file2.txt', 'r') as file2:
```

And while it works just fine, it doesn't exactly _look_ nice. I'd say this is a very welcome addition.

## Better error messages in the parser

Whenever you forgot a closing parentheses or brackets, the parser will now points you to the exact place you made an error by highlighting that place in code, allowing you to fix it much quicker. Long gone are the days of spending 2 hours trying to debug a problem that was all solved with a correct comma placement!

## New Type Union Operator

Now personally I don't really care for types in small projects - especially ones that will only ever be used by you, but I do use them in projects that are open source and intended for use by other people as well as it helps make it clear what something does. So any type-related enhancements are greatly appreciated so long as it doesn't turn the entire language into a Frankenstein's monster like TypeScript has turned itself into.

The new type union operator is a gread addition in my opinion, because it improves consistency in expressing types. Previously I had to write code like this to express union types:

```python
from typing import Union

def func_name(): Union[dict, str, None]:
	# can return either dict, str or None
```

Whereas now I can write code like this:

```python
def func_name(): dict | str | None:
	# can return either dict, str or None
```

Keep in mind however that if you are using PyCharm like I am then as of writing this new type union operator is not yet supported.

## Structural Pattern Matching

Personally, I can't believe that it's 2021 and I'm learning that Python _only now_ gets what is basically a switch-case statement. Well, a switch-case statement that has a few more tricks up it sleeve than I've seen in other languages, but a switch-case statement nonetheless. I'll definitely be using this sooner rather than later. You can read more on the specifics of Structural Pattern Matching in Python [here](https://www.python.org/dev/peps/pep-0634/).

