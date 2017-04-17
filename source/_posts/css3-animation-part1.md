---
title: css3和动画-part1-变换
tags:
  - css3
  - html5
  - javascript
id: 332
categories:
  - javascript
  - css3
date: 2015-02-03 11:15:22
---

常年开发web后台系统，实在厌恶了做不完的需求、调不完的接口、和各种数据交互，所以闲暇之余开始了动画和游戏的学习，也算一种调剂。动画比游戏应用更为广泛，所以我们先从动画说起，这系列教程主要包括如下几篇文章：<p>

*   css3和动画-part1  基础篇；css3动画基础和实例（有demo有真相 力求比w3cschool实用些）
*   css3和动画-part2  进阶篇；理论结合实际实现几个较为复杂但有意思的动画效果
*   css3和动画-part3  蛋疼篇；transform、matrix和贝塞尔曲线
*   javascript和动画-part1  姊妹篇；使用javascript完成动画
*   javascript和动画-part2  姊妹进阶篇；高性能js动画类库分析-snabbt和gsap

<p style="text-indent: 2em;">废话不说（此处省略XXXX个字），上来先总结一下动画的相关的知识，让大家有个大概的印象，然后再各个击破。css3动画有很多名词都比较相似，例如 transform transiton translate，参数用法也特别容易混，这里我主要按照我学习的线索作为提纲分块讲解，希望对大家有所帮助：<p>

*   实现各种变换效果的关键字：transform： translate opacity skew rotate...
*   静到动的实现函数：transition和animation
*   3D相关：translate3d perspective

## 变换

 <p style="text-indent: 2em;">不谈代码，我们大概能想到的变换效果都有哪些呢？放大、缩小、旋转、显隐，上下左右移动， 扭曲等等。对于这些变换，css3为给我们提供了丰富的效果关键字，这篇文章主要谈论常用的、高效的变换。之所以说是高效的变换，其实主要是在渲染的过程中能够尽量减少浏览器Recalculate的变换效果，参见[High Performance Animations](http://www.html5rocks.com/en/tutorials/speed/high-performance-animations/)。这些变换有:

*   Position：translate
*   Scale
*   Rotate
*   opacity

### transform

这个是个非常重要的关键字，他的作用是，transform：需要变换的属性 不同属性直接用空格分隔,举例来说要实现 某一文字放大并向右平移50像素，代码为：
  
```css
.second {
  -webkit-transform: scale(1.1) translate(50px, 0);
  -ms-transform: scale(1.1) translate(50px, 0);
  transform: scale(1.1) translate(50px, 0)
}
```

下面就具体讲讲，被transform的各种变换效果。

### translate

如果要实现元素从某一位置变换到另一个位置的时候，我们可以使用top left进行变换， 也可以使用margin-left margin-top，但是，其实这些都是会触发浏览器的Recalculate，会让动画出现卡顿，实现效率也非常的低下，参考[jsperf](http://jsperf.com/translate3d-vs-xy/57)做的对比，也可以戳戳Paul Irish的[文章](http://www.paulirish.com/2012/why-moving-elements-with-translate-is-better-than-posabs-topleft/)。如果改用translate这个关键字就可以非常cheaply的实现动画效果。translate主要是用来改变元素坐标的一种变换。API为：

*   transform:  translate(tx[, ty])  /* one or two <translation-value> values */
*   transform:  translateX(tx)
*   transform:  translateY(ty)

常见的场景就是使用translate实现轮播的效果，下面是轮播的最简单的一个demo实现：
<p data-height="357" data-theme-id="7928" data-slug-hash="wBrwwN" data-default-tab="result" class='codepen'>See the Pen <a href='http://codepen.io/zhangmeng712/pen/wBrwwN/'>wBrwwN</a> by zhangmeng712 (<a href='http://codepen.io/zhangmeng712'>@zhangmeng712</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//codepen.io/assets/embed/ei.js"></script>
最核心的代码就是：


```css
.card-list.second {
  -webkit-transform: translate(-540px, 0px);
  -ms-transform: translate(-540px, 0px);
  transform: translate(-540px, 0px);
}
```

_**Tips**_: 我们不是电脑，没法记得哪些需要前缀哪些不需要，这里推荐给大家一个工具，[autoprefixer](https://github.com/postcss/autoprefixer)这个是在[caniuse](http://caniuse.com/)这个网站的基础上用来帮我们实现兼容的前缀的，我们可以只写最基本的，他自动会帮我们补全,[在线地址](http://simevidas.jsbin.com/gufoko/quiet)。

### scale

scale如同它的英文含义一样，是用来把元素进行放大缩小的，它也是非常实用的，先看API：

*   transform:  scale(sx[, sy]);
*   transform:  scaleX(sx);*   transform:  scaleY(sy);

scale最常见的应用就是在鼠标hover的时候把图标进行放大，以表示选中状态，引起注意，如下面这个demo，这里也有个工具网站推荐[shapeofcss](http://css-tricks.com/examples/ShapesOfCSS/)，在这里面可以找到我们常见的形状的实现。例子中同时使用了[webfontIcon](http://fortawesome.github.io/Font-Awesome/examples/)，这个技术让前端彻底告别切图的时代。


<p data-height="357" data-theme-id="7928" data-slug-hash="myBMZX" data-default-tab="result" class='codepen'>See the Pen <a href='http://codepen.io/zhangmeng712/pen/myBMZX/'>wBrwwN</a> by zhangmeng712 (<a href='http://codepen.io/zhangmeng712'>@zhangmeng712</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//codepen.io/assets/embed/ei.js"></script>


### rotate

rotate是用于让元素旋转的效果。旋转效果常配合着3D的效果一起使用，实现空间化的效果；也经常配合animation实现loading spinner的效果，如下demo：

*   transform:  rotate(angle);       /* an <angle>, e.g., rotate(30deg) */
*   transform:  rotateX(angle);*   transform:  rotateY(angle);

<p data-height="357" data-theme-id="7928" data-slug-hash="qEPVRQ" data-default-tab="result" class='codepen'>See the Pen <a href='http://codepen.io/zhangmeng712/pen/qEPVRQ/'>qEPVRQ</a> by zhangmeng712 (<a href='http://codepen.io/zhangmeng712'>@zhangmeng712</a>) on <a href='http://codepen.io'>CodePen</a>.</p>
<script async src="//codepen.io/assets/embed/ei.js"></script>

### opacity

opacity的用途其实更加的广泛，不管是rotate也好scale也好，如果没有一些opacity的变化就会让变换十分的生硬。配合opacity和display的切换是会导致重排的。所以如果需要元素的隐藏显示，最好采用opacity来控制。opacity还常常和animation配合起来，用于实现fadeIn fadeOut等人性化的动画设计。注意 opacity虽然是一种效果，但是并不需要使用transform来控制。API非常简单: opacity:0.4，记得每次开一个新的项目都会有实现transparent全兼容的css的代码，在此也为大家提供一下,见[CssTricks](http://css-tricks.com/snippets/css/cross-browser-opacity/)：

```css
.transparent_class {
  /* IE 8 */
  -ms-filter: "progid:DXImageTransform.Microsoft.Alpha(Opacity=50)";

  /* IE 5-7 */
  filter: alpha(opacity=50);

  /* Netscape */
  -moz-opacity: 0.5;

  /* Safari 1.x */
  -khtml-opacity: 0.5;

  /* Good browsers */
  opacity: 0.5;
}
```

本来想一篇文章把“变换” “动画” 还有“3D效果”一起讲解，但发现要说的东西太多了，为了保证质量，拆分成了三篇，力求把动画的内容涵盖完全，敬请期待哦~

参考：

*   [mozilla](https://developer.mozilla.org/en-US/docs/Web/CSS/transform)
*   [css tricks](http://css-tricks.com/almanac/properties/t/transform/)