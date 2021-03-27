---
title: Parsing CLI arguments yourself in Java
description: Not everything has to be solved with a dependency - just like parsing CLI arguments can be done with a simple, straight-forward helper class that I can write myself.
public: true
date: 2021-03-23
---

If you're like me and making a Java app that's meant to be used on the command line, there's a fair chance you'll also be using CLI arguments for that app. There's tools out there that help you with this like [picocli](https://picocli.info), but I figured the problem is such an insignificant one for me and my use-case that I won't need a full-featured thing like that for this. After all, I have all of the information that I could need in a provided array of strings already like this inside my Main class:

```java
public class Main {
	public static void main(String[] args) {
		// we have the arguments in args
	}
}
```
 
Following the logic that I have a flag and that flag has an optional value, like `appName --flag {value}`. I'd have the command at index 0, its value (if it has any) on index 1. Following command on index 2 and its value on index 3, and so on. It's pretty straight-forward, and so is my solution to this. Let's get to it.

To start with, I created a class called `ArgParser`, like so:

```java
public class ArgParser {

	private final String[] args;

}
```

As you can see, the class will hold in its state the raw form of args we receive in our `Main.main`. Now we need a constructor to put the args in the state when initializing `ArgParser`, so let's add it like this:

```java
public class ArgParser {

	private final String[] args;

	public ArgParser(String[] args) {
		this.args = args;
	}

}
```

Which we can then initialize like this:

```java
public class Main {
	public static void main(String[] args) {
		ArgParser argParser = new ArgParser(args);
	}
}
```

It doesn't do anything yet, but it will shortly.

Next up I created a simple `has` method that checks if a given argument actually exists in `this.args` or not:

```java
private boolean has(String arg) {
	return Arrays.asList(this.args).contains(arg);
}
```

You see I can call the `has` method like `this.has("argumentName")` and it will return `true` if the argument exists in `this.args`. Naturally it will return false otherwise. Now all there's left to do is to create a getter, but I don't want the getter to only return the arguments value - I also want it to return a default value that I provide if the argument either doesn't exist or doesn't have value. I made it happen like this:

```java
public String get(String arg, String defaultValue) {
	if (this.has(arg)) {
		int index = Arrays.asList(args).indexOf(arg);

		try {
			return this.args[index + 1];
		} catch(java.lang.ArrayIndexOutOfBoundsException e) {
			return defaultValue;
		}
	}

	return defaultValue;
}
```

If the argument exists, it will try to find its value and return it. However if it doesn't have a value, we'll be hitting an `ArrayIndexOutOfBoundsException`, and in that case we return the default value. If the argument does not exist, we also return the default value.

**There's a slight bug in this code though**. It's that if the provided arguments are like `appName --arg1 --arg2`, then by using our getter for `--arg1`, its value would be incorrectly `--arg2` and not the default value. I can fix this by checking that if it does find a value, it wouldn't start with a hyphen, like so:

```java
public String get(String arg, String defaultValue) {
	if (this.has(arg)) {
		int index = Arrays.asList(args).indexOf(arg);

		try {
			String value = this.args[index + 1];

			if (value.charAt(0) != '-') {
				return value;
			}
		} catch(java.lang.ArrayIndexOutOfBoundsException e) {
			return defaultValue;
		}
	}

	return defaultValue;
}
```

So I can utilise this to make actual use of the freshly baked `ArgParser`:


```java
public class Main {
	public static void main(String[] args) {
		ArgParser argParser = new ArgParser(args);
		String argValue = argParser.get("--arg", "defaultValue");
	}
}
```

But what if I also want to have an alternative argument, say `--arg` and `-a` for short, as is popular to do? Overloading comes to rescue here as I can create another `get` method that takes an additional String parameter:

```java
public String get(String arg, String alternativeArg, String defaultValue) {
	if (!this.get(arg, "").equals("")) {
		return this.get(arg, "");
	}

	if (!this.get(alternativeArg, "").equals("")) {
		return this.get(alternativeArg, "");
	}

	return defaultValue;
}
```

So now I can utilise the `get` method like this:

```java
public class Main {
	public static void main(String[] args) {
		ArgParser argParser = new ArgParser(args);
		String argValue = argParser.get("--arg", "-a", "defaultValue");
	}
}
```

And it would return a value for either of those arguments or the default value if none found. 

But wait, there's an important piece missing here! What if I want a boolean result for if an argument exists or not? Say if I want to the argument to _not have_ a value, and instead just want to know if it's present? Overloading comes to rescue once more! I'll create another `get` method that returns a boolean and takes a boolean as its default value:

```java
public boolean get(String arg, String alternativeArg, boolean defaultValue) {
	if (this.has(arg) || this.has(alternativeArg)) {
		return true;
	}

	return defaultValue;
}
```

Now you could simply use:

```java
public class Main {
	public static void main(String[] args) {
		ArgParser argParser = new ArgParser(args);
		boolean argValue = argParser.get("--arg", "-a", false);
	}
}
```

And `argValue` will be `true` if either of the arguments are present and `false` otherwise. Pretty straight-forward, right?
