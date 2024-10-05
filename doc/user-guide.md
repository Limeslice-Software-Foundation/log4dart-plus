# Log4Dart Plus User Guide

## About

This document describes the Log4Dart Plus package, its unique features and design rationale. Log4Dart Plus is an open source project based on the work of many authors. It allows the developer to control which log statements are output with arbitrary granularity. It is fully configurable at runtime using external configuration files. Best of all, Log4Dart Plus has a gentle learning curve. 

## Table of Contents

- [Log4Dart Plus User Guide](#log4dart-plus-user-guide)
  - [About](#about)
  - [Table of Contents](#table-of-contents)
  - [Introduction](#introduction)
  - [Loggers, Appenders and Layouts](#loggers-appenders-and-layouts)

## Introduction

Inserting log statements into code is a low-tech method for debugging it. It may also be the only way because debuggers are not always available or applicable. This is usually the case for multithreaded applications and distributed applications at large.

Experience indicates that logging was an important component of the development cycle. It offers several advantages. It provides precise context about a run of the application. Once inserted into the code, the generation of logging output requires no human intervention. Moreover, log output can be saved in persistent medium to be studied at a later time. In addition to its use in the development cycle, a sufficiently rich logging package can also be viewed as an auditing tool.

Logging does have its drawbacks. It can slow down an application. If too verbose, it can cause scrolling blindness. To alleviate these concerns, Log4Dart Plus is designed to be reliable, fast and extensible. Since logging is rarely the main focus of an application, the Log4Dart Plus package strives to be simple to understand and to use.

## Loggers, Appenders and Layouts

Log4Dart Plus has three main components: loggers, appenders and layouts. These three types of components work together to enable developers to log messages according to message type and level, and to control at runtime how these messages are formatted and where they are reported.

## Logger Hierarchy

The first and foremost advantage of any logging API over println resides in its ability to disable certain log statements while allowing others to print unhindered. This capability assumes that the logging space, that is, the space of all possible logging statements, is categorized according to some developer-chosen criteria.

Loggers are named entities. Logger names are case-sensitive and they follow the hierarchical naming rule:

<code>A logger is said to be an ancestor of another logger if its name followed by a dot is a prefix of the descendant logger name. A logger is said to be a parent of a child logger if there are no ancestors between itself and the descendant logger.<code>

For example, the logger named <code>com.foo</code> is a parent of the logger named <code>com.foo.Bar<code> and <code>com.foo</code> is a child of the logger named <code>com</code>.

### Root Logger

The root logger resides at the top of the logger hierarchy. It is exceptional in two ways:
- it always exists,
- it cannot be retrieved by name.