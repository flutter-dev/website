---
layout: tutorial
title: "国际化 Flutter 应用"

permalink: /tutorials/internationalization/
---

<div class="whats-the-point" markdown="1">

<b> <a id="whats-the-point" class="anchor" href="#whats-the-point" aria-hidden="true"><span class="octicon octicon-link"></span></a>你会学到:</b>

* 如何追踪设备的本地化（用户首选语言）。
* 如何管理基于地区特性的应用值。
* 如何定义本地化和应用支持。

</div>

如果你的应用可能被部署到会说另一种语言的用户那里你需要“国际化”它。这意味着您需要编写应用程序，使其能够为应用程序支持的每种语言或 “locale” 设置“本地化”值，比如文本和布局。Flutter 提供控件和类帮助实现国际化，Flutter 库本身也是支持国际化的。

接下来的教程主要根据 Flutter MaterialApp 类编写，因为大多数应用程序都是这样编写的。根据较低级别的WidgetsApp 类编写的应用程序也可以使用相同的类和逻辑进行国际化。

### Contents

* [设置一个国际化的应用程序: the flutter_localizations package](#setting-up)
* [跟踪区域设置:  Locale 类和 Localizations widget](#tracking-locale)
* [加载和获取本地化值](#loading-and-retrieving)
* [使用打包好的LocalizationsDelegates](#using-bundles)
* [为应用的本地化资源定义一个类](#defining-class)
* [指定应用的 supportedLocales 参数](#specifying-supportedlocales)
* [指定本地化资源的另一个类](#alternative-class)
* [附录：使用 Dart intl 工具](#dart-tools)

<aside class="alert alert-info" markdown="1">
**国际化 APP 例子**<br>

如果想通过阅读国际化 Flutter 程序的源码开始，这里是两个小例子。第一个旨在尽可能简单，第二个使用 [intl](https://pub.dartlang.org/packages/intl) 包提供的 API 和工具。 如果您没有使用过 Dart 的 intl 包，请参阅 [Using the Dart intl tools.](#dart-tools)

* [最小限度国际化](https://github.com/flutter/website/tree/master/_includes/code/internationalization/minimal/)
* [基于 `intl` 包国际化](https://github.com/flutter/website/tree/master/_includes/code/internationalization/intl/)
</aside>

<a name="setting-up"></a>
## 设置一个国际化的应用程序: the flutter_localizations package

默认情况下，Flutter 提供美式英语本地化。要添加对其他语言的支持，应用程序必须指定其他 MaterialApp 属性，并包含名为 `flutter_localizations` 的单独包。截止 2017 年 10 月，该软件包支持15种语言。

要使用 flutter_localizations，添加该包作为依赖项到您的 `pubspec.yaml` 文件:

{% prettify yaml %}
dependencies:
  flutter:
    sdk: flutter
  flutter_localizations:
    sdk: flutter
{% endprettify %}

然后，导入 flutter_localizations 库并为 MaterialApp 指定 `localizationsDelegates` 和 `supportedLocales` :

{% prettify dart %}
import 'package:flutter_localizations/flutter_localizations.dart';

new MaterialApp(
 localizationsDelegates: [
   // ... app-specific localization delegate[s] here
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

基于 WidgetsApp 的应用程序类似，只是不需 `GlobalMaterialLocalizations.delegate` 。

`localizationsDelegates` 列表中的元素是生成本地化值集合的工厂。`GlobalMaterialLocalizations.delegate` 为 Material Components 库提供本地化字符串和其他值。`GlobalWidgetsLocalizations.delegate` 为控件库定义了默认文本方向，从左到右或从右到左。

有关这些属性的更多信息，它们依赖的类型以及如何国际化 Flutter 应用，这些都可以在下面找到。

<a name="tracking-locale"></a>
## 跟踪区域设置:  Locale 类和 Localizations widget

[`Locale`](https://docs.flutter.io/flutter/dart-ui/Locale-class.html) 用来识别用户语言。移动设备支持为所有应用设置区域，通常通过系统设置按钮。 国际化程序通过显示特定区域的值进行响应。例如，如果用户将设备的语言环境从英语切换到法语，则显示 “Hello World" 的文本控件将会用  "Bonjour le monde" 重建。

[`Localizations`](https://docs.flutter.io/flutter/widgets/Localizations-class.html) 控件定义了其子项的本地化及子项依赖的本地化资源。[WidgetsApp](https://docs.flutter.io/flutter/widgets/WidgetsApp-class.html) 创建一个本地化控件并在系统区域变化后重建。

你总是可以通过 `Localizations.localeOf()`查询应用当前区域设置:

{% prettify dart %}
Locale myLocale = Localizations.localeOf(context);
{% endprettify %}

<a name="loading-and-retrieving"></a>
## 加载和获取本地化值

Localizations widget 用于加载和查找包含本地化值的集合的对象。应用程序通过   [`Localizations.of(context,type)`](https://docs.flutter.io/flutter/widgets/Localizations/of.html)来引用这些对象。
如果设备的区域设置发生更改， Localizations widget 会自动加载新区域设置的值，然后重新构建使用它们的控件。因为 Localizations 像 [InheritedWidget](https://docs.flutter.io/flutter/widgets/InheritedWidget-class.html) 一样工作。当构建函数引用了继承的控件时，会创建对继承的控件的隐式依赖关系。当继承的控件更改时（Localizations widget 的区域设置发生更改时），将重建其依赖的上下文。

本地化值由 Localizations widget 的 [LocalizationsDelegate](https://docs.flutter.io/flutter/widgets/LocalizationsDelegate-class.html)  列表加载.
每个委托必须定义一个异步 [`load()`](https://docs.flutter.io/flutter/widgets/LocalizationsDelegate/load.html) 方法，以生成封装了一系列本地化值的对象。通常这些对象为每个本地化值定义一个方法。

大型应用中，不同的模块或包可能跟它们自己的本地化绑定在一起。这是 Localizations widget 管理对象表的原因，每个 LocalizationsDelegate 有一个对象表。要重新获得由 LocalizationsDelegate 的 `load` 方法之一生成的对象，您需要指定一个  BuildContext 和对象类型。

例如，Material Components widgets 的本地化字符由 [MaterialLocalizations](https://docs.flutter.io/flutter/material/MaterialLocalizations-class.html)
 类定义。这个类的实例由  [MaterialApp](https://docs.flutter.io/flutter/material/MaterialApp-class.html) 类提供的 LocalizationDelegate 创建。它们可以通过 `Localizations.of` 获取到:

{% prettify dart %}
Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
{% endprettify %}

这个特殊的 `Localizations.of()` 表达式使用很频繁，所以 MaterialLocalizations 类提供了一个方便的简写:

{% prettify dart %}
static MaterialLocalizations of(BuildContext context) {
  return Localizations.of<MaterialLocalizations>(context, MaterialLocalizations);
}

/// References to the localized values defined by MaterialLocalizations
/// are typically written like this:

tooltip: MaterialLocalizations.of(context).backButtonTooltip,
{% endprettify %}

<a name="using-bundles">
## 使用打包好的LocalizationsDelegates

为了尽可能小而且简单，flutter 软件包中仅提供美式英语值的 MaterialLocalizations 和 WidgetsLocalizations 接口的实现。这些实现类分别称为 DefaultMaterialLocalizations 和 DefaultWidgetsLocalizations，他们会自动包含除非为应用程序的 `localizationsDelegates` 参数指定了相同基本类型的不同委托。

flutter_localizations 软件包包含 GlobalMaterialLocalizations 和 GlobalWidgetsLocalizations 的本地化接口的多语言实现。国际化的应用程序必须按照 [Setting up an internationalized app.](#setting-up) 为这些类指定本地化代理。

{% prettify dart %}
import 'package:flutter_localizations/flutter_localizations.dart';

new MaterialApp(
 localizationsDelegates: [
   // ... app-specific localization delegate[s] here
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

全局本地化代理构建相应类特定语言环境下的实例。例如，`GlobalMaterialLocalizations.delegate` 是一个生成 GlobalMaterialLocalizations 实例的本地化代理 。

截止 2017 年 10 月，国际化代理类支持[约15种语言](https://github.com/flutter/flutter/tree/master/packages/flutter_localizations/lib/src/l10n)

<a name="defining-class"></a>
## 为应用的本地化资源定义一个类

将所有这些放在一起用于国际化应用通常从封装应用程序本地化值的类开始。下面的例子是这些类的典型例子。

这个例子的[完整代码](https://github.com/flutter/website/tree/master/_includes/code/internationalization/intl/)。

这个例子基于 [intl](https://pub.dartlang.org/packages/intl) 软件包提供的 API 和 工具。 [应用本地化资源的另一个类](#alternative-class) 描述了一个不依赖 intl 的[示例](https://github.com/flutter/website/tree/master/_includes/code/internationalization/minimal)。

DemoLocalizations 类包含应用字符串 (仅用于示例)，该字符串被译为应用程序支持的语言环境。使用 Dart 的  [intl package](https://pub.dartlang.org/packages/intl) 生成的 `initializeMessages()` 函数加载翻译的字符串，使用 [`Intl.message()`](https://www.dartdocs.org/documentation/intl/0.15.1/intl/Intl/message.html) 来查找。

{% prettify dart %}
class DemoLocalizations {
  static Future<DemoLocalizations> load(Locale locale) {
    final String name = locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final String localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((Null _) {
      Intl.defaultLocale = localeName;
      return new DemoLocalizations();
    });
  }

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  String get title {
    return Intl.message(
      'Hello World',
      name: 'title',
      desc: 'Title for the Demo application',
    );
  }
}
{% endprettify %}

基于 `intl` 包的类导入生成的 message 目录，该目录提供 `initializeMessages()` 函数和每个语言环境的后备存储 `Intl.message()`。message 目录由 [`intl` tool](#dart-tools) 生成，它分析了包含 `Intl.message()` 方法调用的类的源码。在这个例子，这就是  DemoLocalizations 类。

<a name="specifying-supportedlocales"></a>
## 指定应用的 supportedLocales 参数

虽然 Flutter 的 Material Components library 包含对大约16种语言的支持，但默认情况下仅提供英文。因为工具库支持与应用程序不同的一组语言环境是没有意义的，所以由开发者决定支持哪种语言。

MaterialApp[`supportedLocales`](https://docs.flutter.io/flutter/material/MaterialApp/supportedLocales.html) 参数限制语言环境更改。当用户更改了设备上的区域设置后，新区域如果是列表成员，则应用的 `Localizations` 控件就适用于该区域，如果找不到设备区域的精确匹配项则使用第一个匹配区域设置[`languageCode`](https://docs.flutter.io/flutter/dart-ui/Locale/languageCode.html)。如果失败，则使用 `supportedLocales` 列表的第一项。

就之前的 DemoApp 示例，该应用只接受美国英语或加拿大法语语言环境，并将美国英语（列表中的第一个语言环境）替换为其他任何内容。

如果应用想要使用不同的  "locale resolution"  方法可以提供一个[`localeResolutionCallback`.](https://docs.flutter.io/flutter/widgets/LocaleResolutionCallback.html)
例如，要让您的应用无条件接受用户选择的任何区域：

{% prettify dart %}
class DemoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
       localeResolutionCallback(Locale locale, Iterable<Locale> supportedLocales) {
         return locale;
       }
       // ...
    );
  }
}
{% endprettify %}

<a name="alternative-class"></a>
## 指定本地化资源的另一个类

之前的 DemoApp 示例是根据 Dart intl 包定义的。为了简单起见，开发人员可以选择自己的方法来管理本地化值，也可以与不同的 i18n 框架进行集成。

这个示例的[完整代码](https://github.com/flutter/website/tree/master/_includes/code/internationalization/minimal/)。

在此版本的 DemoApp 中，包含应用程序本地化的类 DemoLocalizations 将直接在每种语言 Map 中包含其所有的翻译：


{% prettify dart %}
class DemoLocalizations {
  DemoLocalizations(this.locale);

  final Locale locale;

  static DemoLocalizations of(BuildContext context) {
    return Localizations.of<DemoLocalizations>(context, DemoLocalizations);
  }

  static Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'title': 'Hello World',
    },
    'es': {
      'title': 'Hola Mundo',
    },
  };

  String get title {
    return _localizedValues[locale.languageCode]['title'];
  }
}
{% endprettify %}

在最小限度的国际化应用中 DemoLocalizationsDelegate 稍有不同。它的 `load` 方法返回一个[SynchronousFuture](https://docs.flutter.io/flutter/foundation/SynchronousFuture-class.html) 因为不需要进行异步加载。


{% prettify dart %}
class DemoLocalizationsDelegate extends LocalizationsDelegate<DemoLocalizations> {
  const DemoLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'es'].contains(locale.languageCode);

  @override
  Future<DemoLocalizations> load(Locale locale) {
    return new SynchronousFuture<DemoLocalizations>(new DemoLocalizations(locale));
  }

  @override
  bool shouldReload(DemoLocalizationsDelegate old) => false;
}
{% endprettify %}

<a name="dart-tools"></a>
## 附录: 使用Dart intl工具

在使用 Dart [`intl`](https://pub.dartlang.org/packages/intl) 包构建 API 之前，您需要查看 `intl` 包的文档。以下是根据 intl 软件包本地化应用的过程摘要。

示例程序依赖于一个生成的源文件  `l10n/messages_all.dart` ，它定义了应用程序所用的所有本地化字符串。

重新构建 `l10n/messages_all.dart` 需要两个步骤。

<ol markdown="1">
<li markdown="1">将应用程序的根目录作为当前目录，从 `lib/main.dart` 生成`l10n/intl_messages.arb` :

{% prettify sh %}
$ flutter pub pub run intl_translation:extract_to_arb --output-dir=lib/i10n lib/main.dart
{% endprettify %}

`intl_messages.arb` 文件是一个 JSON 格式的map，拥有一个在 `main.dart` 中定义的  `Intl.message()` 函数入口。此文件作为英语和西班牙语翻译的一个模板， `intl_en.arb` 和 `intl_es.arb`。这些翻译是由您，开发人员创建的。
</li>

<li markdown="1">使用应用程序的根目录作为当前目录，为每个 `intl_<locale>.arb` 文件生成 `intl_messages_<locale>.dart` ，并在 `intl_messages_all.dart` 中导入所有 message 文件：

{% prettify sh %}
$ flutter pub pub run intl_translation:generate_from_arb --output-dir=lib/l10n \
   --no-use-deferred-loading lib/main.dart lib/l10n/intl_*.arb
{% endprettify %}

DemoLocalizations 类使用生成的 `initializeMessages()` 函数（定义在  `intl_messages_all.dart`）来加载本地化的 message 并使用 `Intl.message()` 来查找它们。
</li>

</ol>
