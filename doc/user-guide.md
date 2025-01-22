# Log4Dart Plus User Guide

## About

This document describes the Log4Dart Plus package, its unique features and design rationale. Log4Dart Plus is an open source project based on the work of many authors. It allows the developer to control which log statements are output with arbitrary granularity. It is fully configurable at runtime using external configuration files. Best of all, Log4Dart Plus has a gentle learning curve. 

## Table of Contents

- [Log4Dart Plus User Guide](#log4dart-plus-user-guide)
  - [About](#about)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Log Levels](#log-levels)
  - [Logging Event](#logging-event)
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

## Logging Event

A <code>LoggingEvent</code> instance contains data specific to a logging statement. The data contained is as follows:
- Severity of the event.
- The message (statement) of the logging event.
- The instant the event is triggered as a <code>DateTime</code> instance.
- The name of the logger that triggered the event.
- Any exception and stack trace information in the event of an error / exception.

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

#### LogManager

The <code>LogManager</code> class is responsible for creating and maintaining references to loggers. It provides some static methods to aid in this.

To retrieve a logger you can use the <code>getLogger</code> method. To access the Root Logger you can use <code>getRootLogger()</code>, ordinarily you would not need to use the Root Logger.

<pre>
Logger logger = LogManager.getLogger('myLogger');
</pre>

### Appenders

The ability to selectively enable or disable logging requests based on their logger is only part of the picture. Log4Dart Plus allows logging requests to print to multiple destinations. In Log4Dart Plus speak, an output destination is called an appender. Currently, appenders exist for the console and files, it is possible to build custom appenders to log to virtually any destination such as a database or even a remote API.

More than one appender can be attached to a logger.

The <code>addAppender</code> method adds an appender to a given logger. Each enabled logging request for a given logger will be forwarded to all the appenders in that logger as well as the appenders higher in the hierarchy. In other words, appenders are inherited additively from the logger hierarchy. For example, if a console appender is added to the root logger, then all enabled logging requests will at least print on the console. If in addition a file appender is added to a logger, say C, then enabled logging requests for C and C's children will print to a file and on the console

#### ConsoleAppender

The <code>ConsoleAppender</code> appends log events to the console using Dart's <code>print</code> method.

#### FileAppender

The <code>FileAppender</code> appends log events to a file. The file name is passed as a <code>String</code> to the constructor. You can control whether the file is overwritten or appended to using the <code>append</code> parameter, the default is false - overwriting any existing data in the file.

#### RollingFileAppender

The <code>RollingFileAppender</code> appends log events to a file and backs up the log files when they reach a certain size. You can specify the file size and the number of backup files using the available <code>maxFileSize</code> and <code>maxBackupIndex</code> properties. File size is specified in bytes.

### Layouts

More often than not, users wish to customize not only the output destination but also the output format of a log statement. This is accomplished by associating a layout with an appender. The layout is responsible for formatting the logging message according to the user's wishes, whereas an appender takes care of sending the formatted output to its destination.

#### SimpleLayout

A very simple implementation of Layout, formats the logging event printing the Logger name, the Level and the message. The format is as follows:
```Dart
${event.loggerName}: ${event.level.toString()} - ${event.message}
```

#### DateLayout
Provides a layout that prints the logging event instant (DateTime) using a DateFormat, the DateFormat is passed as a parameter to the constructor. The format is as follows:
```Dart
${dateFormat!.format(event.instant)} ${event.loggerName}: ${event.level.toString()} - ${event.message}
```

#### PatternLayout
A very flexible layout configurable with a pattern string.

The goal of this class is to format a LoggingEvent and return the results as a String. The result depends on the conversion pattern supplied. The conversion pattern is similar to the print function in C. A conversion pattern is composed of literal text and format control expressions called conversion specifiers. You are free to insert any literal text within the conversion pattern.

Each conversion specifier starts with a percent sign (%) and is followed by optional format modifiers and a conversion character. The conversion character specifies the type of data, e.g. logger, severity, date or message. The format modifiers control such things as field width, padding, left and right justification. 

Format characters are as follows:
- d : Used to output the instant (DateTine) of the logging event. The date conversion specifier may be followed by an optional date format specifier enclosed between braces. The DateFormat class from the intl package is used - see this class for more detail.
- l : Used to output the name of the logger that triggered this logging event.
- m Used to output the log message of the event.
- n : Outputs the platform dependent line separator character or characters.
- s : Used to output the severity level of the event.

Consider the following conversion pattern: <code>%-5s %l: %m%n</code>, assume the root logger uses a <code>PatternAppender</code> with this given pattern. The statement:
```Dart
LogManager.getRootLogger().debug('This is a debug message!');
```

will result in the following output:
```
DEBUG ROOT: This is a debug message!
```

See the documentation for [Pattern Layout](https://pub.dev/documentation/log4dart_plus/latest/log4dart_plus/PatternLayout-class.html) for more detailed information.

## Configuration

Log4Dart Plus makes use of [Commons Config](https://pub.dev/packages/commons_config) to perform configuration.

### Properties File Configuration

#### Properties file format

A properties file consists of a set of key value pairs separated by an equals sign, typically each property appears on a separate line, for example: 
```
version=1.0
name=TestApp
date=2016-11-12
```