---
layout: page
title: iOS 开发者参考
permalink: /flutter-for-ios/
---

本文档适用于那些希望用他们目前的 iOS 知识来使用 Flutter 构建移动应用的 iOS 开发者们。如果你熟悉 iOS 框架基础的话，那么你可以借助这个文档快速开始 Flutter 开发。

在使用 Flutter 构建应用时，你的 iOS 知识和技能非常有价值，因为 Flutter 依赖于众多的手机操作系统功能和配置。Flutter 是一种构建手机用户界面的新方法，但它有一个插件系统可以与 iOS（和 Android）进行非 UI 任务进行通信。如果你是 iOS 开发专家，那么你不用重新学习所有内容就可以使用 Flutter。

此文档可作为手册来跳转并查找与您的需求最相关的问题。

* TOC Placeholder
{:toc}

# 视图

## iOS 中的 `UIView` 在 Flutter 中对应什么

在iOS中，您在 UI 中创建的大部分内容都是使用视图对象完成的，这些视图对象是 `UIView` 类的实例。这些可以充当其他 `UIView` 类的容器，它们构成了你的布局。

在 Flutter 中，与 `UIView` 相当的就是 `Widget`。Widget 并不会完全映射到 iOS 视图上，但是当你完全了解 Flutter 的工作原理后，可以将他们视为“你声明和构建 UI 的方式”。

当然，这些与 `UIView` 有些差异。开始，widget 具有不同的生命周期：它们是不可变的，只有在它们需要改变时才存在。每当 widget 或它的状态改变，Flutter 框架会创建一个新的 widget 实例的树。相比之下， iOS 视图在改变时不会被重新创建，而它是一个可变实体，只能绘制一次，在使用 `setNeedsDisplay()` 失效之前不会重新绘制。

此外，与 `UIView` 不同， Flutter 的 widget 是轻量的,在某种程度上得益于 widget 的不可变性。因为他们自身并不是视图，也不会直接绘制任何东西，而是 UI 的描述和它的语义，它们在实际视图对象下面“膨胀”。

Flutter 包含了 [Material 组件](https://material.io/develop/flutter/) 库。这些 widget 实现了 [Material Design 设计规范](https://material.io/design/) 。Material Design 是针对所有平台（包括iOS）优化的灵活设计系统。

尽管 Flutter 的灵活性和表现力足以实现任何设计语言，在 iOS 中，您依然可以使用 [Cupertino widgets](https://flutter.io/widgets/cupertino/) 来生成看起来像 [Apple iOS 设计语言](https://developer.apple.com/design/resources/) 的界面。

## 如何更新 `Widget` ？

To update your views on iOS, you directly mutate them. In Flutter, widgets are
immutable and not updated directly. Instead, you have to manipulate the
widget’s state.

要在 iOS 中更新视图，你可以直接改变它们。在 Flutter 中，widget 是不可变的，不能直接更新。相反，你必须操作 widget 的状态。

This is where the concept of Stateful vs Stateless widgets
comes in. A `StatelessWidget` is just what it sounds like&mdash;a widget with no
state attached.

`StatelessWidgets` are useful when the part of the user interface you are
describing does not depend on anything other than the initial configuration
information in the widget.

For example, in iOS, this is similar to placing a `UIImageView` with
your logo as the `image`. If the logo is not changing during runtime,
use a `StatelessWidget` in Flutter.

If you want to dynamically change the UI based on data received after making an
HTTP call, use a `StatefulWidget`. After the HTTP call has
completed, tell the Flutter framework that the widget’s `State` is
updated, so it can update the UI.

The important difference between stateless and
stateful widgets is that `StatefulWidget`s have a `State` object that stores
state data and carries it over across tree rebuilds, so it's not lost.

If you are in doubt, remember this rule: if a widget changes outside of
the `build` method (because of runtime user interactions, for example), it’s stateful.
If the widget never changes, once built, it's stateless.
However, even if a widget is stateful, the containing parent widget can still
be stateless if it isn’t itself reacting to those changes (or other inputs).

The following example shows how to use a `StatelessWidget`. A common
`StatelessWidget` is the `Text` widget. If you look at the implementation of
the `Text` widget you'll find it subclasses `StatelessWidget`.

<!-- skip -->
{% prettify dart %}
new Text(
  'I like Flutter!',
  style: new TextStyle(fontWeight: FontWeight.bold),
);
{% endprettify %}

If you look at the code above, you might notice that the `Text` widget
carries no explicit state with it. It renders what is passed in its
constructors and nothing more.

But, what if you want to make "I Like Flutter" change dynamically, for example
when clicking a `FloatingActionButton`?

To achieve this, wrap the `Text` widget in a `StatefulWidget` and
update it when the user clicks the button.

For example:

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  // Default placeholder text
  String textToShow = "I Like Flutter";
  void _updateText() {
    setState(() {
      // update the text
      textToShow = "Flutter is Awesome!";
    });
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new Center(child: new Text(textToShow)),
      floatingActionButton: new FloatingActionButton(
        onPressed: _updateText,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }
}
{% endprettify %}

## How do I lay out my widgets? Where is my Storyboard?

In iOS, you might use a Storyboard file to organize your views and set
constraints, or you might set your constraints programmatically in your view
controllers. In Flutter, declare your layout in code by composing
a widget tree.

The following example shows how to display a simple widget with padding:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("Sample App"),
    ),
    body: new Center(
      child: new CupertinoButton(
        onPressed: () {
          setState(() { _pressedCount += 1; });
        },
        child: new Text('Hello'),
        padding: new EdgeInsets.only(left: 10.0, right: 10.0),
      ),
    ),
  );
}
{% endprettify %}

You can add padding to any widget, which mimics the functionality of
constraints in iOS.

You can view the layouts that Flutter has to offer in the [widget
catalog](/widgets/layout/).

## How do I add or remove a component from my layout?

In iOS, you call `addSubview()` on the parent, or `removeFromSuperview()`
on a child view to dynamically add or remove child views. In Flutter, because
widgets are immutable there is no direct equivalent to `addSubview()`.
Instead, you can pass a function to the parent that returns a widget, and
control that child's creation with a boolean flag.

The following example shows how to toggle between two widgets when the user clicks
the `FloatingActionButton`:

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  // Default value for toggle
  bool toggle = true;
  void _toggle() {
    setState(() {
      toggle = !toggle;
    });
  }

  _getToggleChild() {
    if (toggle) {
      return new Text('Toggle One');
    } else {
      return new CupertinoButton(
        onPressed: () {},
        child: new Text('Toggle Two'),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new Center(
        child: _getToggleChild(),
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _toggle,
        tooltip: 'Update Text',
        child: new Icon(Icons.update),
      ),
    );
  }
}
{% endprettify %}

## 如何给 Widget 添加动画？

In iOS, you create an animation by calling the
`animate(withDuration:animations:)` method on a view. In Flutter,
use the animation library to wrap widgets inside an animated widget.

In Flutter, use an `AnimationController` which is an `Animation<double>`
that can pause, seek, stop and reverse the animation. It requires a `Ticker`
that signals when vsync happens and produces a linear interpolation between
0 and 1 on each frame while it's running. You then create one or more
`Animation`s and attach them to the controller.

For example, you might use `CurvedAnimation` to implement an animation
along an interpolated curve. In this sense, the controller
is the "master" source of the animation progress and the `CurvedAnimation`
computes the curve that replaces the controller's default linear motion.
Like widgets, animations in Flutter work with composition.

When building the widget tree you assign the `Animation` to an animated
property of a widget, such as the opacity of a `FadeTransition`, and tell the
controller to start the animation.

The following example shows how to write a `FadeTransition` that fades the widget
into a logo when you press the `FloatingActionButton`:

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Fade Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyFadeTest(title: 'Fade Demo'),
    );
  }
}

class MyFadeTest extends StatefulWidget {
  MyFadeTest({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyFadeTest createState() => new _MyFadeTest();
}

class _MyFadeTest extends State<MyFadeTest> with TickerProviderStateMixin {
  AnimationController controller;
  CurvedAnimation curve;

  @override
  void initState() {
    controller = new AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    curve = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new Center(
        child: new Container(
          child: new FadeTransition(
            opacity: curve,
            child: new FlutterLogo(
              size: 100.0,
            )
          )
        )
      ),
      floatingActionButton: new FloatingActionButton(
        tooltip: 'Fade',
        child: new Icon(Icons.brush),
        onPressed: () {
          controller.forward();
        },
      ),
    );
  }

  @override
  dispose() {
    controller.dispose();
    super.dispose();
  }
}
{% endprettify %}

For more information, see
[Animation & Motion widgets](/widgets/animation/),
the [Animations tutorial](/tutorials/animation),
and the [Animations overview](/animations/).

## How do I draw to the screen?

On iOS, you use `CoreGraphics` to draw lines and shapes to the
screen. Flutter has a different API based on the `Canvas` class, with two
other classes that help you draw: `CustomPaint` and `CustomPainter`, the
latter of which implements your algorithm to draw to the canvas.

To learn how to implement a signature painter in Flutter, see Collin's answer on
[StackOverflow](https://stackoverflow.com/questions/46241071/create-signature-area-
for-mobile-app-in-dart-flutter).

<!-- skip -->
{% prettify dart %}
class SignaturePainter extends CustomPainter {
  SignaturePainter(this.points);

  final List<Offset> points;

  void paint(Canvas canvas, Size size) {
    var paint = new Paint()
      ..color = Colors.black
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 5.0;
    for (int i = 0; i < points.length - 1; i++) {
      if (points[i] != null && points[i + 1] != null)
        canvas.drawLine(points[i], points[i + 1], paint);
    }
  }

  bool shouldRepaint(SignaturePainter other) => other.points != points;
}

class Signature extends StatefulWidget {
  SignatureState createState() => new SignatureState();
}

class SignatureState extends State<Signature> {

  List<Offset> _points = <Offset>[];

  Widget build(BuildContext context) {
    return new GestureDetector(
      onPanUpdate: (DragUpdateDetails details) {
        setState(() {
          RenderBox referenceBox = context.findRenderObject();
          Offset localPosition =
          referenceBox.globalToLocal(details.globalPosition);
          _points = new List.from(_points)..add(localPosition);
        });
      },
      onPanEnd: (DragEndDetails details) => _points.add(null),
      child: new CustomPaint(painter: new SignaturePainter(_points), size: Size.infinite),
    );
  }
}
{% endprettify %}

## Where is the widget's opacity?

On iOS, everything has .opacity or .alpha. In Flutter, most of the time you need to
wrap a widget in an Opacity widget to accomplish this.

## How do I build custom widgets?

In iOS, you typically subclass `UIView`, or use a pre-existing view, to
override and implement methods that achieve the desired behavior. In
In Flutter, build a custom widget by
[composing](/technical-overview/#everythings-a-widget) smaller widgets
(instead of extending them).

For example, how do you build a `CustomButton` that takes a label in
the constructor? Create a CustomButton that composes a `RaisedButton` with a label,
rather than by extending `RaisedButton`:

<!-- skip -->
{% prettify dart %}
class CustomButton extends StatelessWidget {
  final String label;

  CustomButton(this.label);

  @override
  Widget build(BuildContext context) {
    return new RaisedButton(onPressed: () {}, child: new Text(label));
  }
}
{% endprettify %}

Then use `CustomButton`, just as you'd use any other Flutter widget:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return new Center(
    child: new CustomButton("Hello"),
  );
}
{% endprettify %}

# 导航

## 如何在页面间进行导航？

In iOS, to travel between view controllers, you can use a
`UINavigationController` that manages the stack of view controllers to
display.

Flutter has a similar implementation, using a `Navigator` and
`Routes`. A `Route` is an abstraction for a “screen” or “page” of an app, and
a `Navigator` is a [widget](technical-overview/#everythings-a-widget)
that manages routes. A route roughly maps to a
`UIViewController`. The navigator works in a similar way to the iOS
`UINavigationController`, in that it can `push()` and `pop()` routes depending
on whether you want to navigate to, or back from, a view.

To navigate between pages, you have a couple options:

* Specify a `Map` of route names. (MaterialApp)
* Directly navigate to a route. (WidgetApp)

The following example builds a Map.

<!-- skip -->
{% prettify dart %}
void main() {
  runApp(new MaterialApp(
    home: new MyAppHome(), // becomes the route named '/'
    routes: <String, WidgetBuilder> {
      '/a': (BuildContext context) => new MyPage(title: 'page A'),
      '/b': (BuildContext context) => new MyPage(title: 'page B'),
      '/c': (BuildContext context) => new MyPage(title: 'page C'),
    },
  ));
}
{% endprettify %}

Navigate to a route by `push`ing its name to the `Navigator`.

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pushNamed('/b');
{% endprettify %}

The `Navigator` class handles routing in Flutter and is used to get
a result back from a route that you have pushed on the stack. This is done
by `await`ing on the `Future` returned by `push()`.

For example, to start a ‘location’ route that lets the user select their
location, you might do the following:

<!-- skip -->
{% prettify dart %}
Map coordinates = await Navigator.of(context).pushNamed('/location');
{% endprettify %}

And then, inside your ‘location’ route, once the user has selected their
location, `pop()` the stack with the result:

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pop({"lat":43.821757,"long":-79.226392});
{% endprettify %}

## 如何跳转到其他应用程序？

In iOS, to send the user to another application, you use a
specific URL scheme. For the system level apps, the scheme
depends on the app. To implement this functionality in Flutter,
create a native platform integration, or use an existing
[plugin](#plugins), such as
[`url_launcher`](https://pub.dartlang.org/packages/url_launcher).

# Threading & asynchronicity

## How do I write asynchronous code?

Dart has a single-threaded execution model, with support for `Isolate`s (a way
to run Dart code on another thread), an event loop, and asynchronous programming.
Unless you spawn an `Isolate`, your Dart code runs in the main UI thread and is
driven by an event loop. Flutter’s event loop is equivalent to the iOS main
loop&mdash;that is, the `Looper` that is attached to the main thread.

Dart’s single-threaded model doesn’t mean you are required to run everything as
a blocking operation that causes the UI to freeze. Instead,
use the asynchronous facilities that the Dart language provides, such as
`async`/`await`, to perform asynchronous work.

For example, you can run network code without causing the UI to hang by using
`async`/`await` and letting Dart do the heavy lifting:

<!-- skip -->
{% prettify dart %}
loadData() async {
  String dataURL = "https://jsonplaceholder.typicode.com/posts";
  http.Response response = await http.get(dataURL);
  setState(() {
    widgets = json.decode(response.body);
  });
}
{% endprettify %}

Once the `await`ed network call is done, update the UI by calling `setState()`,
which triggers a rebuild of the widget sub-tree and updates the data.

The following example loads data asynchronously and displays it in a `ListView`:

<!-- skip -->
{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();

    loadData();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new ListView.builder(
          itemCount: widgets.length,
          itemBuilder: (BuildContext context, int position) {
            return getRow(position);
          }));
  }

  Widget getRow(int i) {
    return new Padding(
      padding: new EdgeInsets.all(10.0),
      child: new Text("Row ${widgets[i]["title"]}")
    );
  }

  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
{% endprettify %}

Refer to the next section for more information on doing work in the
background, and how Flutter differs from iOS.

## How do you move work to a background thread?

Since Flutter is single threaded and runs an event loop (like Node.js), you
don't have to worry about thread management or spawning background threads. If
you're doing I/O-bound work, such as disk access or a network call, then
you can safely use `async`/`await` and you're done. If, on the other
hand, you need to do computationally intensive work that keeps the CPU busy,
you want to move it to an `Isolate` to avoid blocking the event loop.

For I/O-bound work, declare the function as an `async` function,
and `await` on long-running tasks inside the function:

<!-- skip -->
{% prettify dart %}
loadData() async {
  String dataURL = "https://jsonplaceholder.typicode.com/posts";
  http.Response response = await http.get(dataURL);
  setState(() {
    widgets = json.decode(response.body);
  });
}
{% endprettify %}

This is how you typically do network or database calls, which are both
I/O operations.

However, there are times when you might be processing a large amount of data and
your UI hangs. In Flutter, use `Isolate`s to take advantage of
multiple CPU cores to do long-running or computationally intensive tasks.

Isolates are separate execution threads that do not share any memory
with the main execution memory heap. This means you can’t access variables from
the main thread, or update your UI by calling `setState()`. Isolates are true to
their name, and cannot share memory (in the form of static fields, for example).

The following example shows, in a simple isolate, how to share data back to
the main thread to update the UI.

<!-- skip -->
{% prettify dart %}
loadData() async {
  ReceivePort receivePort = new ReceivePort();
  await Isolate.spawn(dataLoader, receivePort.sendPort);

  // The 'echo' isolate sends its SendPort as the first message
  SendPort sendPort = await receivePort.first;

  List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

  setState(() {
    widgets = msg;
  });
}

// The entry point for the isolate
static dataLoader(SendPort sendPort) async {
  // Open the ReceivePort for incoming messages.
  ReceivePort port = new ReceivePort();

  // Notify any other isolates what port this isolate listens to.
  sendPort.send(port.sendPort);

  await for (var msg in port) {
    String data = msg[0];
    SendPort replyTo = msg[1];

    String dataURL = data;
    http.Response response = await http.get(dataURL);
    // Lots of JSON to parse
    replyTo.send(json.decode(response.body));
  }
}

Future sendReceive(SendPort port, msg) {
  ReceivePort response = new ReceivePort();
  port.send([msg, response.sendPort]);
  return response.first;
}
{% endprettify %}

Here, `dataLoader()` is the `Isolate` that runs in its own separate execution thread.
In the isolate you can perform more CPU intensive processing (parsing a big JSON, for
example), or perform computationally intensive math, such as encryption or signal processing.

You can run the full example below:

{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:isolate';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    if (widgets.length == 0) {
      return true;
    }

    return false;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sample App"),
        ),
        body: getBody());
  }

  ListView getListView() => new ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    return new Padding(padding: new EdgeInsets.all(10.0), child: new Text("Row ${widgets[i]["title"]}"));
  }

  loadData() async {
    ReceivePort receivePort = new ReceivePort();
    await Isolate.spawn(dataLoader, receivePort.sendPort);

    // The 'echo' isolate sends its SendPort as the first message
    SendPort sendPort = await receivePort.first;

    List msg = await sendReceive(sendPort, "https://jsonplaceholder.typicode.com/posts");

    setState(() {
      widgets = msg;
    });
  }

// the entry point for the isolate
  static dataLoader(SendPort sendPort) async {
    // Open the ReceivePort for incoming messages.
    ReceivePort port = new ReceivePort();

    // Notify any other isolates what port this isolate listens to.
    sendPort.send(port.sendPort);

    await for (var msg in port) {
      String data = msg[0];
      SendPort replyTo = msg[1];

      String dataURL = data;
      http.Response response = await http.get(dataURL);
      // Lots of JSON to parse
      replyTo.send(json.decode(response.body));
    }
  }

  Future sendReceive(SendPort port, msg) {
    ReceivePort response = new ReceivePort();
    port.send([msg, response.sendPort]);
    return response.first;
  }
}
{% endprettify %}

## How do I make network requests?

Making a network call in Flutter is easy when you use the popular
[`http` package](https://pub.dartlang.org/packages/http). This abstracts
away a lot of the networking that you might normally implement yourself,
making it simple to make network calls.

To use the `http` package, add it to your dependencies in `pubspec.yaml`:

<!-- skip -->
{% prettify yaml %}
dependencies:
  ...
  http: ^0.11.3+16
{% endprettify %}

To make a network call, call `await` on the `async` function `http.get()`:

<!-- skip -->
{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
[...]
  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
{% endprettify %}

## How do I show the progress of a long-running task?

In iOS, you typically use a `UIProgressView` while executing a
long-running task in the background.

In Flutter, use a `ProgressIndicator` widget.
Show the progress programmatically by controlling when it's rendered
through a boolean flag. Tell Flutter to update its state before your
long-running task starts, and hide it after it ends.

In the example below, the build function is separated into three different
functions. If `showLoadingDialog()` is `true` (when `widgets.length == 0`),
then render the `ProgressIndicator`. Otherwise, render the
`ListView` with the data returned from a network call.

<!-- skip -->
{% prettify dart %}
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    loadData();
  }

  showLoadingDialog() {
    return widgets.length == 0;
  }

  getBody() {
    if (showLoadingDialog()) {
      return getProgressDialog();
    } else {
      return getListView();
    }
  }

  getProgressDialog() {
    return new Center(child: new CircularProgressIndicator());
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Sample App"),
        ),
        body: getBody());
  }

  ListView getListView() => new ListView.builder(
      itemCount: widgets.length,
      itemBuilder: (BuildContext context, int position) {
        return getRow(position);
      });

  Widget getRow(int i) {
    return new Padding(padding: new EdgeInsets.all(10.0), child: new Text("Row ${widgets[i]["title"]}"));
  }

  loadData() async {
    String dataURL = "https://jsonplaceholder.typicode.com/posts";
    http.Response response = await http.get(dataURL);
    setState(() {
      widgets = json.decode(response.body);
    });
  }
}
{% endprettify %}

# Project structure, localization, dependencies and assets

## How do I include image assets for Flutter? What about multiple resolutions?

While iOS treats images and assets as distinct items, Flutter apps have only
assets. Resources that are placed in the `Images.xcasset` folder on iOS,
are placed in an assets folder for Flutter.
As with iOS, assets are any type of file, not just images.
For example, you might have a JSON file located in the `my-assets` folder:

```
my-assets/data.json
```

Declare the asset in the `pubspec.yaml` file:

<!-- skip -->
{% prettify yaml %}
assets:
 - my-assets/data.json
{% endprettify %}

And then access it from code using an
[`AssetBundle`](https://docs.flutter.io/flutter/services/AssetBundle-class.html):

<!-- skip -->
{% prettify dart %}
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('my-assets/data.json');
}
{% endprettify %}

For images, Flutter follows a simple density-based format like iOS. Image assets
might be `1.0x`, `2.0x`, `3.0x`, or any other multiplier. The so-called
[`devicePixelRatio`](https://docs.flutter.io/flutter/dart-ui/Window/devicePixelRatio.html)
expresses the ratio of physical pixels in a single logical pixel.

Assets are located in any arbitrary folder&mdash;Flutter has no
predefined folder structure. You declare the assets (with location) in
the `pubspec.yaml` file, and Flutter picks them up.

For example, to add an image called `my_icon.png` to your Flutter
project, you might decide to store it in a folder arbitrarily called `images`.
Place the base image (1.0x) in the `images` folder, and the
other variants in sub-folders named after the appropriate ratio multiplier:

```
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

Next, declare these images in the `pubspec.yaml` file:

<!-- skip -->
{% prettify yaml %}
assets:
 - images/my_icon.jpeg
{% endprettify %}

You can now access your images using `AssetImage`:

<!-- skip -->
{% prettify dart %}
return new AssetImage("images/a_dot_burr.jpeg");
{% endprettify %}

or directly in an `Image` widget:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return new Image.asset("images/my_image.png");
}
{% endprettify %}

For more details, see
[Adding Assets and Images in Flutter](/assets-and-images).

## Where do I store strings? How do I handle localization?

Unlike iOS, which has the `Localizable.strings` file, Flutter doesn't
currently have a dedicated system for handling strings. At the moment, the
best practice is to declare your copy text in a class as static fields and
access them from there. For example:

<!-- skip -->
{% prettify dart %}
class Strings {
  static String welcomeMessage = "Welcome To Flutter";
}
{% endprettify %}

You can access your strings as such:

<!-- skip -->
{% prettify dart %}
new Text(Strings.welcomeMessage)
{% endprettify %}

By default, Flutter only supports US English for its strings. If you need to
add support for other languages, include the `flutter_localizations`
package. You might also need to add Dart's [`intl`](https://pub.dartlang.org/packages/intl)
package to use i10n machinery, such as date/time formatting.

<!-- skip -->
{% prettify yaml %}
dependencies:
  # ...
  flutter_localizations:
    sdk: flutter
  intl: "^0.15.6"
{% endprettify %}

To use the `flutter_localizations` package,
specify the `localizationsDelegates` and `supportedLocales` on the app widget:

<!-- skip -->
{% prettify dart %}
import 'package:flutter_localizations/flutter_localizations.dart';

new MaterialApp(
 localizationsDelegates: [
   // Add app-specific localization delegate[s] here
   GlobalMaterialLocalizations.delegate,
   GlobalWidgetsLocalizations.delegate,
 ],
 supportedLocales: [
    const Locale('en', 'US'), // English
    const Locale('he', 'IL'), // Hebrew
    // ... other locales the app supports
  ],
  // ...
)
{% endprettify %}

The delegates contain the actual localized values, while the `supportedLocales`
defines which locales the app supports. The above example uses a `MaterialApp`,
so it has both a `GlobalWidgetsLocalizations` for the base
widgets localized values, and a `MaterialWidgetsLocalizations` for the Material
widgets localizations. If you use `WidgetsApp` for your app, you don't
need the latter. Note that these two delegates contain "default"
values, but you'll need to provide one or more delegates for your own app's
localizable copy, if you want those to be localized too.

When initialized, the `WidgetsApp` (or `MaterialApp`) creates a
[`Localizations`](https://docs.flutter.io/flutter/widgets/Localizations-class.html)
widget for you, with the delegates you specify.
The current locale for the device is always accessible from the `Localizations`
widget from the current context (in the form of a `Locale` object), or using the
[`Window.locale`](https://docs.flutter.io/flutter/dart-ui/Window/locale.html).

To access localized resources, use the `Localizations.of()` method to
access a specific localizations class that is provided by a given delegate.
Use the [`intl_translation`](https://pub.dartlang.org/packages/intl_translation)
package to extract translatable copy to
[arb](https://code.google.com/p/arb/wiki/ApplicationResourceBundleSpecification)
files for translating, and importing them back into the app for using them
with `intl`.

For further details on internationalization and localization in Flutter, see the
[internationalization guide](/tutorials/internationalization),
which has sample code with and without the `intl` package.

Note that before Flutter 1.0 beta 2, assets defined in Flutter were not
accessible from the native side, and vice versa, native assets and resources
weren’t available to Flutter, as they lived in separate folders.

## What is the equivalent of Cocoapods? How do I add dependencies?

In iOS, you add dependencies by adding to your `Podfile`. Flutter uses Dart’s
build system and the Pub package manager to handle dependencies. The tools
delegate the building of the native Android and iOS wrapper apps to the
respective build systems.

While there is a Podfile in the iOS folder in your
Flutter project, only use this if you are adding native
dependencies needed for per-platform integration. In general, use
`pubspec.yaml` to declare external dependencies in Flutter. A good place to
find great packages for Flutter is
[Pub](https://pub.dartlang.org/flutter/packages/).

# ViewControllers

## What is the equivalent to `ViewController`s in Flutter?

In iOS, a `ViewController` represents a portion of user interface, most
commonly used for a screen or section. These are composed together to build
complex user interfaces, and help scale your application's UI. In Flutter, this
job falls to Widgets. As mentioned in the Navigation
section, screens in Flutter are represented by Widgets since "everything is a
widget!" Use a `Navigator` to move between different `Route`s
that represent different screens or pages, or maybe different states or
renderings of the same data.

## How do I listen to iOS lifecycle events?

In iOS, you can override methods to the `ViewController` to capture lifecycle
methods for the view itself, or register lifecycle callbacks in the
`AppDelegate`. In Flutter you have neither concept, but you can instead listen
to lifecycle events by hooking into the `WidgetsBinding` observer and
listening to the `didChangeAppLifecycleState()` change event.

The observable lifecycle events are:

* `inactive` — The application is in an inactive state and is not receiving
user input. This event only works on iOS, as there is no equivalent event on
Android.
* `paused` — The application is not currently visible to
the user, is not responding to user input, but is running in the background.
* `resumed` — The application is visible and responding to user input.
* `suspending` — The application is suspended momentarily. The iOS platform
has no equivalent event.

For more details on the meaning of these states, see
[`AppLifecycleStatus` documentation](https://docs.flutter.io/flutter/dart-ui
/AppLifecycleState-class.html).

# Layouts

## What is the equivalent of a `UITableView` or `UICollectionView` in Flutter?

In iOS, you might show a list in either a `UITableView` or a
`UICollectionView`. In Flutter, you have a similar implementation using a
`ListView`.
In iOS, these views have delegate methods for deciding the number of rows, the
cell for each index path, and the size of the cells.

Due to Flutter’s immutable widget pattern, you pass a list of widgets to your
`ListView`, and Flutter takes care of making sure that scrolling is fast
and smooth.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new ListView(children: _getListData()),
    );
  }

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(new Padding(padding: new EdgeInsets.all(10.0), child: new Text("Row $i")));
    }
    return widgets;
  }
}
{% endprettify %}

## How do I know which list item is clicked?

In iOS, you implement the delegate method, `tableView:didSelectRowAtIndexPath:`.
In Flutter, use the touch handling provided by the passed-in widgets.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new ListView(children: _getListData()),
    );
  }

  _getListData() {
    List<Widget> widgets = [];
    for (int i = 0; i < 100; i++) {
      widgets.add(new GestureDetector(
        child: new Padding(
          padding: new EdgeInsets.all(10.0),
          child: new Text("Row $i"),
        ),
        onTap: () {
          print('row tapped');
        },
      ));
    }
    return widgets;
  }
}
{% endprettify %}

## How do I update `ListView`s dynamically?

In iOS, you update the data for the list view, and notify the table or
collection view using the `reloadData` method.

In Flutter, if you were to update the list of widgets inside a `setState()`,
you would quickly see that your data did not change visually.
This is because when `setState()` is called, the Flutter rendering engine
looks at the widget tree to see if anything has changed. When it gets to your
`ListView`, it performs a `==` check, and determines that the two `ListView`s are the
same. Nothing has changed, so no update is required.

For a simple way to update your `ListView`, create a new `List` inside of
`setState()`, and copy the data from the old list to the new list.
While this approach is simple, it is not recommended for large data sets,
as shown in the next example.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new ListView(children: widgets),
    );
  }

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text("Row $i"),
      ),
      onTap: () {
        setState(() {
          widgets = new List.from(widgets);
          widgets.add(getRow(widgets.length + 1));
          print('row $i');
        });
      },
    );
  }
}
{% endprettify %}

The recommended, efficient, and effective way to build a list uses a
`ListView.Builder`. This method is great when you have a dynamic
list or a list with very large amounts of data.

<!-- skip -->
{% prettify dart %}
import 'package:flutter/material.dart';

void main() {
  runApp(new SampleApp());
}

class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  List widgets = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 100; i++) {
      widgets.add(getRow(i));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new ListView.builder(
        itemCount: widgets.length,
        itemBuilder: (BuildContext context, int position) {
          return getRow(position);
        },
      ),
    );
  }

  Widget getRow(int i) {
    return new GestureDetector(
      child: new Padding(
        padding: new EdgeInsets.all(10.0),
        child: new Text("Row $i"),
      ),
      onTap: () {
        setState(() {
          widgets.add(getRow(widgets.length + 1));
          print('row $i');
        });
      },
    );
  }
}
{% endprettify %}

Instead of creating a "ListView", create a `ListView.builder` that
takes two key parameters: the initial length of the list, and an `ItemBuilder`
function.

The `ItemBuilder` function is similar to the `cellForItemAt` delegate method
in an iOS table or collection view, as it takes a position, and returns the
cell you want rendered at that position.

Finally, but most importantly, notice that the `onTap()` function
doesn't recreate the list anymore, but instead `.add`s to it.

## What is the equivalent of a `ScrollView` in Flutter?

In iOS, you wrap your views in a `ScrollView` that allows a user to scroll
your content if needed.

In Flutter the easiest way to do this is using the `ListView` widget. This
acts as both a `ScrollView` and an iOS `TableView`, as you can layout widgets
in a vertical format.

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return new ListView(
    children: <Widget>[
      new Text('Row One'),
      new Text('Row Two'),
      new Text('Row Three'),
      new Text('Row Four'),
    ],
  );
}
{% endprettify %}

For more detailed docs on how to lay out widgets in Flutter,
see the [layout tutorial](/widgets/layout/).

# Gesture detection and touch event handling

## How do I add a click listener to a widget in Flutter?

In iOS, you attach a `GestureRecognizer` to a view to handle
click events. In Flutter, there are two ways of adding touch listeners:

<ol markdown="1">
<li markdown="1">
If the widget supports event detection, pass a function to it,
 and handle the event in the function. For example, the
`RaisedButton` widget has an `onPressed` parameter:

   <!-- skip -->
   {% prettify dart %}
   @override
   Widget build(BuildContext context) {
     return new RaisedButton(
       onPressed: () {
         print("click");
       },
       child: new Text("Button"),
     );
   }
   {% endprettify %}
</li>

<li markdown="1">
If the Widget doesn't support event detection, wrap the
widget in a GestureDetector and pass a function to the `onTap` parameter.

   <!-- skip -->
   {% prettify dart %}
   class SampleApp extends StatelessWidget {
     @override
     Widget build(BuildContext context) {
       return new Scaffold(
         body: new Center(
           child: new GestureDetector(
             child: new FlutterLogo(
               size: 200.0,
             ),
             onTap: () {
               print("tap");
             },
           ),
         ),
       );
     }
   }
   {% endprettify %}
</li>
</ol>

## How do I handle other gestures on widgets?

Using `GestureDetector` you can listen to a wide range of gestures such as:

* Tapping

  * `onTapDown` — A pointer that might cause a tap has contacted the screen at a
    particular location.
  * `onTapUp` — A pointer that triggers a tap has stopped contacting the
    screen at a particular location.
  * `onTap` — A tap has occurred.
  * `onTapCancel` — The pointer that previously triggered the `onTapDown` won't
    cause a tap.

* Double tapping

  * `onDoubleTap` — The user tapped the screen at the same location twice in
    quick succession.

* Long pressing

  * `onLongPress` — A pointer has remained in contact with the screen at the same
    location for a long period of time.

* Vertical dragging

  * `onVerticalDragStart` — A pointer has contacted the screen and might begin to
    move vertically.
  * `onVerticalDragUpdate` — A pointer in contact with the screen
    has moved further in the vertical direction.
  * `onVerticalDragEnd` — A pointer that was previously in contact with the
    screen and moving vertically is no longer in contact with the screen and was
    moving at a specific velocity when it stopped contacting the screen.

* Horizontal dragging

  * `onHorizontalDragStart` — A pointer has contacted the screen and might begin
    to move horizontally.
  * `onHorizontalDragUpdate` — A pointer in contact with the screen
    has moved further in the horizontal direction.
  * `onHorizontalDragEnd` — A pointer that was previously in contact with the
    screen and moving horizontally is no longer in contact with the screen.

The following example shows a `GestureDetector` that rotates the Flutter logo
on a double tap:

<!-- skip -->
{% prettify dart %}
AnimationController controller;
CurvedAnimation curve;

@override
void initState() {
  controller = new AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
  curve = new CurvedAnimation(parent: controller, curve: Curves.easeIn);
}

class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new GestureDetector(
          child: new RotationTransition(
            turns: curve,
            child: new FlutterLogo(
              size: 200.0,
            )),
          onDoubleTap: () {
            if (controller.isCompleted) {
              controller.reverse();
            } else {
              controller.forward();
            }
          },
        ),
      ),
    );
  }
}
{% endprettify %}

# Theming and text

## How do I theme an app?

Out of the box, Flutter comes with a beautiful implementation of Material Design,
which takes care of a lot of styling and theming needs that you would typically do.

To take full advantage of Material Components in your app, declare a top-level
widget, MaterialApp, as the entry point to your application. MaterialApp is a convenience
widget that wraps a number of widgets that are commonly required for applications
implementing Material Design. It builds upon a WidgetsApp by adding Material
specific functionality.

But Flutter is flexible and expressive enough to implement any design language.
On iOS, you can use the
[Cupertino library](https://docs.flutter.io/flutter/cupertino/cupertino-library.html)
to produce an interface that adheres to the [Human Interface
Guidelines](https://developer.apple.com/ios/human-interface-guidelines/overview/themes/).
For the full set of these widgets, see the
[Cupertino widgets gallery](/widgets/cupertino/).

You can also use a `WidgetApp` as your app widget, which provides some of the
same functionality, but is not as rich as `MaterialApp`.

To customize the colors and styles of any child components, pass a
`ThemeData` object to the `MaterialApp` widget. For example, in the code below,
the primary swatch is set to blue and text selection color is red.

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
        textSelectionColor: Colors.red
      ),
      home: new SampleAppPage(),
    );
  }
}
{% endprettify %}

## How do I set custom fonts on my `Text` widgets?

In iOS, you import any `ttf` font files into your project and create a
reference in the `info.plist` file. In Flutter, place the font file
in a folder and reference it in the `pubspec.yaml` file, similar to how you
import images.

<!-- skip -->
{% prettify yaml %}
fonts:
   - family: MyCustomFont
     fonts:
       - asset: fonts/MyCustomFont.ttf
       - style: italic
{% endprettify %}

Then assign the font to your `Text` widget:

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return new Scaffold(
    appBar: new AppBar(
      title: new Text("Sample App"),
    ),
    body: new Center(
      child: new Text(
        'This is a custom font text',
        style: new TextStyle(fontFamily: 'MyCustomFont'),
      ),
    ),
  );
}
{% endprettify %}

## How do I style my `Text` widgets?

Along with fonts, you can customize other styling elements on a `Text` widget.
The style parameter of a `Text` widget takes a `TextStyle` object, where you can
customize many parameters, such as:

* `color`
* `decoration`
* `decorationColor`
* `decorationStyle`
* `fontFamily`
* `fontSize`
* `fontStyle`
* `fontWeight`
* `hashCode`
* `height`
* `inherit`
* `letterSpacing`
* `textBaseline`
* `wordSpacing`

# Form input

## How do forms work in Flutter? How do I retrieve user input?

Given how Flutter uses immutable widgets with a separate state, you might be
wondering how user input fits into the picture. On iOS, you usually
query the widgets for their current values when it's time to submit the
user input, or action on it. How does that work in Flutter?

In practice forms are handled, like everything in Flutter, by specialized
widgets. If you have a `TextField` or a `TextFormField`, you can supply a
[`TextEditingController`](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html)
to retrieve user input:

<!-- skip -->
{% prettify dart %}
class _MyFormState extends State<MyForm> {
  // Create a text controller and use it to retrieve the current value.
  // of the TextField!
  final myController = new TextEditingController();

  @override
  void dispose() {
    // Clean up the controller when disposing of the Widget.
    myController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text('Retrieve Text Input'),
      ),
      body: new Padding(
        padding: const EdgeInsets.all(16.0),
        child: new TextField(
          controller: myController,
        ),
      ),
      floatingActionButton: new FloatingActionButton(
        // When the user presses the button, show an alert dialog with the
        // text the user has typed into our text field.
        onPressed: () {
          return showDialog(
            context: context,
            builder: (context) {
              return new AlertDialog(
                // Retrieve the text the user has typed in using our
                // TextEditingController
                content: new Text(myController.text),
              );
            },
          );
        },
        tooltip: 'Show me the value!',
        child: new Icon(Icons.text_fields),
      ),
    );
  }
}
{% endprettify %}

You can find more information and the full code listing in
[Retrieve the value of a text field](/cookbook/forms/retrieve-input/),
from the [Flutter Cookbook](https://flutter.io/cookbook/).

## What is the equivalent of a placeholder in a text field?

In Flutter you can easily show a "hint" or a placeholder text for your field by
adding an `InputDecoration` object to the decoration constructor parameter for
the `Text` widget:

<!-- skip -->
{% prettify dart %}
body: new Center(
  child: new TextField(
    decoration: new InputDecoration(hintText: "This is a hint"),
  ),
)
{% endprettify %}

## How do I show validation errors?

Just as you would with a "hint", pass an `InputDecoration` object
to the decoration constructor for the `Text` widget.

However, you don't want to start off by showing an error.
Instead, when the user has entered invalid data,
update the state, and pass a new `InputDecoration` object.

<!-- skip -->
{% prettify dart %}
class SampleApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Sample App',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new SampleAppPage(),
    );
  }
}

class SampleAppPage extends StatefulWidget {
  SampleAppPage({Key key}) : super(key: key);

  @override
  _SampleAppPageState createState() => new _SampleAppPageState();
}

class _SampleAppPageState extends State<SampleAppPage> {
  String _errorText;

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Sample App"),
      ),
      body: new Center(
        child: new TextField(
          onSubmitted: (String text) {
            setState(() {
              if (!isEmail(text)) {
                _errorText = 'Error: This is not an email';
              } else {
                _errorText = null;
              }
            });
          },
          decoration: new InputDecoration(hintText: "This is a hint", errorText: _getErrorText()),
        ),
      ),
    );
  }

  _getErrorText() {
    return _errorText;
  }

  bool isEmail(String em) {
    String emailRegexp =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';

    RegExp regExp = new RegExp(p);

    return regExp.hasMatch(em);
  }
}
{% endprettify %}

# 与硬件，第三方服务和平台进行交互


## 如何与平台以及平台原生代码交互？

Flutter doesn't run code directly on the underlying platform; rather, the Dart code
that makes up a Flutter app is run natively on the device, "sidestepping" the SDK
provided by the platform. That means, for example, when you perform a network request
in Dart, it runs directly in the Dart context. You don't use the Android or iOS
APIs you normally take advantage of when writing native apps. Your Flutter
app is still hosted in a native app's `ViewController` as a view, but you don't
have direct access to the `ViewController` itself, or the native framework.

This doesn't mean Flutter apps cannot interact with those native APIs, or with any
native code you have. Flutter provides [platform channels](/platform-channels/),
that communicate and exchange data with the `ViewController` that
hosts your Flutter view. Platform channels are essentially an asynchronous messaging
mechanism that bridge the Dart code with the host `ViewController` and
the iOS framework it runs on. You can use platform channels to execute a method on
the native side, or to retrieve some data from the device's sensors, for example.

In addition to directly using platform channels, you can use a variety of pre-made
[plugins](/using-packages/) that encapsulate the native and
Dart code for a specific goal. For example, you can use a plugin to access
the camera roll and the device camera directly from Flutter, without having to
write your own integration. Plugins are found [on Pub](https://pub.dartlang.org/),
Dart and Flutter's open source package repository. Some packages might
support native integrations on iOS, or Android, or both.

If you can't find a plugin on Pub that fits your needs, you can
[write your own](/developing-packages/)
and [publish it on Pub](/developing-packages/#publish).

## 如何使用 GPS 传感器？

Use the [`location`](https://pub.dartlang.org/packages/location) community plugin.

## 如何使用相机服务?

The [`image_picker`](https://pub.dartlang.org/packages/image_picker) plugin is popular
for accessing the camera.

## 如何使用 Facebook 进行登录?

To log in with Facebook, use the
[`flutter_facebook_login`](https://pub.dartlang.org/packages/flutter_facebook_login) community plugin.

## How do I use Firebase features?

Most Firebase functions are covered by
[first party plugins](https://pub.dartlang.org/flutter/packages?q=firebase).
These plugins are first-party integrations, maintained by the Flutter team:

 * [`firebase_admob`](https://pub.dartlang.org/packages/firebase_admob) for Firebase AdMob
 * [`firebase_analytics`](https://pub.dartlang.org/packages/firebase_analytics) for Firebase Analytics
 * [`firebase_auth`](https://pub.dartlang.org/packages/firebase_auth) for Firebase Auth
 * [`firebase_core`](https://pub.dartlang.org/packages/firebase_core) for Firebase's Core package
 * [`firebase_database`](https://pub.dartlang.org/packages/firebase_database) for Firebase RTDB
 * [`firebase_storage`](https://pub.dartlang.org/packages/firebase_storage) for Firebase Cloud Storage
 * [`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging) for Firebase Messaging (FCM)
 * [`cloud_firestore`](https://pub.dartlang.org/packages/cloud_firestore) for Firebase Cloud Firestore

You can also find some third-party Firebase plugins on Pub that cover areas
not directly covered by the first-party plugins.

## How do I build my own custom native integrations?

If there is platform-specific functionality that Flutter or its community
Plugins are missing, you can build your own following the
[developing packages and plugins](/developing-packages/) page.

Flutter's plugin architecture, in a nutshell, is much like using an Event bus in
Android: you fire off a message and let the receiver process and emit a result
back to you. In this case, the receiver is code running on the native side
on Android or iOS.

# 数据库和本地存储

## Flutter 中如何使用 `UserDefaults` ？

在 iOS 中，您可以使用属性列表（也就是 `UserDefaults` ）来存储键值对的集合。

在 Flutter 中，使用 [Shared Preferences](https://pub.dartlang.org/packages/shared_preferences) 插件访问同等功能。这个插件包装了 `UserDefaults` 和 Android `SharedPreferences` 同等的功能。

## iOS 中的 CoreData 在 Flutter 中对应什么


在 iOS 中，您可使用 CoreData 来存储结构化数据,这是 SQL 数据库的更高级的抽象概念，使查询与您模型相关联变得更加容易。

在 Flutter 中，使用 [SQFlite](https://pub.dartlang.org/packages/sqflite) 插件访问该功能。

# 通知

## 如何设置推送通知？

在 iOS 中，您需要在开发者平台上注册您的应用程序以允许推送通知。

在 Flutter 中 ，使用 `firebase_messaging` 插件访问此功能。

有关  Firebase Cloud Messaging API 的更多使用信息，请参阅 [`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging) 插件文档。
