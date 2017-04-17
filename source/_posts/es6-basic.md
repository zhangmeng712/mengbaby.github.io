---
title: ES6的核心语法与应用
tags:
  - ES6
  - javascript
  - React
id: 667
categories:
  - javascript
  - es6
date: 2016-01-24 14:28:03
---

一直以来都对ES6嗤之以鼻，本来灵活简单的Javascrit，非得为了提升B格，增加学习的成本，搞那么多鸡肋的语法。但是无奈俺们这些“老年jser”都被历史的车轮碾压了，现在如果不掌握ES6，估计很多代码都看不懂了。没有闲暇的午后时间来系统的学习ES6（其实还是有点抵触心理），但是为了跟上“年轻人”的步伐，随着用随着看随着学吧。力求以最简单的语言讲述。



## 模块

### 定义模块

语法为：

- export function x () {}
- export class
- export default {}
	
```javascript
// kittydar.js - 找到一幅图像中所有猫的位置
    export function detectCats(canvas, options) {
      var kittydar = new Kittydar(options);
      return kittydar.detectCats(canvas);
    }
    export class Kittydar {
      ... 处理图片的几种方法 ...
    }
    // 这个helper函数没有被export。
    function resizeCanvas() {
      ...
    }
    //默认的
    export default {
    	xx: '111'
    }
```

### 引用模块

```javascript
 import {detectCats} from "kittydar.js"; //引入某个方法
 import {detectCats, Kittydar} from "kittydar.js"; //引入并重命名
 import * as module from './module';//引入全部全部
 import helloWorld from './hello-world'; //引入默认
 function go() {
        var canvas = document.getElementById("catpix");
        var cats = detectCats(canvas);
        drawRectangles(canvas, cats);
    }
```  
## class用法

- 基本语法 class A {}
- 构造器 constructor {}
- 继承 class A extends AParent {}
- super()
- 注意：类声明与函数声明不同，它不会被提升,所以先new 后class定义 会抛出异常
- 静态变量：static compare(a, b) {}

```javascript
//ES5
//使用Object.defineProperty实现可读属性make year
function Vehicle(make, year) {
  Object.defineProperty(this, 'make', {
    get: function() { return make; }
  });

  Object.defineProperty(this, 'year', {
    get: function() { return year; }
  });
}

Vehicle.prototype.toString = function() {
  return this.make + ' ' + this.year;
}

var vehicle = new Vehicle('Toyota Corolla', 2009);
console.log(vehicle.make); // Toyota Corolla
vehicle.make = 'Ford Mustang'; //静态属性
console.log(vehicle.toString()) // Toyota Corolla 2009
```

```javascript
//ES6
class Vehicle {
  constructor(make, year) {
    this._make = make;
    this._year = year;
  }

  get make() {
    return this._make;
  }

  get year() {
    return this._year;
  }

  toString() {
    return 'xxx';
  }
}

var vehicle = new Vehicle('Toyota Corolla', 2009);

console.log(vehicle.make); // Toyota Corolla
vehicle.make = 'Ford Mustang';
console.log(vehicle.toString()) // Toyota Corolla 2009
```

```javascript
//ES5的继承
function Motorcycle(make, year) {
  Vehicle.apply(this, [make, year]);
}

Motorcycle.prototype = Object.create(Vehicle.prototype, {
  toString: function() {
    return 'xxx';
  }
});

Motorcycle.prototype.constructor = Motorcycle;

//ES6
class Motorcycle extends Vehicle {
  constructor(make, year) {
    super(make, year);
  }

  toString() {
    return 'xxxx';
  }
}
```



## 箭头函数

- 箭头函数的产生，主要由两个目的：更简洁的语法和与父作用域共享关键字this。
- function和{}都消失了，所有的回调函数都只出现在了一行里。
- 当只有一个参数时，()也消失了（rest参数是一个例外，如(...args) => ...）。
- 当{}消失后，return关键字也跟着消失了。单行的箭头函数会提供一个隐式的return（这样的函数在其他编程语言中常被成为lamda函数）。
- 箭头函数没有它自己的this值，箭头函数内的this值继承自外围作用域。
- 箭头函数与普通函数还有一个区别就是，它没有自己的arguments变量，但可通过<a href="https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/rest_parameters" target="_blank">rest参数</a>获得。

```javascript
function () { return 1; }
() => { return 1; }
() => 1
 
function (a) { return a * 2; }
(a) => { return a * 2; }
(a) => a * 2
a => a * 2
 
function (a, b) { return a * b; }
(a, b) => { return a * b; }
(a, b) => a * b
 
function () { return arguments[0]; }
(...args) => args[0]
 
() => {} // undefined
() => ({}) // {}
```

```javascript
//在之前的js中setInterval会把this指向window，
//使用箭头函数this使用外层的作用域所以不用保存this指针
$('.current-time').each(function () {
  setInterval(() => $(this).text(Date.now()), 1000);
});
```

```javascript
//箭头函数的arguments，通过rest函数可以获得
function log(msg) {
  const print = (...args) => console.log(args[0]);
  print(`LOG: ${msg}`);
} 
log('hello'); // LOG: hello
```

## 作用域

javascript本身是没有块级作用域的，ES6新增的let语法替代var实现了块级作用域。

```javascript
//before
function func(arr) {
    for (var i = 0; i < arr.length; i++) {
        // i ...
    }
    // 这里也可以访问到i
}
//ES6
function func(arr) {
    for (let i = 0; i < arr.length; i++) {
        // i ...
    }
    // 这里访问不到i
}
```


## React on ES6

详情参考 <a href="http://babeljs.io/blog/2015/06/07/react-on-es6-plus/" target="_blank">这篇文章</a>

### 定义组件

```javascript
// The ES5 way
var Photo = React.createClass({
  handleDoubleTap: function(e) { … },
  render: function() { … },
});
// The ES6+ way
class Photo extends React.Component {
  handleDoubleTap(e) { … }
  render() { … }
}
```

### componentWillMount关键字

```javascript
// The ES5 way
var EmbedModal = React.createClass({
  componentWillMount: function() { … },
});
// The ES6+ way
class EmbedModal extends React.Component {
  constructor(props) {
    super(props);
    //实现componentWillMount内容的地方像dom操作
  }
}
```

### state和props初始化

```javascript
// The ES5 way
var Video = React.createClass({
  getDefaultProps: function() {
    return {
      autoPlay: false,
      maxLoops: 10,
    };
  },
  getInitialState: function() {
    return {
      loopsRemaining: this.props.maxLoops,
    };
  },
  propTypes: {
    autoPlay: React.PropTypes.bool.isRequired,
    maxLoops: React.PropTypes.number.isRequired,
    posterFrameSrc: React.PropTypes.string.isRequired,
    videoSrc: React.PropTypes.string.isRequired,
  },
});

// The ES6+ way
// static 实现只读的props
// 全局state
class Video extends React.Component {
  static defaultProps = {
    autoPlay: false,
    maxLoops: 10,
  }
  static propTypes = {
    autoPlay: React.PropTypes.bool.isRequired,
    maxLoops: React.PropTypes.number.isRequired,
    posterFrameSrc: React.PropTypes.string.isRequired,
    videoSrc: React.PropTypes.string.isRequired,
  }
  state = {
    loopsRemaining: this.props.maxLoops,
  }
}
```

### react中的事件

```javascript

class PostInfo extends React.Component {
  constructor(props) {
    super(props);
    // Manually bind this method to the component instance...
    this.handleOptionsButtonClick = this.handleOptionsButtonClick.bind(this);
  }
  handleOptionsButtonClick(e) {
    // this应指向实例
    this.setState({showOptionsModal: true});
  }
}

//箭头函数this指向外层的组件
class PostInfo extends React.Component {
  handleOptionsButtonClick = (e) => {
    this.setState({showOptionsModal: true});
  }
}

```

### 实例

使用ES6改写的React组件程序

```javascript
import React from 'react'
class Checkbox extends React.Component {
    constructor(props) {
        super(props);
        this.state = {isChecked: false};
        this.changeState = this.changeState.bind(this);
    }
    changeState () {
        this.setState({isChecked: !this.state.isChecked})
    }
    render() {
        return (<label>
            <input type="checkbox" checked={this.state.isChecked} onChange={this.changeState} />
            {this.state.isChecked ? this.props.labelOn : this.props.labelOff}
        </label>)
    }

}
export default Checkbox;
```