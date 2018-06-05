---
title: Flutter 技术概览
layout: page
permalink: /technical-overview/
---

## 什么是 Flutter ？

Flutter 是一款移动应用程序 SDK，致力于使用一套代码来构建高性能、高保真的 iOS 和 Android 应用程序。

Flutter 的目标是使开发者们能够交付在不同平台上都感觉自然流畅的高性能应用程序，并且在滚动行为、排版、图标等方面兼容差异。

<object type="image/svg+xml" data="/images/whatisflutter/hero-shrine.svg" style="width: 100%; height: 100%;"></object>

这是一个来自 [Gallery](https://github.com/flutter/flutter/tree/master/examples/flutter_gallery/lib/demo) 的演示程序，你可以在安装并设置 Flutter 环境之后运行 Flutter 简单的集合示例程序。Shrine 示例拥有高质量的图片滚动、交互式卡片、按钮、下拉列表和一个购物车页面。要查看这个和更多示例代码，请访问我们的 [GitHub](https://github.com/flutter/flutter/tree/master/examples)。

无需手机开发经验即可开始。应用程序采用 [Dart](https://dartlang.org/) 编写，如果你使用过 Java 或 JavaScript 语言的话看起来就非常熟悉。使用面向对象语言的经验绝对是有帮助的，即便非程序员也可以编写 Flutter 应用程序。

## 为什么使用 Flutter ？

Flutter 有哪些优势？它可以帮助你：

*   提高开发效率
    *    一套代码开发 iOS 和 Android
    *   用更少的代码即使在单个操作系统上用更现代的表达性语言和声明性方法来做更多的事情
    *   原型和迭代容易
        *   尝试在应用程序运行时修改代码并重载（使用热重载）
        *   修复崩溃并在应用程序停止的地方重新调试
*   创建美观，高度定制的用户体验
    *   受益于使用 Flutter 自己的框架构建的丰富的 Material Design 和 Cupertino （iOS 风格）Widget
    *   实现定制，美观，品牌驱动的设计，而不受 OEM Widget 集的限制

## 核心原则

Flutter 包含了一个现代的响应式框架，一个 2D 渲染引擎，现成的 Widget ，和开发工具。这些组件携手帮助你设计，构建，测试和调试应用程序。一切都围绕几个核心原则来组织的。

### 万物皆 Widget

Widget 是 Flutter 应用程序用户界面的基础构建模块。每个 Widget 都是用户界面的不可变声明的一部分。与其他将视图，试图控制器，布局和其他属性分开的框架不同，Flutter 具有一致的统一对象模型：Widget。

Widget 可定义为:

*   一个结构元素（比如按钮或菜单）
*   一个格式元素（比如字体或颜色方案）
*   布局的一个方面（比如填充）
*   等等...

Widget 基于构图形成一个层级结构。每个 Widget 嵌入其中，并继承父类属性。没有单独的“应用程序”对象。相反，根 Widget 扮演着这个角色。

你可以通过告诉框架使用另一个 Widget 去替换层级结构中的某个 Widget 来响应事件，例如用户交互。该框架然后比较新的和旧的 Widget，并且有效的更新用户界面。

#### 组合 > 继承

Widget 本身通常由许多小型的单一用途的 Widget 组成，这些 Widget 结合起来产生强大的效果。例如，[Container](https://github.com/flutter/flutter/blob/master/packages/flutter/lib/src/widgets/container.dart) 是一个常用的 Widget，由多个 Widget 组成，这些 Widget 负责布局、绘图、定位和大小调整。具体来说，Container 由 [LimitedBox](https://docs.flutter.io/flutter/widgets/LimitedBox-class.html) 、 
[ConstrainedBox](https://docs.flutter.io/flutter/widgets/ConstrainedBox-class.html) 、 
[Align](https://docs.flutter.io/flutter/widgets/Align-class.html) 、 
[Padding](https://docs.flutter.io/flutter/widgets/Padding-class.html) 、 
[DecoratedBox](https://docs.flutter.io/flutter/widgets/DecoratedBox-class.html) 、 
和 [Transform](https://docs.flutter.io/flutter/widgets/Transform-class.html) 这些 Widget 组成。你可以以新奇的方式来组合这些和其他简单的 Widget，而不是继承 Container 来产生自定义的效果。

浅而宽的类层次结构可以最大限度的增加可能的组合数量。

<object type="image/svg+xml" data="/images/whatisflutter/diagram-widgetclass.svg" style="width: 100%; height: 100%;"></object>

你也可以通过其他 Widget 组合来控制某个 Widget 的布局。例如，想要使 Widget 居中，你可以将其封装在 Center Widget 中。有填充、对齐、行、列和网格的 Widget ，这些布局 Widget 自身没有可视化表示，相反，他们唯一的目的就是去控制另一个 Widget 布局的某些方面。要去理解为什么一个 Widget 以某种方式呈现，检查相邻的 Widget 通常很有帮助。

#### 分层框架

Flutter 框架被组织为多层结构，每个层都建立在前一层之上。

<object type="image/svg+xml" data="/images/whatisflutter/diagram-layercake.svg" style="width: 85%; height: 85%"></object>

该图解展示了 Flutter 框架的上层，它比下层使用更加频繁。关于构成 Flutter 分层框架的完整库集，请查看我们的 [API 文档](https://docs.flutter.io)。

这样设计的目的是为了帮助你使用更少的代码完成更多的事情。举个例子， Material 层由 Widget 层中的一些基础的 widget 组合而成，而 Widget 层本身是通过协调 Rendering 层中的低级对象来构建的。

层结构为你构建应用程序提供了很多选项。选择一种自定义的方法来释放框架的全部表现力，或者使用构件层中的构建块，或混合搭配。 您可以实现 Flutter 提供的所有现成的 widget，或者使用 Flutter 团队用于构建框架的相同工具和技术创建您自己的定制 widget。

没有什么是隐藏的。您可以从高层次、统一的 widget 概念中获得生产力优势，同时不会牺牲深入到底层的能力。

### 构建 widget

你可以通过实现 Widget 的 [build](https://docs.flutter.io/flutter/widgets/StatelessWidget/build.html) 方法来定义 widget 的独特特征，该方法会返回一个 widget 树（或层级）。该树更具体的表现了用户界面的 widget 层级。例如，一个工具栏 widget 的 build 方法将返回一些[文本](https://docs.flutter.io/flutter/widgets/Text-class.html)和[各种](https://docs.flutter.io/flutter/material/IconButton-class.html) [按钮](https://docs.flutter.io/flutter/material/PopupMenuButton-class.html)的[水平布局](https://docs.flutter.io/flutter/widgets/Row-class.html)。然后，框架递归地要求这些 widget 来构建，直到该过程落在完全具体的 widget 中，然后该框架一起缝合到树中。

widget 的 build 方法应该没有副作用。每当它被要求构建时，widget 应该返回一个新的 widget 树，无论 widget 以前返回的是什么。该框架大大提升了比较先前的 build 与当前 build 方法并确定需要对用户界面进行哪些修改。

这种自动比较非常有效，可实现高性能，互动应用。构建函数的设计将重点放在声明小部件的组成，而不是将用户界面从一种状态更新到另一种状态，从而简化了代码。

### 处理用户交互


如果一个 widget 的独特特性需要根据用户进行更改交互或其他因素，那么该 widget 是*有状态的*。例如，如果一个 widget 的计数器在用户点击一个按钮时递增，那么该计数器的值就是该 widget 的状态。当该值发生变化时，需要重新构建小部件以更新 UI 。

这些 widget 将 [StatefulWidget](https://docs.flutter.io/flutter/widgets/StatefulWidget-class.html)（而不是 [StatelessWidget](https://docs.flutter.io/flutter/widgets/StatelessWidget-class.html) ）子类化并将它们的可变状态存储在 [State](https://docs.flutter.io/flutter/widgets/State-class.html) 的子类中。

<object type="image/svg+xml" data="/images/whatisflutter/diagram-state.svg" style="width: 85%; height: 85%"></object>

每当你改变一个 State 对象时（例如增加计数器），你必须调用 [setState](https://docs.flutter.io/flutter/widgets/State/setState.html)() 来通知框架通过再次调用 State 的构建方法来更新用户界面。有关管理 state 的示例，请参阅每个新 Flutter 项目创建的 [MyApp 模板](https://github.com/flutter/flutter/blob/master/packages/flutter_tools/templates/create/lib/main.dart.tmpl)。


具有独立的状态和 widget 对象可以让其他 widget 以相同的方式处理无状态和有状态widget，而不必担心丢失状态。父类不需要保存子类的状态，而是可以自由地创建子类的新实例，而不会丢失子类的持久状态。框架在适当的时候完成所有查找和重用现有状态对象的工作。

## 尝试一下!

现在你已经熟悉了 Flutter 框架的基本结构和原理，以及如何构建应用程序并使其交互，就可以开始开发和迭代了。

接下来:

1.  按照 [Flutter 入门指南](/get-started/)。
1.  尝试[在 Flutter 中构建布局](/tutorials/layout/)并[为你的 Flutter 应用添加交互性](/tutorials/interactive/)。
1.  按照浏览[窗口小部件框架](/widgets-intro/)中的详细示例。

## 获取支持

跟踪 Flutter 项目并以各种方式加入对话。我们是开源的，期望听到你的消息。

- [询问可以用特定解决方案回答的 HOWTO 问题][so] 
- [与 Flutter 工程师和用户进行实时聊天][gitter] 
- [在我们的邮件列表中讨论 Flutter ，最佳实践，应用程序设计等等][mailinglist]
- [报告错误，请求功能和文档][issues]
- [在 Twitter 上关注我们：@flutterio](https://twitter.com/flutterio/)


[issues]: https://github.com/flutter/flutter/issues
[apidocs]: https://docs.flutter.io
[so]: https://stackoverflow.com/tags/flutter
[mailinglist]: https://groups.google.com/d/forum/flutter-dev
[gitter]: https://gitter.im/flutter/flutter
