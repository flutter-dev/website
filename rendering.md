---
layout: page
title: 在 Flutter 中渲染

permalink: /rendering/
---

* TOC Placeholder
{:toc}

## 介绍

Flutter 的渲染树 (rendering tree) 是一个低层次的布局和绘制系统，基于一颗保留着继承自 `RenderObject` 对象的树。大多数使用 Flutter 的开发人员不需要直接与渲染树交互，而应使用 
[widgets](/widgets-intro/)，他们是用渲染树创建。

### 基本模型

`RenderObject` 是渲染树中每个节点的基类，它定义了基本布局模型。基本布局模型是非常普遍的，可以容纳大量的具体的布局模型并存于同一棵树中。例如，基本布局模型提交一个尺寸的固定数量甚至笛卡尔
坐标系。这样看来，一颗渲染树让在三维空间里的渲染对象与其他在二维空间里的渲染对象一起运作，例如，在一个三维空间中的立方体表面上。并且，这个二维布局可能一部分的在笛卡尔坐标计算一部分在极坐标中计算。
这些不同的模型可以在布局过程中进行交互，例如根据立方体表面上文本块的高度来该确定立方体的大小。

渲染树并不完全是自由运转的，基本布局模型强加一些构造在渲染树上：

 * `RenderObject` 的子类必须实现一个 `performLayout` 的方法把其父对象提供的 `constraints` 对象作为输入。
`RenderObject` 对这个对象的构造和不同的布局模型使用不同类型的约束的没有决定权。但是，无论他们选择什么都必须实现 `operator==` 函数，这样才能使得 `performLayout` 为两个可以 `operator ==` 的 `constraints` 对象为产生相同输出。

 * `performLayout` 的实现者们期望调用子类的 `layout` 方法。当调用 `layout` 时，`RenderObject` 必须用 `parentUsesSize` 作为参数,来声明是否它的 `performLayout` 函数要依赖从子类读取的信息。如果父类没有声明它要使用到子类的大小，从父到子的边缘变成一种 _relayout boundary_ ，意味着子类（及其子树）的布局可能不受父类布局影响。

 * `RenderObject` 的子类必须实现一个 `paint` 函数将一个可视化对象绘制一个到 `PaintingCanvas` 上。如果 `RenderObject` 有子类，`RenderObject` 就有绘制子类的责任,通过调用在 `PaintingCanvas` 上 `paintChild` 方法。

 * `RenderObject` 在添加子类时必须调用 `adoptChild`。类似地，在删除子类时必须调用 `dropChild`。

 * `RenderObject` 的大多数子类将实现一个 `hitTest` 方法，让客户端查询渲染树上的跟给定用户输入位置相交的对象。`RenderObject` 自身并不会强加一个特定的类型标识在 `hitTest` 上，但是大多数的实现者会接收一个参数类型为 `HitTestResult`（或者，更有可能的是 `HitTestResult` 的特定模型子类）以及一个描述给用户提供输入位置的对象（例如，一个在二维笛卡儿坐标系中的“点”模型）。

 * 最后，`RenderObject` 的子类可以重载默认的空实现 `handleEvent` 和 `rotate` 函数来分别响应用户的输入、屏幕旋转。

基本模型还提供了两个常见的孩子混合模型：

 * `RenderObjectWithChildMixin` 是 `RenderObject` 非常有用的子类，它有一个独特的孩子。

 * `RenderObjectWithChildMixin` 是 `RenderObject` 非常有用的子类，有一个孩子列表。

`RenderObject` 的子类不一定要使用这些模型，它可以为其特定用例自由地创建新的子类模型 。

### 父数据

TODO(ianh) : 描述父数据的概念。

当父节点发生变化时,每个 child 都会自发调用 `setupParentData()` 方法。但是，如果你想在一个 节点添加到父级之前设置其 `parentData`  成员的初始值，你可以先调用未来的父节点的 `setupParentData()`  方法并把未来子节点作为参数。

TODO(ianh) : 讨论子节点的 parentData 会把每个子节点的的配置信息给到父级。

如果动态更改子级 的parentData，则还必须调用父级的  markNeedsLayout()，否则新消息不会生效
直到被其他事件触发布局。

### 盒子模型
#### 尺寸

所有尺寸均以逻辑像素单位表示。字体大小也是逻辑像素单位。逻辑像素单位大约为 96 dpi，但是精确值根据硬件而不同，在这样
可优化性能和渲染质量，保持在不同的硬件像素密度下界面尺寸大致相同。

绘制图像时逻辑像素单元会根据合适的比例因子自动转换为设备（硬件）的像素。

TODO(ianh) : 您是如何在需要时获得设备像素比例的，并记录最佳实践。

#### EdgeInsets

#### BoxConstraints

### Bespoke Models


使用所提供的子类
-----------------------------

### render_box.dart

#### RenderConstrainedBox

#### RenderShrinkWrapWidth

#### RenderOpacity

#### RenderColorFilter

#### RenderClipRect

#### RenderClipOval

#### RenderPadding

#### RenderPositionedBox

#### RenderImage

#### RenderDecoratedBox

#### RenderTransform

#### RenderSizeObserver

#### RenderCustomPaint

### RenderBlock (render_block.dart)

### RenderFlex (render_flex.dart)

### RenderParagraph (render_paragraph.dart)

### RenderStack (render_stack.dart)

编写新的子类
----------------------

### RenderObject的协议

如果你想使用新坐标系定义一个 `RenderObject`，那么您应该直接从  `RenderObject` 继承。可以在 `RenderBox` 中找到这样做的示例，它在笛卡尔空间中处理矩形，在 [sector_layout.dart
example](https://github.com/flutter/flutter/blob/master/examples/layers/rendering/src/sector_layout.dart) 示例中可以实现基于极坐标的玩具模型。 `RenderView` 类是另一个例子，它在内部使用来适应从系统主机到渲染框架。

一个 `RenderObject` 的子类必须满足以下协议:

* 在处理子类时，必须遵循 `AbstractNode` 协议。使用  `RenderObjectWithChildMixin` 或  `ContainerRenderObjectMixin`  可以使这更容易。

* 有关由父类管理的子类的信息，例如，通常父类布局的位置信息和配置应存储在  `parentData` 成员上；为此，应该定义一个 ParentData 子类，并重写 `setupParentData()` 方法以适当地初始化子类的父数据。

* 布局约束必须用 Constraints 的子类表示。这个子类必须实现  `operator==`（和 `hashCode`）。

* 每当布局需要更新时，都应该调用 `markNeedsLayout()` 方法。

* 每当需要更新渲染而不更改布局时，应调用 `markNeedsPaint()` 函数。（调用 `markNeedsLayout()` 就意味着调用 `markNeedsPaint()`，所以你不需要同时调用它们。）

* 子类必须重载 `performLayout()` 以根据 `constraints` 成员中给出的约束条件执行布局。每个对象都负责确定自己的尺寸;定位必须由调用了  `performLayout()` 的对象完成。是在孩子布局之前还是之后进行定位是由这个类决定的。
  
  TODO(ianh): sizedByParent, performResize(), rotate 的文档

* TODO(ianh): painting, hit testing, debug* 的文档

#### ParentData 的协议

#### RenderObjectWithChildMixin 的使用

#### ContainerRenderObjectMixin(和 ContainerParentDataMixin) 的使用

这个 mixin 可以用在有孩子列表的类来管理列表。它使用 `parentData`  结构中的链表指针实现这个列表。

TODO(ianh): 这个 mixin 的文档

除了父类的协议，子类还必须遵循以下约束：

* 如果构造函数有一列的孩子，它必须调用 addAll() 添加那个列表。

TODO(ianh): 说明如何使用这些孩子们。

### RenderBox的协议

一个 `RenderBox` 子类需要实现以下协议：

* 在处理孩子们时，它必须遵循 `AbstractNode` 协议。请注意， `RenderObjectWithChildMixin` 或 `ContainerRenderObjectMixin` 时为你服务时,你也得遵循他们的协议。

* 如果有任何数据存储在其子节点上，它必须定义一个 BoxParentData 的子类并重载 setupParentData() 以给孩子的 parent data 初始化合适的数据，如下面示例。（如果子类想让它孩子们必须是什么类型，例如，  `RenderBlock` 希望其子级都为 `RenderBox` 节点，则相应地更改  `setupParentData()` 识别标志，以捕获该方法的误用。）

<!-- skip -->
```dart
  class FooParentData extends BoxParentData { ... }

  // 在RenderFoo中
  void setupParentData(RenderObject child) {
    if (child.parentData is! FooParentData)
      child.parentData = new FooParentData();
  }
```

* 该类必须封装具有以下功能的布局算法：

** 用一个 BoxConstraints 对象来描述的一系列的约束集合作为输入，以及通过类自已来决定零或多个的孩子集，并输出一个 Size（在对象自己的 `size` 属性中设置） ，以及每个孩子的位置（在孩子的 `parentData.position` 属性中设置）。

** 该算法可以通过以下两种方式之一来决定大小：或者完全基于给定的约束条件（即，它完全由其父级完全确定大小），或者基于以上这些约束条件和孩子们的尺寸。

   在前一种情况下，该类必须具有返回 true 的 sizeByParent的getter，并且它必须有一个 `performResize()` 的方法来用这个对象的  `constraints` 成员去计算自身的大小。大小必须保持一致，一组给定约束结果总是相同的大小。

   在后一种情况下，它将继承 `sizedByParent` 默认的 getter 方法返回 false，并且它将在下面描述的 `performLayout()` 函数中计算自身的大小。

   `sizedByParent` 优势就是纯粹的性能优化。它使得节点根据基于传入的约束只设置其大小而跳过那些在重新布局时的逻辑，更重要的是，它让布局系统将节点作为一个 _layout boundary_，从而减少当节点被标记为需要 layout 时的工作量。

* 以下方法返回值必须与使过的布局算法的输出数值一致：

  * `double getMinIntrinsicWidth(BoxConstraints constraints)`  的返回值必须在给定约束的高度以下，使得当在宽度的约束变小时不会增加结果的高度,或者,换句话说，这个盒子可以在完全的把孩子们放在自己的里面的最小渲染宽度。

     例如，像 “a b cd e” 这样的文本的最小固有宽度，允许文本空格处换行，the minimum intrinsic width 应该是"cd"的宽度。

  * `double getMaxIntrinsicWidth(BoxConstraints constraints)`  的返回值必须在给定约束的宽度以上，使得当在宽度的约束变大时不会降低结果的高度。

     例如，像 “a b cd e” 这样的文本的最大固有宽度，允许文本空格处换行，the maximum intrinsic width 将是没有换行的 “a b cd e” 字符串整体的宽度。

  * `double getMinIntrinsicHeight(BoxConstraints constraints)` 的返回值必须在给定约束的高度以下，使得当在高度的约束变小时不会增加结果的宽度，或者,换句话说，这个盒子可以在完全的把孩子们放在自己的里面的最短渲染高度。

     宽高算法中的最小固有高度，像英文文本布局一样，将是给定宽度约束条件的文本的高度 。举例来说，给到 “hello world” 文本，如果约束条件是它必须在空格处换行，那么最小固有高度将是两行的高度（加上适当的行间距）。如果满足了约束条件后全部一行，那么它就是一行的高度。

   * `double getMaxIntrinsicHeight(BoxConstraints constraints)`  的返回值必须在给定约束的高度以上，使得当在高度的约束变小时不会减少结果的宽度，如果高度完全取决于宽度，而宽度不取决于高度，则给 `getMinIntrinsicHeight()` 和 `getMaxIntrinsicHeight()` 相同约束
将返回相同的数值。

     在英文文本的中，最大固有高度与最小固有高度相同。

* 盒子中必须有一个 `performLayout()` 方法来封装这个类显示时布局算法。
它负责告诉孩子们如何布局，布置孩子位置，并且,如果 sizedByParent 返回 false，还要计算对象的大小。

  具体来说，该方法必须遍历对象的子对象（如果有的话），
并且为每个子对象调用 `child.layout()` 并把 BoxConstraints 对象的作为第一个参数的，
第二个参数名为 `parentUsesSize`，如果孩子大小的结果将会以任何方式影响布局则 `parentUsesSize` 必须为 true，
如果孩子的结果大小是被忽略的，则省略掉（或设为 false）。
还必须设置孩子的位置(`child.parentData.position`) 。

  （调用 `layout()` 可以导致孩子自己的 `performLayout()` 方法被递归地调用，如果孩子也需要布局的话
。如果孩子的约束没有改变，并且孩子没有被标记为需要布局，该方法将被跳过。）

  父节点不得直接设置孩子的 `size`。
如果父节点想要影响子节点的尺寸，那么必须通过传递给孩子 `layout()` 方法的约束来实现。

  如果对象的 `sizedByParent` 为 false，
则其 `performLayout()` 也必须测量对象的大小（通过设置 `size`），否则，对象的大小将不改变。

* `size` 值不能设置为无限大。

* 该盒子还必须实现 `hitTestChildren()`。
  TODO(ianh): 定义这个更好

* 该盒子还必须实现`paint()`。
  TODO(ianh): 定义这个更好

#### RenderProxyBox 的使用

### Hit Testing 的协议


性能经验法则
--------------------------

* 如果只是简单的计算就足够请避免使用 transforms 
（例如，在 x，y 处绘制矩形，而不是用 x，y 进行平移并在 0,0 处绘制）。

* 避免在画布上使用 save/restore。


有用的调试工具
----------------------

这是一种快速方式将整个渲染树每帧转存到控制台上。
这在确定使用渲染树工作时究竟发生了什么非常有用。

```dart
import 'package:flutter/rendering.dart';

void main() {
  RendererBinding.instance.addPersistentFrameCallback((_) {
    // 这样会转存整个渲染树的每一帧
    debugDumpRenderTree();
  });
  // ...
}
```