---
layout: page
title: 使用热重载
permalink: /hot-reload/
---

* TOC
{:toc}

## 使用热重载

Flutter的热重载特性可以帮你方便快捷地尝试和构建用户界面，添加特性，修复bug。  热重载通过将更新后的源码注入到运行中的Dart虚拟机（VM）的方式工作。在虚拟机更新了拥有新版字段或函数的类后，Flutter框架会自动重建控件树，这样你就可以快速地看到改动产生的影响。

去热重载一个Flutter应用：

1.  通过受支持的Intellij IDE或命令行窗口运行应用，目标设备可以是真机也可以是虚拟机。
1.  修改工程中的某个Dart文件。热重载支持多数类型的源码改动，还有一些改动需要重启才能生效，详情查看[Limitations](#limitations).
1.  如果你在使用支持Flutter IDE工具的Intellij工作，
选择**Save All** (`cmd-s`/`ctrl-s`), 或者点击工具栏上的热重载按钮：

   ![alt_text](../images/intellij/hot-reload.gif "image_tooltip")

   如果使用`flutter run`通过命令行运行应用，则在命令行窗口输入`r` 。

热重载成功后，会在控制台看到类似下面信息：

```
Performing hot reload...
Reloaded 1 of 448 libraries in 2,777ms.
```
应用更新反映出你的改动，并且当前状态—上面例子中的计数器变量的值—已经被保存。你的应用在运行热重载命令之前的位置继续执行。

代码变化只有Dart源码在改动后重新运行才会有可见的影响，下一节描述了热重载后改动的代码不会再次运行的常见场景。在某些情况下，对Dart代码的微小更改将使您能够继续使用热重载。

## 编译错误

当代码更改引入编译错误时，热重载总是会生成类似如下的错误消息:

```
Hot reload was rejected:
'/Users/obiwan/Library/Developer/CoreSimulator/Devices/AC94F0FF-16F7-46C8-B4BF-218B73C547AC/data/Containers/Data/Application/4F72B076-42AD-44A4-A7CF-57D9F93E895E/tmp/ios_testWIDYdS/ios_test/lib/main.dart': warning: line 16 pos 38: unbalanced '{' opens here
  Widget build(BuildContext context) {
                                     ^
'/Users/obiwan/Library/Developer/CoreSimulator/Devices/AC94F0FF-16F7-46C8-B4BF-218B73C547AC/data/Containers/Data/Application/4F72B076-42AD-44A4-A7CF-57D9F93E895E/tmp/ios_testWIDYdS/ios_test/lib/main.dart': error: line 33 pos 5: unbalanced ')'
    );
    ^
```
在这种情况下，纠正指定行上的错误以继续使用热重载。

## 前状态与新代码相结合。

Flutter的热重载特性，有时描述为有状态热重载，即保存应用的状态。 这个设计可以让你在不丢失状态的情况下查看代码改动的影响。 例如，如果你的应用需要用户登录，你可以在导航层次结构中，修改和热重载页面的几个级别，无需重新输入登录凭据，状态已被保存，这通常是需要的行为。 

如果代码改动影响应用的状态（或者它的依赖）， 您的应用程序需要处理的数据可能与它从头开始执行的数据不完全一致。 热重载和重启结果可能产生不同的行为。

例如，如果您修改了一个类定义，从继承StatelessWidget改为StatefulWidget (或反向)，在热重加载后，您的应用程序的前一个状态会被保留。但是，该状态可能不兼容新的变化。

考虑如下代码：

```
class myWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return new GestureDetector(onTap: () => print('T'));
  }
}
```
运行应用后，如果你做出如下改动：

```
class myWidget extends StatefulWidget {
  @override
  State createState() => new myWidgetState();
}
class myWidgetState {
...
...
}
```

然后热重载，控制台显示一个断言失败，类似于: 

```
myWidget is not a subtype of StatelessWidget
```

在这些情况下，需要重新启动来查看更新后的应用程序。 


##包含最近的代码更改，但不包含应用状态。

Dart中， [静态字段是懒加载的](https://news.dartlang.org/2012/02/static-variables-no-longer-have-to-be.html). 这意味着，当您第一次运行Flutter应用程序并读取静态字段时，它将被赋值为初始化器设定的值。全局变量和静态字段被视为状态，因此在重加在时不会重新初始化。

如果你改动了全局变量和静态字段的初始化器，需要重新启动才能看到结果。例如，考虑如下代码：

```
final sampleTable = [
  new Table("T1"),
  new Table("T2"),
  new Table("T3"),
  new Table("T4"),
];
```
运行应用后，做如下修改：
```
final sampleTable = [
  new Table("T1"),
  new Table("T2"),
  new Table("T3"),
  new Table("T10"),    //modified
];
``` 
然后重加载，改动没有体现出来。
相反的，在下面的例子中：
```
const foo = 1;
final bar = foo;
void onClick(){
  print(foo);
  print(bar);
}
```
首次运行应用打印`1`和`1`。然后，如果你做出如下改变：
```
const foo = 2;    //modified
final bar = foo;
void onClick(){
  print(foo);
  print(bar);
}
```
热重载，现在打印`2`和`1`。对`const`修饰字段的改动总会被热重载，但静态字段初始器则不会重新运行。
概念上，“const”字段被当作别名而不是状态。

当一组更改需要完全重新启动才生效时，Dart VM会检测初始化器更改和标志。在上面的示例中，大多数初始化工作都触发了标记机制，但不适用于以下情况:

```
final bar = foo;
```

To be able to update `foo` and view the change after hot reload, consider
redefining the field as `const` or using a getter to return the value, rather
than using `final`. For example:

```
const bar = foo;
```
or:

```
get bar => foo;
```

Read more about the [differences between the `const` and `final` keywords](https://news.dartlang.org/2012/06/const-static-final-oh-my.html) in Dart. 

## Recent UI change is excluded

Even when a hot reload operation appears successful and generates no exceptions,
some code changes might not be visible in the refreshed UI. This behavior is
common after changes to the app's `main()` method.

As a general rule, if the modified code is downstream of the root widget's
build method, then hot reload behaves as expected. However, if the modified code
won't be re-executed as a result of rebuilding the widget tree, then you won't
see its effects after hot reload.

For example, consider the following code:
```
import 'package:flutter/material.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  Widget build(BuildContext context) {
    return new GestureDetector(
      onTap: () => print('tapped'));
  }
}
```

After running this app, you might change the code as follows:

```
import 'package:flutter/widgets.dart';
void main() {
  runApp(
    const Center(
      child: const Text('Hello', textDirection: TextDirection.ltr)));
  }
```


With a full restart, the program starts from the beginning, executes the new
version of `main()`, and builds a widget tree that displays the text `Hello`.

However, if you hot reload the app after this change, `main()` is not 
re-executed, and the widget tree is rebuilt with the unchanged instance of 
`MyApp` as the root widget. The result is no visible change after hot reload.

## Limitations

You might also encounter the rare cases where hot reload is not supported
at all. These include:

*  Enumerated types are changed to regular classes or regular classes are
changed to enumerated types. For example, if you change:

    ```
    enum Color {
      red,
      green,
      blue
    }

    ```
to:

   ```
    class Color {
      Color(this.i, this.j);
      final Int i;
      final Int j;
    	}
   ```

*   Generic type declarations are modified. For example, if you change:
    ```
    class A<T> {
      T i;
    }
    ```
	to:

    ```
    class A<T, V> {
      T i;
      V v;
    }
    ```

In these situations, hot reload generates a diagnostic message and fails without
committing any changes.
