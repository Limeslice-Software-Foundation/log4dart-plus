# Log4Dart Plus

Log4Dart Plus is a versatile and highly configurable logging framework for Dart / Flutter applications to assist the deployment of logging for various use cases.

Note that this project is still in its early stages and so may not yet provide complete/full functionality. We will be building up functionality over the next few months through numerous small iterative releases.

## Table of Contents
- [Log 4 Dart Plus](#log4dart-plus)
  - [Table of Contents](#table-of-contents)
  - [About The Project](#about-the-project)
    - [Features](#features)
  - [Getting Started](#getting-started)
    - [Installation](#installation)
    - [Import Package](#import-package)
  - [Usage](#usage)
  - [Roadmap](#roadmap)
  - [Contributing](#contributing)
  - [License](#license)
  - [Contact](#contact)
  - [Acknowledgments](#acknowledgments)
  - [Limitation of Liability](#limitation-of-liability)


## About The Project

Log4Dart Plus is an open source project based on the work of many authors. It allows the developer to control which log statements are output with arbitrary granularity. It is fully configurable at runtime using external configuration files. Best of all, Log4Dart Plus has a gentle learning curve.

### Features
- Hierarchical Logger allows for advanced configuration of logging at various levels.
- Various and multiple appenders can be configured for advanced logging capability.
- Various and multiple layouts that can be used to output log messages in numerous formats.


## Getting Started

### Installation
Add the package to your dependencies.

```
pub add log4dart_plus
```

### Import Package

Import the library in your code.

```Dart
import 'package:log4dart_plus/log4dart_plus.dart';
```

### Basic Usage

1. Perform basic configuration
```Dart
LogConfigurator.doBasicConfiguration();
```

2. Get a <code>Logger</code> using the <code>LogManager</code>
```Dart
Logger logger = LogManager.getLogger('example');
```

3. Log a message
```Dart
logger.debug('This is a debug message');
```

## Usage

Log4Dart Plus has three main components: loggers, appenders and layouts. These three types of components work together to enable developers to log messages according to message type and level, and to control at runtime how these messages are formatted and where they are reported.

### Loggers

Loggers are named entities and are used to output logging statements. All loggers exist in a hierarchy and at the top of the hierarchy is the root logger that follows two rules: 

1. It always exists
2. It cannot be rerieved by name

The <code>LogManager</code> class is responsible for creating and maintaining references to loggers. It provides some static methods to aid in this. To retrieve a logger you can use the <code>getLogger</code> method. As an example:

```Dart
Logger logger = LogManager.getLogger('myLogger');
```

### Appenders

Log4Dart Plus allows logging statements to a wide variety of output destination types. In Log4Dart Plus speak, an output destination is called an appender. Currently, appenders exist for the console and files, it is possible to build custom appenders to log to virtually any destination such as a database or even a remote API.

It is also possible to log statements to multiple output destinations simultaneously.

### Layouts

Layouts perform formatting of log messages and allows custom formatting of messages.

### Levels

Levels are used to define the severity of a logging event. The log levels are as follows:
```
fatal
error
warn
info
debug
trace
```

The levels have an ordering in severity with fatal being the most severe and trace being the least severe. The Level class is used to represent logging levels.

See the [User Guide](doc/user-guide.md) for more detailed information.

## Roadmap

See the [open issues](https://github.com/Limeslice-Software-Foundation/log4dart-plus/issues) for a full list of proposed features (and known issues).

## Contributing

Contributions are what make the open source community such an amazing place to learn, inspire, and create. Any contributions you make are **greatly appreciated**.

If you have a suggestion that would make this better, please fork the repo and create a pull request. You can also simply open an issue with the tag "enhancement".
Don't forget to give the project a star! Thanks again!

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

## License

Distributed under the MIT License. See `LICENSE` for more information.

## Contact

Limeslice Software Foundation [https://limeslice.org](https://limeslice.org)

## Acknowledgments

We would like to thank the authors of the Apache Log4J package which has formed the basis of this package.

## Limitation of Liability

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.