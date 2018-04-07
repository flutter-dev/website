---
layout: page
title: JSON 和序列化
permalink: /json/
---

很难想象一个移动应用不需要和 web 服务器通信或者在某些时候很简单的存储结构化的数据。当开发基于网络的应用时，我们需要生成又老有好用的 JSON。

在这篇课程中，我们窥探一些在 Flutter 中使用 JSON的方法。我们检查一些在不同场景下使用 JSON 的方案以及为什么要这么做。

* TOC Placeholder
{:toc}

## 哪一种 JSON 的序列化方法适合我？

本文覆盖到了两种常见的使用 JSON 的策略：

* 手动序列化和反序列化
* 通过代码生成自动序列化和反序列化

不同的项目伴随着不同的复杂度和使用场景。对于比较小的验证性项目或者快速原型，使用代码生成可能更有效果。对于有更多 JSON 模型和更复杂的应用，手动序列化很快就变得乏味无趣，重复性劳动并且会产生很多小错误。

### 小项目使用手动序列化

手动序列化参考使用在 `dart:convert` 中的内置解码器。包括传入 JSON 原始字符串 给 `JSON.decode()` 方法，然后从 `Map<String, dynamic>` 中查询你需要的数据。没有额外的依赖和特别的设置过程，它可以很方便的快速验证想法。

当你的项目变得越来越大时，手动序列化变得不那么好用。手动编写序列化逻辑会变得更难管理并且容易出错。如果你编写了错误的代码而访问了一个不存在的 JSON 字段，代码会在运行时抛出错误。

如果在你项目中的 JSON 模型不是很多并且期望快速验证想法，手动序列化会是你想要开始使用的方法。关于手动序列化的例子，[参阅这里](#manual-serialization).

### 在中大型项目中使用代码生成 

使用代码生成来序列化 JSON 意味着需要额外的库来为你生成序列化样板文件。包括一些初始化设置和运行一个文件监控器来为你的模型类生成代码。例如，[json_serializable](https://pub.dartlang.org/packages/json_serializable) 和
[built_value](https://pub.dartlang.org/packages/built_value) 就是这一类的库。

这个方法很好的适应大型项目。不需要手写样板文件，并且访问 JSON 字段的编码错误会在编译时被捕获。负面影响就是代码生成包含了一些初始化的设置。而且，生成的源码文件也许在项目导航器中生成杂乱的可见的。

当你拥有一个中大型项目时，也许你想对 JSON 序列化使用代码生成。参考基于代码生成的 JSON 序列化的列子，[参阅这里](#code-generation).

## 在 Flutter 中是否有等价与 GSON/Jackson/Moshi 的库?

答案是没有。

这些库需要用到运行时的反射机制，而这在 Flutter 中是被禁用的。运行时反射干涉了 _tree shaking_，这是 Dart 已经支持了很长时间的东西。通过 tree shaking，我们可以在发布时“摆脱”一些无用的代码。这对于我们优化应用的大小有了重大意义。

自从反射默认隐式调用所有代码，这让 tree
shaking 变得困难。工具无法知道哪些部分在运行时未使用，以至于多余的代码很难被清理掉。在使用反射时应用大小不容易被优化。

<aside class="alert alert-info" markdown="1">
**dartson 怎么样?**

[dartson](https://pub.dartlang.org/packages/dartson) 使用了运行时反射，对于 Flutter 来说不适用。
</aside>

虽然我们不能配合 Flutter 使用运行时反射，取而代之，一些库给我们提供了基于代码生成的类似的使用简单的接口。关于这个方法更多的细节在 [code generation
libraries](#code-generation)。

<a name="manual-serialization"></a>
## 使用 dart:convert 手动序列化 JSON

在 Flutter 中基本的 JSON 序列化非常简单。Flutter 拥有内置的`dart:convert` 库，包含了直白的 JSON 编码器和解码器。

这是一个用户模型的 JSON 例子。

```json
{
  "name": "John Smith",
  "email": "john@example.com"
}
```

通过 `dart:convert`，我们可以使用两种方法序列化这个 JSON 模型。让我们都看一下。

### 内联序列化 JSON

从文档 [the dart:convert JSON
documentation](https://api.dartlang.org/stable/1.24.3/dart-convert/JsonCodec-class.html)
可以看出，我们可以把 JSON 字符串作为参数，通过调用方法 `JSON.decode` 可以解码 JSON。

<!-- skip -->
```dart
Map<String, dynamic> user = JSON.decode(json);

print('Howdy, ${user['name']}!');
print('We sent the verification link to ${user['email']}.');
```

不幸的是，`JSON.decode()` 仅仅返回一个 `Map<String, dynamic>`，意味着我们直到运行时才能知道值的类型。使用这个方法，我们丢失了很多静态类型语言的特性：类型安全，自动补齐和最重要的，编译时异常。我们的代码会马上变得容易出错。

例如，任何当我们访问 `name` 或者 `email` 字段的时候，我们都可能会引入一个编码错误。而这个编码错误是编译器所不知道的，因为整个 JSON 仅仅存在于一个字典的结构里面。

### 在模型类内部序列化 JSON

我们实际运用一下我们之前提到的问题通过引入一个叫做 `User` 的普通的模型类，我们拥有：

* 一个 `User.fromJson` 构造器，用于从一个字典 数据结构构造一个新的 `User` 实例。
* 一个 `toJson` 方法，用于将 `User` 的实例转化成一个字典。

这个方法，_calling code_ 拥有类型安全，为 `name` and `email` 字段自动补全和编译时异常。 如果我们编码错误或者把当成来处理，应用不是在运行时崩溃，甚至都不能成功编译。

**user.dart**

<!-- skip -->
```dart
class User {
  final String name;
  final String email;

  User(this.name, this.email);

  User.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        email = json['email'];

  Map<String, dynamic> toJson() =>
    {
      'name': name,
      'email': email,
    };
}
```

现在序列化的逻辑被移到了 model 里面，通过这个方法，我们能非常简单地反序列化 user。

<!-- skip -->
```dart
Map userMap = JSON.decode(json);
var user = new User.fromJson(userMap);

print('Howdy, ${user.name}!');
print('We sent the verification link to ${user.email}.');
```

要序列化 user，我们只需要将 `User` 对象传入 `JSON.encode` 方法。在这儿我们不需要调用 `toJson` 方法，因为 `JSON.encode` 已经为我们做了。

<!-- skip -->
```dart
String json = JSON.encode(user);
```


这样，调用代码就不用担心JSON序列化了。然而，模型类仍然需要。在应用的生产应用中，我们希望确保序列化工作正常。在实际应用中，`User.fromJson` 和 `User.toJson` 方法都需要适当的单元测试来验证正确的行为。

而且，现实世界的场景通常不是那么简单。我们不大可能获取如此小的 JSON 响应对象。嵌套的JSON对象很常见。

如果有什么东西可以为我们处理好 JSON 序列化就太好了。幸运的是，确实有！

<a name="code-generation"></a>
## 使用 JSON 序列化代码生成库

虽然还有一些其他的库可用，但是在本教程中，我们使用 [json_serializable package](https://pub.dartlang.org/packages/json_serializable)。这是一个自动化的源代码生成器，可以生成 JSON 序列化样板。

由于序列化代码不再由我们手写和维护，所以我们尽量减少了JSON序列化在运行时发生异常的风险。

### 在项目中设置 json_serializable

To include `json_serializable` in our project, we need one regular and two _dev
dependencies_. In short, _dev dependencies_ are dependencies that are not
included in our app source code.

The latest versions of these required dependencies can be seen by following
[this link](https://github.com/dart-lang/json_serializable/blob/master/example/pubspec.yaml).

**pubspec.yaml**

```yaml
dependencies:
  # Your other regular dependencies here
  json_annotation: ^0.2.2

dev_dependencies:
  # Your other dev_dependencies here
  build_runner: ^0.7.6
  json_serializable: ^0.3.2
```

Run `flutter packages get` inside your project root folder (or click "Packages
Get" in your editor) to make these new dependencies available in your project.

### Creating model classes the json_serializable way

Let's see how to convert our `User` class to a `json_serializable` one. For the
sake of simplicity, we use the dumbed-down JSON model from the previous samples.

**user.dart**

<!-- skip -->
{% prettify dart %} 
import 'package:json_annotation/json_annotation.dart';

/// This allows our `User` class to access private members in 
/// the generated file. The value for this is *.g.dart, where 
/// the star denotes the source file name.
part '[[highlight]]user[[/highlight]].g.dart';

/// An annotation for the code generator to know that this class needs the 
/// JSON serialization logic to be generated.
[[highlight]]@JsonSerializable()[[/highlight]]

/// Every json_serializable class must have the serializer mixin. 
/// It makes the generated toJson() method to be usable for the class. 
/// The mixin's name follows the source class, in this case, User.
class User extends Object with _$[[highlight]]User[[/highlight]]SerializerMixin {
  User(this.name, this.email);

  String name;
  String email;

  /// A necessary factory constructor for creating a new User instance
  /// from a map. We pass the map to the generated _$UserFromJson constructor. 
  /// The constructor is named after the source class, in this case User.
  factory User.fromJson(Map<String, dynamic> json) => _$[[highlight]]User[[/highlight]]FromJson(json);
}
{% endprettify %}

With this setup, the source code generator will generate code for serializing
the `name` and `email` fields from JSON and back.

If needed, it is also easy to customize the naming strategy. For example, if the
API we are working with returns objects with _snake\_case_, and we want to use
_lowerCamelCase_ in our models, we can use the `@JsonKey` annotation with a name
parameter:

<!-- skip -->
```dart
/// Tell json_serializable that "registration_date_millis" should be
/// mapped to this property.
@JsonKey(name: 'registration_date_millis')
final int registrationDateMillis;
```

### Running the code generation utility

When creating `json_serializable` classes the first time, you will get errors
similar to the image below.

![IDE warning when the generated code for a model class does not exist
yet.](/images/json/ide_warning.png)

These errors are entirely normal and are simply because the generated code for
the model class does not exist yet. To resolve this, we must run the code
generator that generates the serialization boilerplate for us.

There are two ways of running the code generator.

#### One-time code generation

By running `flutter packages pub run build_runner build` in our project root, we
can generate json serialization code for our models whenever needed. This
triggers a one-time build which goes through our source files, picks the
relevant ones and generates the necessary serialization code for them.

While this is pretty convenient, it would nice if we did not have to run the
build manually every time we make changes in our model classes.

#### Generating code continuously

A _watcher_ can make our source code generation process more convenient. It
watches changes in our project files and automatically builds the necessary
files when needed. We can start the watcher by running `flutter packages pub run
build_runner watch` in our project root.

It is safe to start the watcher once and leave it running in the background.

### Consuming json_serializable models

To deserialize a JSON string `json_serializable` way, we do not have actually to
make any changes to our previous code.

<!-- skip -->
```dart
Map userMap = JSON.decode(json);
var user = new User.fromJson(userMap);
```

Same goes for serialization. The calling API is the same as before.

<!-- skip -->
```dart
String json = JSON.encode(user);
```

With `json_serializable`, we can forget any manual JSON serialization in the
`User` class. The source code generator creates a file called `user.g.dart`,
which has all the necessary serialization logic. Now we do not necessarily have
to write automated tests to be sure that the serialization works - it is now
_the library's responsibility_ to make sure the serialization works
appropriately.

## Further references

* [JsonCodec documentation](https://api.dartlang.org/stable/1.24.3/dart-convert/JsonCodec-class.html)
* [The json_serializable package in Pub](https://pub.dartlang.org/packages/json_serializable)
* [json_serializable examples in GitHub](https://github.com/dart-lang/json_serializable/blob/master/example/lib/example.dart)
* [Discussion about dart:mirrors in Flutter](https://github.com/flutter/flutter/issues/1150)
