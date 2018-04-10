---
layout: page
title: Widget 目录
permalink: /widgets/
---

使用 Flutter 提供的视觉部件、结构部件、平台部件以及可交互的部件来加快创建一个漂亮的应用的进程。

<p>如果你想按照部件的分类来浏览这些部件，你可以在 <a href="/widgets/widgetindex/">Flutter部件索引页面</a> 看到所有的部件。</p>

<ul class="cards">
{% for section in site.data.catalog.index %}
	<li class="cards__item">
	    <div class="card">
		    <h3 class="catalog-category-title"><a class="action-link" href="/widgets/{{section.id}}">{{section.name}}</a></h3>
		    <p>{{section.description}}</p>
		    <div class="card-action">
		        <a class="action-link" href="/widgets/{{section.id}}">VISIT</a>
		    </div>
		</div>

	</li>
 {% endfor %}
</ul>
