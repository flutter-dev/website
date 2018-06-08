---
layout: page
title: "ExpansionTile"
permalink: /catalog/samples/expansion-tile-sample/
---

ExpansionTiles 可用于生成二级或多级列表。

<p>
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-4">
        <div class="panel panel-default">
          <div class="panel-body" style="padding: 16px 32px;">
            <img style="border:1px solid #000000" src="https://storage.googleapis.com/flutter-catalog/cb4a54db8fb3726bf4293b9cc5cb12ce16883803/expansion_tile_sample_small.png" alt="Android screenshot" class="img-responsive">
          </div>
          <div class="panel-footer">
            Android 截图
          </div>
        </div>
      </div>
    </div>
  </div>
</p>

这个应用程序使用 ExpansionTiles 展示分层数据。点击一个视窗会展开或折叠其子视图。当视窗被折叠时，它的子视图被收起，以便列表的 widget 只反映可见的东西。

当在一个可滚动的列表项中显示时，它会像使用 `ListView.builder()` 创建的可滚动列表一样，ExpansionTiles 可以非常有效，特别是对于 Material Design "展开/折叠"列表。

使用 `flutter create` 来创建一个新项目，并用下面的代码替换 `lib/main.dart` 的内容来尝试运行。

```dart
// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';

class ExpansionTileSample extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('ExpansionTile'),
        ),
        body: new ListView.builder(
          itemBuilder: (BuildContext context, int index) => new EntryItem(data[index]),
          itemCount: data.length,
        ),
      ),
    );
  }
}

// One entry in the multilevel list displayed by this app.
class Entry {
  Entry(this.title, [this.children = const <Entry>[]]);
  final String title;
  final List<Entry> children;
}

// The entire multilevel list displayed by this app.
final List<Entry> data = <Entry>[
  new Entry('Chapter A',
    <Entry>[
      new Entry('Section A0',
        <Entry>[
          new Entry('Item A0.1'),
          new Entry('Item A0.2'),
          new Entry('Item A0.3'),
        ],
      ),
      new Entry('Section A1'),
      new Entry('Section A2'),
    ],
  ),
  new Entry('Chapter B',
    <Entry>[
      new Entry('Section B0'),
      new Entry('Section B1'),
    ],
  ),
  new Entry('Chapter C',
    <Entry>[
      new Entry('Section C0'),
      new Entry('Section C1'),
      new Entry('Section C2',
        <Entry>[
          new Entry('Item C2.0'),
          new Entry('Item C2.1'),
          new Entry('Item C2.2'),
          new Entry('Item C2.3'),
        ],
      ),
    ],
  ),
];

// Displays one Entry. If the entry has children then it's displayed
// with an ExpansionTile.
class EntryItem extends StatelessWidget {
  const EntryItem(this.entry);

  final Entry entry;

  Widget _buildTiles(Entry root) {
    if (root.children.isEmpty)
      return new ListTile(title: new Text(root.title));
    return new ExpansionTile(
      key: new PageStorageKey<Entry>(root),
      title: new Text(root.title),
      children: root.children.map(_buildTiles).toList(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildTiles(entry);
  }
}

void main() {
  runApp(new ExpansionTileSample());
}
```

<h2>更多参阅:</h2>
- Material Design 规范中的 "expand/collapse" 部分：
    <https://material.io/guidelines/components/lists-controls.html#lists-controls-types-of-list-controls>
- 源码 [examples/catalog/lib/expansion_tile_sample.dart](https://github.com/flutter/flutter/blob/master/examples/catalog/lib/expansion_tile_sample.dart).
