# Log4Dart Plus User Guide

## About

This document describes the Log4Dart Plus package, its unique features and design rationale. Log4Dart Plus is an open source project based on the work of many authors. It allows the developer to control which log statements are output with arbitrary granularity. It is fully configurable at runtime using external configuration files. Best of all, Log4Dart Plus has a gentle learning curve. 

## Table of Contents

- [Log4Dart Plus User Guide](#log4dart-plus-user-guide)
  - [About](#about)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Log Levels](#log-levels)
  - [Loggers, Appenders and Layouts](#loggers-appenders-and-layouts)
  - [Configuration](#configuration)

## Introduction

Inserting log statements into code is a low-tech method for debugging it. It may also be the only way because debuggers are not always available or applicable. This is usually the case for multithreaded applications and distributed applications at large.

Experience indicates that logging was an important component of the development cycle. It offers several advantages. It provides precise context about a run of the application. Once inserted into the code, the generation of logging output requires no human intervention. Moreover, log output can be saved in persistent medium to be studied at a later time. In addition to its use in the development cycle, a sufficiently rich logging package can also be viewed as an auditing tool.

Logging does have its drawbacks. It can slow down an application. If too verbose, it can cause scrolling blindness. To alleviate these concerns, Log4Dart Plus is designed to be reliable, fast and extensible. Since logging is rarely the main focus of an application, the Log4Dart Plus package strives to be simple to understand and to use.

## Log Levels

Levels are used to define the severity of a logging event. The log levels are as follows:

<pre>
fatal
error
warn
info
debug
trace
</pre>

The levels have an ordering in severity with fatal being the most severe and trace being the least severe. This makes it possible to configure loggers to only log events with a certain severity and above, for example: a logger configured with a severity of info will ignore debug and trace events but log all events with a severity of info and above - all info, warn, error and fatal events.

Two special levels exist namely: <code>all, off</code>. All will be used to log all events and off can be used to ignore all logging events.

The <code>Level</code> class is used to represent logging levels.

## Loggers, Appenders and Layouts

Log4Dart Plus has three main components: loggers, appenders and layouts. These three types of components work together to enable developers to log messages according to message type and level, and to control at runtime how these messages are formatted and where they are reported.

### Loggers

The first and foremost advantage of any logging API over println resides in its ability to disable certain log statements while allowing others to print unhindered. This capability assumes that the logging space, that is, the space of all possible logging statements, is categorized according to some developer-chosen criteria.

Loggers are named entities. Logger names are case-sensitive and they follow the hierarchical naming rule:

<code>A logger is said to be an ancestor of another logger if its name followed by a dot is a prefix of the descendant logger name. A logger is said to be a parent of a child logger if there are no ancestors between itself and the descendant logger.</code>

For example, the logger named <code>com.foo</code> is a parent of the logger named <code>com.foo.Bar</code> and <code>com.foo</code> is a child of the logger named <code>com</code>.

#### Root Logger

The root logger resides at the top of the logger hierarchy. It is exceptional in two ways:
- it always exists,
- it cannot be retrieved by name.

### LogManager

The <code>LogManager</code> class is reposinible for creating and maintaining references to loggers. It provides some static methods to aid in this.

To retrieve a logger you can use the <code>getLogger</code> method. To access the Root Logger you can use <code>getRootLogger()</code>, ordinarily you would not need to use the Root Logger.

<pre>
Logger logger = LogManager.getLogger('myLogger');
</pre>

### Appenders

The ability to selectively enable or disable logging requests based on their logger is only part of the picture. Log4Dart Plus allows logging requests to print to multiple destinations. In Log4Dart Plus speak, an output destination is called an appender. Currently, appenders exist for the console and files, it is possible to build custom appenders to log to virtually any destination such as a database or even a remote API.

More than one appender can be attached to a logger.

The <code>addAppender</code> method adds an appender to a given logger. Each enabled logging request for a given logger will be forwarded to all the appenders in that logger as well as the appenders higher in the hierarchy. In other words, appenders are inherited additively from the logger hierarchy. For example, if a console appender is added to the root logger, then all enabled logging requests will at least print on the console. If in addition a file appender is added to a logger, say C, then enabled logging requests for C and C's children will print to a file and on the console

### Layouts

## Configuration