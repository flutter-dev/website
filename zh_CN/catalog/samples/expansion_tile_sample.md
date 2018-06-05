---
layout: page
title: "ExpansionTile"
permalink: /catalog/samples/expansion-tile-sample/
---

ExpansionTiles can used to produce two-level or multi-level lists.

<p>
  <div class="container-fluid">
    <div class="row">
      <div class="col-md-4">
        <div class="panel panel-default">
          <div class="panel-body" style="padding: 16px 32px;">
            <img style="border:1px solid #000000" src="https://storage.googleapis.com/flutter-catalog/cb4a54db8fb3726bf4293b9cc5cb12ce16883803/expansion_tile_sample_small.png" alt="Android screenshot" class="img-responsive">
          </div>
          <div class="panel-footer">
            Android screenshot
          </div>
        </div>
      </div>
    </div>
  </div>
</p>

This app displays hierarchical data with ExpansionTiles. Tapping a tile
expands or collapses the view of its children. When a tile is collapsed
its children are disposed so that the widget footprint of the list only
reflects what's visible.

When displayed within a scrollable that creates its list items lazily,
like a scrollable list created with `ListView.builder()`, ExpansionTiles
can be quite efficient, particularly for Material Design "expand/collapse"
lists.

Try this app out by creating a new project with `flutter create` and replacing the contents of `lib/main.dart` with the code that follows.

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

<h2>See also:</h2>
- The "expand/collapse" part of the Material Design specification:
    <https://material.io/guidelines/components/lists-controls.html#lists-controls-types-of-list-controls>
- The source code in [examples/catalog/lib/expansion_tile_sample.dart](https://github.com/flutter/flutter/blob/master/examples/catalog/lib/expansion_tile_sample.dart).
