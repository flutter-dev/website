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

Flutter's hot reload feature, sometimes described as _stateful hot reload_,
preserves the state of your app. This design enables you to view
the effect of the most recent change only, without throwing away the
current state. For example, if your app requires a user to log in, you can
modify and hot reload a page several levels down in the navigation hierarchy,
without re-entering your login credentials. State is kept, which is 
usually the desired behavior.

If code changes affect the state of your app (or its dependencies), 
the data your app has to work with might not be fully consistent with 
the data it would have if it executed from scratch. The result might be 
different behavior after hot reload versus a full restart.

For example, if you modify a class definition from extending StatelessWidget
to StatefulWidget (or the reverse), after hot reload the previous state of
your app is preserved. However, the state might not be compatible with the
new changes.

Consider the following code:

```
class myWidget extends StatelessWidget {
  Widget build(BuildContext context) {
    return new GestureDetector(onTap: () => print('T'));
  }
}
```
After running the app, if you make the following change:

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

and then hot reload, the console displays an assertion failure similar to:

```
myWidget is not a subtype of StatelessWidget
```

In these situations, a full restart is needed to see the updated app.

## Recent code change is included but app state is excluded

In Dart, [static fields are lazily initialized](https://news.dartlang.org/2012/02/static-variables-no-longer-have-to-be.html). This means that the first time you run a Flutter app and a static
field is read, it is set to whatever value its initializer was evaluated to.
Global variables and static fields are treated as state, and thus not 
reinitialized during hot reload.

If you change initializers of global variables and static fields, a full 
restart is necessary to see the changes. For example, consider the
following code:

```
final sampleTable = [
  new Table("T1"),
  new Table("T2"),
  new Table("T3"),
  new Table("T4"),
];
```
After running the app, if you make the following change:
```
final sampleTable = [
  new Table("T1"),
  new Table("T2"),
  new Table("T3"),
  new Table("T10"),    //modified
];
```
and then hot reload, the change is not reflected. 

Conversely, in the following example:
```
const foo = 1;
final bar = foo;
void onClick(){
  print(foo);
  print(bar);
}
```
running the app for the first time prints `1` and `1`. Then if you make the
following change: 

```
const foo = 2;    //modified
final bar = foo;
void onClick(){
  print(foo);
  print(bar);
}
```
and hot reload, it now prints `2` and `1`. While changes to `const` field values
are always hot reloaded, the static field initializer is not rerun.
Conceptually, `const` fields are treated like aliases instead of state.

The Dart VM detects initializer changes and flags when a set of changes needs a
full restart to take effect. The flagging mechanism is triggered for most of the
initialization work in the above example, but not for cases like:

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
