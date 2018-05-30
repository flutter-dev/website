---
layout: page
title: 在 IDE 中开发 Flutter

permalink: /using-ide-vscode/
---

<div id="tab-set-install"><!---->

<ul class="tabs__top-bar"><!---->
    <li class="tab-link" data-tab-href="/using-ide/">Android Studio / IntelliJ</li>
    <li class="tab-link current">VS Code</li>
</ul><!---->

<div class="tabs__content current" markdown="1"><!---->

Visual Studio Code 的 Dart 扩展提供了完整的集成开发体验。
* TOC Placeholder
{:toc}

## 安装和配置

请按照 [配置编辑器](/get-started/editor/#vscode) 指令安装 Dart 扩展（包含 Flutter 功能包）。

### 升级扩展<a name="updating"/>

Vs Code 将定期发送扩展程序的更新通知。默认情况下，VS Code 将自动更新可更新的扩展程序。

手动安装更新：

1. 在侧边栏点击扩展按钮。
1. 如果 Dart 扩展显示可更新，点击 **更新** 随后当更新完成时点击 **重新加载**。

## 创建工程

### 创建一个新工程

通过 Flutter 应用模板启动器创建一个新的 Flutter 工程：

1. 打开命令选项板 (`Ctrl`+`Shift`+`P` (macOS 系统使用 `Cmd`+`Shift`+`P`))。
1. 选择 **Flutter: New Project** 命令并按下 `Enter` 键。
1. 输入你想要的 **工程名称**。
1. 选择一个 **工程位置**。

### 通过现有代码打开项目

打开一个已经存在的 Flutter 工程：

1. 点击 IDE 主窗口 **文件>打开...**。
1. 找到保存现有 Flutter 源代码的目录。
1. 点击 **打开**。

## 编辑代码并查看问题

Dart 扩展可以执行代码分析，使得：

* 语法高亮。
* 基于丰富类型分析的代码补全。
* 导航至类型声明 (**转到定义...** 或者 `F12`)，并查找类型用法 (**查找所有引用** 或者 `Shift`+`F12`)。
* 查看所有当前源代码的问题 (**查看>问题** 或者 `Ctrl`+`Shift`+`M` (macOS 下使用`Cmd`+`Shift`+`M`))。所有分析出来的问题将在问题面板中显示:
<br><img src="/images/vscode/problems.png" style="width:660px;height:141px" alt="Problems pane" />

## 执行和调试

在 IDE 主窗口上点击 **调试>启动调试** 或者按下 `F5` 开始调试。 

### 选择目标设备

当使用 VS Code 打开一个 Flutter 项目，你会在状态栏中看到一些具体的条目，包括 Flutter SDK 的版本号和一个设备名称 (或者 **No Devices** 提示)。

<img src="/images/vscode/device_status_bar.png" style="width:477px;height:73px" alt="Flutter device" />

*注意*: 如果你没有看到 Flutter 的版本号和设备信息说明你的工程可能还没有被检测成为一个 Flutter 工程。请确保包含您的 `pubspec.yaml` 的文件夹位于VS Code **工作区文件夹**。

*注意*: 如果状态栏显示 **No Devices** 说明 Flutter 无法发现任何连接的 iOS 或 Android 设备或模拟器。您需要连接设备或启动模拟器才能继续。

Dart 扩展会自动选择一个最近连接的设备，如果你连接了多个设备或模拟器你可以在状态栏中点击设备并在屏幕上方展示的选择列表中选择一个设备用于运行或者调试。

### 运行没有断点的应用程序

1. 在 IDE 主窗口点击 **调试>非调试启动** 或者按下 `Ctrl`+`F5`。
2. 状态栏将变为橙色说明您正在进行调试会话。
3. 底部 **Debug Console** 将显示输出：
<br><img src="/images/vscode/debug_console.png" style="width:490px;height:208px" alt="Debug Console" />

### 运行带有断点的应用程序

1. 如果有需要可以在源代码中设置断点。
2. 在 IDE 主窗口中点击 **调试>启动调试** 或者按下 `F5`。
3. 左侧 **调试侧边栏** 将显示堆栈帧和变量。
4. 底部 **调试控制台** 面板将显示详细的日志输出。
5. 调试基于默认的启动配置。 点击 **调试侧边栏** 顶部的齿轮按钮会创建一个 `launch.json` 文件，在该文件中自定义值可以定制启动配置。
   
## 快速编辑并刷新开发周期

Flutter 提供了一流的显影循环，使您能够通过“热重载”功能几乎可以立即看到变更的效果。 有关详细信息，请参阅 [热重载 Flutter 应用程序](/hot-reload/)。

## 高级调试

### 调试可视化布局问题

在调试会话期间，会在 [命令选项板](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette) 中添加几个附加的调试命令，包括：

* 切换基线绘制：在每个 RenderBox 的基线上绘制一条线。

* 切换彩虹重绘：重绘时显示图层周边的颜色（译者注：用不同的颜色代表不同的图层并显示出来）。

* 切换慢动画：减慢动画以便肉眼观察。

* 切换慢模式横幅：即便在调试构建时也要隐藏'慢速模式'的 Banner。
   
### 通过 Observatory 进行调试

Observatory （天文台）是一个额外的基于html的用户界面的调试和分析工具。 详情请参阅 [Observatory page](https://dart-lang.github.io/observatory/)。
打开 Observatory：

1. 在调试模式下运行您的应用程序。
1. 从 [命令选项板](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette) 中运行 **Open Observatory** 命令。

## 编辑 Flutter 代码的提示

### 辅助功能和快速修复

辅助功能可以更改与特定代码标识符相关的代码。 当把光标放在 Flutter Widget 的标识符上的时候，出现黄色灯泡图标时表示辅助功能可用。 通过点击灯泡图标或使用键盘快捷键 `Ctrl`+`Enter` 可以调用辅助功能如下图所示：

<img src="/images/vscode/assists.png" style="width:467px;height:234px" alt="Code Assists" />

与辅助功能类似，快速修复只有当一段代码显示有错误时才会显示可用，快速修复可以帮助纠正代码。

#### 用新的 Widget 包裹您的 Widget
你可以使用这个功能使用一个父 Widget 包裹你的 Widget，例如，如果你想在一个 `Row` 或 `Column` 中包裹你已有的 Widget。
 
#### 用新的 Widget 包裹您的 Widget 集合
和上面的辅助功能相似，这个辅助功能用于包裹已经存在的 Widget 集合而不是个别的 Widget。

#### 转换 child 到 children
将一个 child 参数转换为一个 children 参数，并将这个 children 参数加入到一个集合中。

### 代码片段

片段可以加快典型代码结构输入的速度。 输入片段的'前缀'调用片段，然后从窗口中选择片段：

<img src="/images/vscode/snippets.png" style="width:706px;height258px" alt="Snippets" />

Dart 扩展包含下面几种代码片段：

* `stless` 前缀： 创建一个 `StatelessWidget` 的子类。
* `stful` 前缀： 创建一个 `StatefulWidget` 的子类和一个与之关联的 State 子类。
* `stanim` 前缀：创建一个 `StatefulWidget` 的子类和一个与之关联的 State 子类。并且关联的 State 子类中包括一个用 `AnimationController` 初始化的字段。

你同样可以在 [命令选项板](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette) 中执行 **Configure User Snippets** 来自定义代码片段。

### 键盘快捷键

**热重载**

在调试会话期间，单击 **调试工具栏** 上的 **重新启动** 按钮或者按下 `Ctrl` +`Shift`+`F5`（macOS上的`Cmd` +`Shift` +`F5`）会执行热重载。

键盘映射可通过在 [命令选项板](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette) 中执行 **Open Keyboard Shortcuts** 命令进行更改。

**热重启**

### 热重载和热重启

热重载通过将更新的源代码文件注入正在运行的 Dart VM（虚拟机）中来工作。 不仅可以添加新类，还可以向现有的类中添加方法和字段，改变现有的函数。 但是一些类型的代码更改不能热重载：

* 全局变量初始化器。
* 静态字段初始化器。
* 应用程序的 `main()` 方法。

对于这些需要您完全重新启动应用程序的更改，不必结束您的调试会话，您可以通过在 [命令选项板](https://code.visualstudio.com/docs/getstarted/userinterface#_command-palette) 中运行 **Flutter：Full Restart** 命令或者按下 `Ctrl + F5` 热重启您的应用程序。

## 疑难解答

### 已知问题和反馈

在问题追踪系统中可以找到所有的已知漏洞：

  * Dart 扩展: [GitHub 问题追踪](https://github.com/Dart-Code/Dart-Code/issues)。

我们非常欢迎您反馈在使用过程中遇到的问题和对新功能的需求。提交新的问题前请首先：

  * 在问题跟踪器中进行搜索，查看在问题清单中是否已经存在相同的问题。
  * 确定您已经 [升级](#updating) 了最新版本的插件。

在提交新的问题的时候请包含 [`flutter doctor`](https://flutter.io/bug-reports/#provide-some-flutter-diagnostics) 输出的内容。

</div><!---->

</div><!---->


