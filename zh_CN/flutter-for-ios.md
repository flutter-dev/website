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

要在 iOS 中更新视图，你可以直接改变它们。在 Flutter 中，widget 是不可变的，不能直接更新。相反，你必须操作 widget 的状态。

这就是有状态的 vs 无状态的 widget 概念出现的地方。`StatelessWidget` 犹如其名&mdash;一个没有附加状态的 widget。

当你描述的用户界面部分不依赖于 widget 的初始配置信息以外的其他任何内容时，`StatelessWidgets` 就非常有用。

举个例子，在 iOS 中，这与将你的 logo 作为 `image` 放入 `UIImageView` 中类似。如果在运行期间 logo 不改变，在 Flutter 中使用 `StatelessWidget`。

如果你想要基于 HTTP 调用后收到的数据来动态改变 UI ，那么使用 `StatefulWidget`。在 HTTP 调用完成后，告诉 Flutter 框架 widget 的 `State` 已更新，以便它可以更新 UI。

无状态和有状态的 widget 之间重要的区别就是 `StatefulWidget` 具有一个 `State` 对象，用于存储状态数据并且跨树重建执行，因此不会丢失。

如有疑问，请记住这个准则：如果 widget 在 `build` 方法之外改变（例如，由于运行时用户交互），那它是有状态的。如果 widget 永远不会改变，一旦构建，它就是无状态的。然而，即使一个 widget 是有状态的，如果包含的父 widget 本身没有对这些改变（或其他输入）作出反应，它仍然可以是无状态的。

下面的例子展示了如何使用 `StatelessWidget`。一个常见的 `StatelessWidget` 是 `Text` widget。如果你看看 `Text` widget 的实现，你就会发现它是 `StatelessWidget` 的子类。

<!-- skip -->
{% prettify dart %}
new Text(
  'I like Flutter!',
  style: new TextStyle(fontWeight: FontWeight.bold),
);
{% endprettify %}

如果你看一下上面的代码，你或许会注意到 `Text` widget 并没有携带明确的状态。它呈现了构造函数中传递的内容，仅此而已。

但是，如果你想要“我喜欢 Flutter ”动态变化，例如当点击 `FloatingActionButton` 时会发生什么？

要实现这个，将 `Text` widget 包装在 `StatefulWidget` 中，并且当用户点击按钮的时候更新它。

例如:

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

## 如何布局 widget ？ Storyboard 在哪？

在 iOS 中，你或许会使用一个 Storyboard 文件来组织你的视图并设置约束，或者你可能在视图控制器中以编程方式来设置约束。在 Flutter 中，通过编写一个 widget 树来在代码中声明你的布局。

接下来的例子展示了如何去显示一个带有内边距的简单 widget ：


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

你可以为任何 widget 添加内边距，这些模仿 iOS 中的约束功能。

你可以查看 Flutter 在 [widget 目录](/widgets/layout/)中必须提供的布局。

## 如何从布局中添加或移除组件？

在 iOS 中，在父视图中调用 `addSubview()` ，或着在子视图中调用 `removeFromSuperview()` 来动态添加或移除子视图。在 Flutter 中，由于 widget 是不可变的，不能直接像 `addSubview()` 那样。你可以将函数传递给返回 widget 的父类，并用布尔标志来控制子类的创建。

接下来的例子展示了当用户点击了 `FloatingActionButton` 时，两个 widget 之间如何切换：

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

在 iOS 中，通过在视图上调用 `animate(withDuration:animations:)` 方法来创建动画。在Flutter 中，使用动画库将 widget 封装进动画 widget 中。

在 Flutter 中，使用 `AnimationController` ，这是个可以暂停，寻找，停止，反转动画的 `Animation<double>` 。它需要一个`Ticker`，用于在 vsync 发生时发出信号，并在每帧运行时在 0 和 1 之间产生线性插值。然后，您创建一个或多个 `Animation` 并将它们附加到控制器。

例如，你可能会使用 `CurvedAnimation` 来实现沿插值曲线的动画。从这个意义上说，控制器是动画过程的“主要”源，而且  `CurvedAnimation` 计算替代控制器默认的线性运动的曲线。与 widget ，Flutter 中的动画也用于合成。

当构建 widget 树时，将 `Animation` 赋值给 widget 的动画属性，例如 `FadeTransition` 的不透明度，并且告诉控制器开始动画。

接下来的列子展示了如何编写 `FadeTransition` ，当你点击 `FloatingActionButton` 时将 widget 渐渐融入进 logo 中 ：

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

有关更多信息，请查阅 [动画 & 动画 widget](/widgets/animation/) ， [动画教程](/tutorials/animation) ， [动画概览](/animations/)。

## 如何在屏幕上绘制？

在 iOS 中，使用 `CoreGraphics` 在屏幕上绘制线和形状。 Flutter 有和基于 `Canvas` 类的不同 API ，还有两个帮助你来进行绘制的类，`CustomPaint` 和 `CustomPainter` ，后面的类是实现绘制到画布上的算法。

想要了解如何在 Flutter 中实现签名器（ signature painter ），请查看 Collin 在 [StackOverflow](https://stackoverflow.com/questions/46241071/create-signature-area-for-mobile-app-in-dart-flutter) 上的回答。

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

## widget 的不透明度在哪？

在 iOS 中视图都有 .opacity 或 .alpha。在 Flutter 中，大多数情况下你需要将 widget 封装进一个 Opacity widget 中来实现这个。

## 如何构建自定义 widget？

在 iOS 中，通常会对 `UIView` 进行子类化，或使用已有的视图来重写和实现期望所需行为的方法。在 Flutter 中，通过[组合](/technical-overview/#everythings-a-widget)轻量 widget (而不是扩展它们)来构建自定义 widget。 

例如，你如何构建一个在构造函数中使用标签的 `CustomButton`？创建一个使用标签组合 `RaisedButton` 的 CustomButton ，而不是在 `RaisedButton` 上进行扩展：

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

在 iOS 中，为了在视图控制器之间切换，可以使用管理要显示视图控制器堆栈的 `UINavigationController` 。

Flutter 有一个类似的实现，使用 `Navigator` 和 `Routes`。`Route` 是应用程序“屏幕”或“页面”的抽象，`Navigator` 是一种管理路由的 [widget](technical-overview/#everythings-a-widget) 。一个路由大致上映射一个 `UIViewController` 。navigator 与 iOS 的 `UINavigationController` 工作原理相似，因为它根据是否导航到视图或从视图返回进行 `push()` 和 `pop()` 路由。

在两个页面间导航，你有几个选项：

* 指定路由名称的映射。（ MaterialApp ）
* 直接导航到路由。（ WidgetApp ）

以下示例构建一个Map。

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

通过将其名称 `push` 到 `Navigator` 来导航到路由。

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pushNamed('/b');
{% endprettify %}

`Navigator` 类在处理 Flutter 中的路由，并用于从已经推到堆栈中的路由中获取回调结果。
这是通过 `push()` 返回的 `Future` 上的 `await` 完成的。

例如，要启动允许用户选择其位置的“位置”路由，您可以执行以下操作：

<!-- skip -->
{% prettify dart %}
Map coordinates = await Navigator.of(context).pushNamed('/location');
{% endprettify %}

然后，在你的'位置'路由中，一旦用户选择了他们的位置，`pop()` 堆栈的结果是：

<!-- skip -->
{% prettify dart %}
Navigator.of(context).pop({"lat":43.821757,"long":-79.226392});
{% endprettify %}

## 如何跳转到其他应用程序？

在iOS中，要将用户发送给其他应用程序，请使用特定的URL方案。对于系统级应用程序，该方案取决于应用程序。要在Flutter中实现此功能，请创建本地平台集成，或使用现有[插件](#plugins)（如 [`url_launcher`](https://pub.dartlang.org/packages/url_launcher) ）。


# 线程 & 异步

## 如何编写异步代码？

Dart 有一个单线程执行模型，支持 `Isolate` （一种在另一个线程上运行 Dart 代码的方式），一个事件循环和异步编程。除非您生成 `Isolate` ，否则您的 Dart 代码将在主 UI 线程中运行，并由事件循环驱动。 Flutter 的事件循环相当于 iOS 主循环&mdash;即连接到主线程的 `Looper`。

Dart 的单线程模型并不意味着您需要将所有操作都作为导致 UI 冻结的阻止操作运行。相反，使用 Dart 语言提供的异步工具（例如 `async`/`await` ）来执行异步工作。

例如，您可以运行网络代码，而不会导致UI通过使用 `async`/`await` 挂起，并让 Dart 执行繁重的操作：

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

一旦 `await` 网络调用完成，通过调用 `setState()` 来更新UI，这会触发重构 widget 子树并更新数据。

以下示例异步加载数据并将其显示在 `ListView` 中：

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

有关在后台执行工作的更多信息，请参阅下一节，以及 Flutter 与 iOS 的不同之处。

## 如何将工作移至后台线程？

由于 Flutter 是单线程的并且运行事件循环（如 Node.js ），因此您不必担心线程管理或产生后台线程。如果您正在执行 I/O 绑定工作（如磁盘访问或网络调用），那么您可以安全地使用 `async`/`await` 并完成。另一方面，如果您需要进行计算密集型工作以保持 CPU 繁忙，则您需要将其移至 `Isolate` 以避免阻塞事件循环。

对于 I/O 绑定的工作，将函数声明为 `async` 函数，并在函数内的长时间运行的任务中声明 `await`：

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

这就是通常进行网络或数据库调用的方式，它们都是 I/O 操作

但是，有时您可能正在处理大量数据，并且 UI 挂起。在 Flutter 中，使用 `Isolate` 来利用多个 CPU 内核来执行长时间运行或计算密集型任务。

隔离是不共享任何内存的独立执行线程与主执行内存堆。这意味着你不能从主线程访问变量，或者通过调用 `setState()` 来更新你的 UI 。隔离对他们的名字是真实的，并且不能共享内存（例如以静态字段的形式）。


以下示例以简单的隔离方式显示如何将数据共享回主线程以更新 UI 。

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

在这里，  `dataLoader()` 是在独立执行线程中运行的 `Isolate` 。在隔离区中，您可以执行更多 CPU 密集型处理（例如解析大型 JSON ），或者执行计算密集型数学运算或信号处理。

您可以运行下面的完整示例:

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

## 如何进行网络请求？

在使用流行的 [`http` 包](https://pub.dartlang.org/packages/http)时，使用 Flutter 进行网络访问非常简单。这将您通常自己实现的大量网络抽象出来，使网络访问变得简单。

要使用 `http` 包，将它添加到 `pubspec.yaml` 中的依赖关系中：

<!-- skip -->
{% prettify yaml %}
dependencies:
  ...
  http: ^0.11.3+16
{% endprettify %}

要进行网络调用，请在 `async` 函数 `http.get()` 上调用 `await` ：

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

## 如何显示长线任务的进度？

在 iOS 中，通常使用 `UIProgressView` 来显示后台正在执行的长线任务。

在 Flutter 中，使用 `ProgressIndicator`。通过控制何时通过布尔标志显示，以编程方式显示进度。告诉 Flutter 在长线任务开始前更新其状态，并在结束后隐藏它。

在下面的示例中，build 函数被分为三个不同的函数。如果 `showLoadingDialog()` 为 `true`（当 `widgets.length == 0` ），则渲染 `ProgressIndicator` 。否则，使用网络调用返回的数据呈现 `ListView` 。

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

# 项目结构，本地化，依赖和资源

## 如何图片资源加入到 Flutter ？多分辨率怎么办？

尽管 iOS 将图像和资源视为不同的项目，但 Flutter 应用程序只有资源。在iOS上放置在 `Images.xcasset` 文件夹中的资源将放置在 Flutter 的资源文件夹中。与 iOS 一样，资源是任何类型的文件，而不仅仅是图片。例如，您可能在 `my-assets` 文件夹中有一个 JSON 文件:

```
my-assets/data.json
```

在 `pubspec.yaml` 文件中声明资源：

<!-- skip -->
{% prettify yaml %}
assets:
 - my-assets/data.json
{% endprettify %}

然后使用 [`AssetBundle`](https://docs.flutter.io/flutter/services/AssetBundle-class.html) 从代码访问它：

<!-- skip -->
{% prettify dart %}
import 'dart:async' show Future;
import 'package:flutter/services.dart' show rootBundle;

Future<String> loadAsset() async {
  return await rootBundle.loadString('my-assets/data.json');
}
{% endprettify %}

对于图片，Flutter 遵循一种简单的基于密度的格式，如 iOS 图片资源可能是 `1.0x`， `2.0x`， `3.0x` 或任何其他倍数。所谓的 [`devicePixelRatio`](https://docs.flutter.io/flutter/dart-ui/Window/devicePixelRatio.html) 表示单个逻辑像素中物理像素的比例。

资源位于任意文件夹中&mdash; Flutter 没有预定义的文件夹结构。在 `pubspec.yaml` 文件中声明资源（包含位置），Flutter 将其识别。

例如，要将名为 `my_icon.png` 的图片添加到您的 Flutter 项目中，您可能决定将其存储在任意称为 `images` 的文件夹中。将基础图像（1.0x）放置在 `images` 文件夹中，并将其他变体放在以相应比率乘数命名的子文件夹中：

```
images/my_icon.png       // Base: 1.0x image
images/2.0x/my_icon.png  // 2.0x image
images/3.0x/my_icon.png  // 3.0x image
```

接下来，在 `pubspec.yaml` 文件中声明这些图像：

<!-- skip -->
{% prettify yaml %}
assets:
 - images/my_icon.jpeg
{% endprettify %}

您现在可以使用 `AssetImage` 访问您的图片：

<!-- skip -->
{% prettify dart %}
return new AssetImage("images/a_dot_burr.jpeg");
{% endprettify %}

或者直接在 `Image` widget 中：

<!-- skip -->
{% prettify dart %}
@override
Widget build(BuildContext context) {
  return new Image.asset("images/my_image.png");
}
{% endprettify %}

更多详情，请查看[在 Flutter 中添加资源和图片](/assets-and-images)。

## 在哪存储字符串？如何处理本地化？

不像 iOS 有 `Localizable.strings` 文件，Flutter 目前没有处理字符串的专用系统。
目前，最佳做法是将您的副本文本作为静态字段声明并从那里访问它们。例如：

<!-- skip -->
{% prettify dart %}
class Strings {
  static String welcomeMessage = "Welcome To Flutter";
}
{% endprettify %}

你可以像这样访问你的字符串

<!-- skip -->
{% prettify dart %}
new Text(Strings.welcomeMessage)
{% endprettify %}

默认情况下，Flutter 仅支持美式英语字符串。如果您需要添加对其他语言的支持，请包含 `flutter_localizations` 包。您可能还需要添加 Dart 的 [`intl`](https://pub.dartlang.org/packages/intl) 包以使用 i10n 机器，例如日期/时间格式。

<!-- skip -->
{% prettify yaml %}
dependencies:
  # ...
  flutter_localizations:
    sdk: flutter
  intl: "^0.15.6"
{% endprettify %}

要使用 `flutter_localizations` 包，请在应用部件上指定 `localizationsDelegates` 和 `supportedLocales` ：

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

代理包含实际的本地化值，而 `supportedLocales` 定义应用程序支持的区域设置。上面的例子使用了一个 `MaterialApp` ，因此它既有用于基本 widget 本地化值的 `GlobalWidgetsLocalizations` ，也有用于 Material widget 本地化的 `MaterialWidgetsLocalizations` 。如果您为您的应用使用 `WidgetsApp` ，则不需要后者。请注意，这两个代理包含“默认”值，但您需要为您自己的应用的本地化副本提供一个或多个代理 ，如果您希望这些副本本地化。

初始化时，`WidgetsApp` （或 `MaterialApp` ）会为您创建一个 [`Localizations`](https://docs.flutter.io/flutter/widgets/Localizations-class.html) widget，并使用你指定的代理。设备的当前语言环境始终可以从当前上下文的 `Localizations` widget（以 `Locale` 对象的形式）或使用 [`Window.locale`](https://docs.flutter.io/flutter/dart-ui/Window/locale.html) 访问。

要访问本地化资源，请使用 `Localizations.of()` 方法访问由给定代理提供的特定本地化类。使用 [`intl_translation`](https://pub.dartlang.org/packages/intl_translation) 包将可翻译的副本提取到 [arb](https://code.google.com/p/arb/wiki/ApplicationResourceBundleSpecification) 文件进行翻译，然后将它们导入到应用程序中以便与 `intl` 一起使用它们。

有关Flutter国际化和本地化的更多详细信息，请参阅[国际化指南](/tutorials/internationalization)，其中包含带和不带 `intl` 包的示例代码。

请注意，在 Flutter 1.0 beta 2 之前，Flutter 中定义的资源无法从本地访问，反之亦然，Flutter 无法使用本地 assets 和资源，因为它们位于单独的文件夹中。

## Cocoapods 在 Flutter 中对应什么？如何添加依赖关系？

在 iOS 中，您可以通过添加到 `Podfile` 来添加依赖项。 Flutter 使用 Dart 的构建系统和 Pub 包管理器来处理依赖关系。这些工具将原生 Android 和 iOS 包装应用程序的构建委托给相应的构建系统。

虽然在 Flutter 项目的 iOS 文件夹中有一个 Podfile ，但只有在您添加每个平台集成所需的本地依赖项时才使用它。通常，使用 `pubspec.yaml` 在 Flutter 中声明外部依赖关系。[Pub](https://pub.dartlang.org/flutter/packages/) 是一个很好的地方来找找 Flutter 依赖包 。


# 视图控制器

## iOS 中的 `ViewController` 在 Flutter 中对应什么？

在 iOS 中，`ViewController` 代表用户界面的一部分，最常用于屏幕或部分。它们组合在一起构建复杂的用户界面，并帮助扩展应用程序的用户界面。在 Flutter 中，这项工作属于 Widget 。正如导航部分所述，Flutter 中的屏幕由 Widget 表示，因为“一切都是  widget ！”使用 `Navigator` 在代表不同屏幕或页面的不同 Route` 跳转，或者可能会在相同数据的不同状态或效果图之间跳转。

## 如何监听 iOS 的生命周期？

在iOS中，您可以重写 `ViewController` 的方法以捕获视图本身的生命周期方法，或者在 `AppDelegate` 中注册生命周期回调。在 Flutter 中，没有这样的概念，但是可以通过挂接到 `WidgetsBinding` 观察者并监听 `didChangeAppLifecycleState()` 更改事件来监听生命周期事件。

可观察的生命周期事件是：

* `inactive` — 应用程序处于非活动状态，并且未接收用户输入。此事件仅适用于 iOS ，因为 Android 上没有相应的事件。
* `paused` — 该应用程序目前对用户不可见，不响应用户输入，但正在后台运行。
* `resumed` — 该应用程序可见并响应用户输入。
* `suspending` — 该应用暂时中止。 iOS平台没有相应的事件。

有关这些状态含义的更多详细信息，请参阅 [`AppLifecycleStatus` 文档](https://docs.flutter.io/flutter/dart-ui
/AppLifecycleState-class.html)。

# 布局

## iOS 中的 `UITableView` 和 `UICollectionView` 在 Flutter 中对应什么？

在iOS中，您可能会在 `UITableView` 或 `UICollectionView` 中显示一个列表。在 Flutter 中，使用 `ListView` 实现类似的显示。在 iOS 中，这些视图具有代理方法来决定行数，每个单元格的索引以及单元格的大小。

由于 Flutter 的不可变 widget 模式，将 widget 列表传递给您的 `ListView` ，并且 Flutter 负责确保滚动快速而平稳。

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

## 如何知道列表的哪个条目被点击？

在 iOS 中，实现代理方法  `tableView:didSelectRowAtIndexPath:` 。在 Flutter 中，使用由传入的 widget 提供的触摸处理。

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

## 如何动态更新 `ListView` ？

在 iOS 中，使用 `reloadData` 方法通知表或集合视图来更新列表视图的数据。

在Flutter中，如果您要更新 `setState()` 内部的 widget 列表，您很快就会发现数据不会在视觉上发生变化。这是因为当调用 `setState()` 时，Flutter 渲染引擎会查看 widget 树以查看是否有更改。当它到达你的 `ListView` 时，它执行 `==` 检查，并确定两个 `ListView` 是相同的。没有任何改变，所以不需要更新。

为了更新 `ListView` 的一个简单方法，在 `setState()` 中创建一个新 `List` ，并将旧列表中的数据复制到新列表中。虽然这种方法很简单，但不推荐用于大数据集，如下一个示例所示。

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

使用 `ListView.Builder` 建立一个列表，这个方式是非常推荐的，高效的和有效的。当拥有动态列表或包含大量数据的列表时，此方法非常有用。

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

创建一个 `ListView.builder` 接受两个关键参数：列表的初始长度和一个 `ItemBuilder` 函数,而不是创建一个 “ListView” 。

`ItemBuilder` 函数与 iOS 表格或集合视图中的 `cellForItemAt` 委托方法类似，因为它需要一个位置，并返回要在该位置呈现的单元格。

最后，但最重要的是，注意 `onTap()` 函数不再重新创建列表，而是 `.add` 。


## iOS 中的 `ScrollView` 在 Flutter 中对应什么？

在 iOS 中，您可以将视图封装在 `ScrollView` 中，以便用户根据需要滚动内容。

在 Flutter 中，最简单的方法是使用 `ListView` 控件。这既可以作为 `ScrollView` 也可以作为 iOS 的 `TableView`，因为您可以以垂直格式布局 widget 。

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

更多有关如何在 Flutter 中布置 widget 的详细文档，请参阅 [布局教程](/widgets/layout/)。

# 手势检测和触摸事件处理

## 在 Flutter 中，如何为 widget 添加点击监听器？

在 iOS 中，将 `GestureRecognizer` 附加到视图以处理点击事件。在 Flutter 中，添加触摸监听器有两种方式：

<ol markdown="1">
<li markdown="1">
如果 widget 支持事件检测，则将函数传递给它，并在函数中处理事件。例如，
 `RaisedButton` widget 有一个 `onPressed` 参数:

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
如果 Widget 不支持事件检测，则将该 Widget 封装在 GestureDetector 中，并将函数传递给 `onTap` 参数。

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

## 如何处理 widget 的其他手势？

使用 `GestureDetector` 可以收听各种手势，例如：

* 点击

  * `onTapDown` — 已经在特定屏幕位置按下。
  * `onTapUp` — 在屏幕特定位置触发点击的点停止接触屏幕。
  * `onTap` — 点击已发生。
  * `onTapCancel` — 先前触发 `onTapDown` 的点击不会导致点击。

* 双击

  * `onDoubleTap` — 用户快速连续两次在同一位置点击屏幕。

* 长按

  * `onLongPress` — 在屏幕相同位置长时间保持点击状态。

* 垂直拖动

  * `onVerticalDragStart` — 与屏幕接触的点在垂直方向上进一步移动。
  * `onVerticalDragUpdate` — 与屏幕接触的点在垂直方向上进一步移动。
  * `onVerticalDragEnd` — 先前与屏幕接触并垂直移动的点不再与屏幕接触，并且在停止接触屏幕时以特定速度移动。

* 水平拖动

  * `onHorizontalDragStart` — 触摸点已经与屏幕接触并可能开始水平移动。
  * `onHorizontalDragUpdate` — 与屏幕接触的点已经沿水平方向进一步移动。
  * `onHorizontalDragEnd` — 先前与屏幕接触并水平移动的点不再与屏幕接触。

以下示例显示了一个 `GestureDetector` ，双击上旋转 Flutter logo :

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

# 主题和文字

## 如何为应用程序设置主题？

开箱即用，Flutter 带有一个美丽的 Material Design 实现，它可以处理您通常需要处理的大量样式和主题需求。

要充分利用应用程序中的 Material 组件，请声明一个顶级 widget &mdash; MaterialApp 作为应用程序的入口点。 MaterialApp 是一个方便的 widget ，它包装了许多实现 Material Design 的应用程序通常需要的 widget 。它通过添加 Material 特定功能构建在 WidgetsApp 上。

但是，Flutter 具有足够的灵活性和表现力，可以实现任何设计语言。在 iOS 上，您可以使用 [Cupertino 库](https://docs.flutter.io/flutter/cupertino/cupertino-library.html)生成符合[人机界面指南](https://developer.apple.com/ios/human-interface-guidelines/overview/themes/)的界面。有关这些 widget 的完整集合，请参阅 [Cupertino 小部件库](/widgets/cupertino/)。

您还可以使用 `WidgetApp` 作为您的应用 widget，它提供了一些相同的功能，但不像 `MaterialApp` 那么丰富。

要自定义任何子组件的颜色和样式，请将 `ThemeData` 对象传递给 `MaterialApp` widget。例如，在下面的代码中，主色板设置为蓝色，文本选择颜色为红色。

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

## 如何为 `Text` 设置自定义字体？

在 iOS 中，您可以将任何 ttf 字体文件导入到项目中，并在 `info.plist` 文件中创建一个引用。在 Flutter 中，将字体文件放在一个文件夹中，并将其引用到 `pubspec.yaml` 文件中，这与导入图片的方式类似。

<!-- skip -->
{% prettify yaml %}
fonts:
   - family: MyCustomFont
     fonts:
       - asset: fonts/MyCustomFont.ttf
       - style: italic
{% endprettify %}

然后将字体赋值给你的 `Text` ：

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

## 如何设计 `Text` ？

与字体一起，您可以在 `Text` 上自定义其他样式元素。 `Text` 的样式参数需要一个 `TextStyle` 对象，您可以在其中自定义许多参数，例如：

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

# 表单输入

## 表格如何在 Flutter 中工作？如何检索用户输入？

鉴于 Flutter 如何在不同的状态下使用不可变的 widget ，您可能想知道用户输入如何适应图片。在 iOS 上，当您需要提交用户输入或对其进行操作时，您通常会查询窗口widget 的当前值。这在 Flutter 中如何工作？

在实践中，表格是通过专门的 widget 处理的，如 Flutter 中的所有内容。如果您有 `TextField` 或 `TextFormField` ，则可以提供 [`TextEditingController`](https://docs.flutter.io/flutter/widgets/TextEditingController-class.html) 来检索用户输入：

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

您可以从 [Flutter Cookbook](https://flutter.io/cookbook/) 中找到更多信息和[检索文本字段的值](/cookbook/forms/retrieve-input/)中的完整代码列表。 

## iOS 中文本框的占位符在 Flutter 中对应什么？

在 Flutter 中，您可以通过向 `Text` 小部件的装饰构造函数参数添加一个 `InputDecoration` 对象，轻松地为您的字段显示“提示”或占位符文本：

<!-- skip -->
{% prettify dart %}
body: new Center(
  child: new TextField(
    decoration: new InputDecoration(hintText: "This is a hint"),
  ),
)
{% endprettify %}

## 如何显示验证错误？

就像使用“提示”一样，将一个 `InputDecoration` 对象传递给 `Text` 文本的装饰构造函数。

但是，您不想通过显示错误开始。相反，当用户输入无效数据时，更新状态并传递一个新的 `InputDecoration` 对象。

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

Flutter 不直接在底层平台上运行代码;相反，构成 Flutter 应用程序的 Dart 代码在设备上本地运行，“避开”平台提供的SDK。这意味着，假如，当您在 Dart 中执行网络请求时，它将直接在 Dart 上下文中运行。在编写本机应用程序时，您不会使用通常使用的 Android 或 iOS  API 。您的 Flutter 应用程序仍作为视图托管在本机应用程序的 `ViewController` 中，但您无法直接访问 `ViewController` 本身或本机框架。

这并不意味着 Flutter 应用程序无法与这些本地 API 或任何本地代码进行交互。 Flutter 提供[平台通道](/platform-channels/)，与承载 Flutter 视图的 `ViewController` 进行通信和交换数据。平台通道本质上是一个异步消息传递机制，它将 Dart 代码与主机 `ViewController` 及其运行的 iOS 框架桥接在一起。例如，您可以使用平台通道在本机端执行方法，或从设备的传感器检索一些数据。


除了直接使用平台频道之外，您还可以使用各种预制的[插件](/using-packages/)封装原生和 Dart 代码以实现特定目标。例如，您可以使用插件直接从 Flutter 访问相机相册和设备相机，而无需编写自己的集成。 Plugins 可以在 Dart 和 Flutter 的开源软件包存储库( [Pub](https://pub.dartlang.org/) )中找到。某些软件包可能支持 iOS 或 Android 或两者的本机集成。

如果您无法在 Pub 上找到适合您需求的插件，您可以[编写自己的插件](/developing-packages/)并将其[发布到 Pub 上](/developing-packages/#publish)。

## 如何使用 GPS 传感器？

使用 [`location`](https://pub.dartlang.org/packages/location) 社区插件。

## 如何使用相机服务?

[`image_picker`](https://pub.dartlang.org/packages/image_picker) 插件是访问摄像机的热门选择。

## 如何使用 Facebook 进行登录?

要使用 Facebook 登录，请使用 [`flutter_facebook_login`](https://pub.dartlang.org/packages/flutter_facebook_login)  社区插件。

## 如何使用Firebase功能？

大多数 Firebase 功能都由[第一方插件](https://pub.dartlang.org/flutter/packages?q=firebase)覆盖。这些插件是由 Flutter 团队维护的第一方集成：

 * Firebase AdMob [`firebase_admob`](https://pub.dartlang.org/packages/firebase_admob) 
 * Firebase Analytics [`firebase_analytics`](https://pub.dartlang.org/packages/firebase_analytics)
 * Firebase Auth [`firebase_auth`](https://pub.dartlang.org/packages/firebase_auth)
 * Firebase Core [`firebase_core`](https://pub.dartlang.org/packages/firebase_core) 
 * Firebase RTDB [`firebase_database`](https://pub.dartlang.org/packages/firebase_database)
 * Firebase Cloud Storage [`firebase_storage`](https://pub.dartlang.org/packages/firebase_storage)
 * Firebase Messaging (FCM) [`firebase_messaging`](https://pub.dartlang.org/packages/firebase_messaging)
 * Firebase Cloud Firestore [`cloud_firestore`](https://pub.dartlang.org/packages/cloud_firestore)

您还可以在 Pub 上找到一些第三方 Firebase 插件，这些插件涵盖了第一方插件未覆盖的区域。

## 如何构建自己的定制本地集成？

如果 Flutter 或其社区插件缺失的平台特定功能，您可以根据[开发包和插件](/developing-packages/)页面构建自己的功能。

简而言之，Flutter 的插件架构就像在 Android 中使用 Event bus 一样：您触发一条消息并让接收者进行处理并将结果发回给您。在这种情况下，接收者是在 Android 或 iOS 上运行在本机端的代码。

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
