# laotzi-demo

*An LFE Demo of the Ten Thousand Things*

<img src="resources/images/DaodeTianzun.jpg" />


## Introduction

Steven Proctor emailed Robert and I about an interesting LFE demo. This is the
demo that was born of that discussion.


## Setup

Just clone it:

```bash
$ git clone git@github.com:oubiwann/laotzi-demo.git
```

And then do :

```bash
    $ make repl
```

This will download and compile all the dependencies, and then start the LFE
REPL (also automatically starting the ``laotzi-demo`` application and the
built-in web server).


## Usage

From the REPL where the ``laotzi-demo`` application has been started,
you can manually add children to the supervisor with the following:

```cl
> (laotzi-demo:add)
#(ok <0.60.0>)
> (laotzi-demo:add)
#(ok <0.62.0>)
> (laotzi-demo:add)
#(ok <0.64.0>)
> (laotzi-demo:add)
#(ok <0.66.0>)
> (laotzi-demo:add)
#(ok <0.68.0>)
> (laotzi-demo:add)
#(ok <0.70.0>)
> (laotzi-demo:add)
#(ok <0.72.0>)
> (laotzi-demo:add)
#(ok <0.74.0>)
> (laotzi-demo:get-children)
(#(undefined <0.64.0> worker (laotzi-demo-server))
 #(undefined <0.66.0> worker (laotzi-demo-server))
 #(undefined <0.68.0> worker (laotzi-demo-server))
 #(undefined <0.70.0> worker (laotzi-demo-server))
 #(undefined <0.72.0> worker (laotzi-demo-server))
 #(undefined <0.74.0> worker (laotzi-demo-server))
 #(undefined <0.60.0> worker (laotzi-demo-server))
 #(undefined <0.62.0> worker (laotzi-demo-server)))
```


## Under the Hood

Here are the interesting things that this demo applications does:

* Creates an OTP application, supervisor, and then thousands of worker
  processes.

* Enables stats-gathering for the OTP supervisor.

* Generates a JSON data file from process stats.

* Uses an early, development version of the lmug web server middleware
  framework (inspired by Clojure's Ring framework, which in turn was
  inspired by Python's WSGI).

* As part of the above point, it uses a built-in web server.

* Generates json with the ljson LFE library for parsing and creating
  JSON data.

* Makes use of the d3.js data visualization library.
