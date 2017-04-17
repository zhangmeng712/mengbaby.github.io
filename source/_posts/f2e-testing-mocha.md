---
title: 前端自动化测试基础-mocha篇
tags:
  - bdd
  - chai
  - mocha
  - nodejs
  - 前端
  - 异步
  - 自动化测试
id: 581
categories:
  - nodjs
  - testing
date: 2015-10-13 08:05:22
---

## 安装

```shell
    npm install -g mocha
```

## 命令行用法

常用的命令行为：

```shell
   mocha -u bdd -R spec -t 5000 --recursive
```

- -u：测试方式 bdd|tdd|exports
- -R：选择报表的展现方式，报表展现方式，默认为spec，附加的 例如mocha-lcov-reporter（需要自己安装）
- -t：超时时间设置，当测试中有异步的时候如果超过设定时间会退出测试，默认2s
- --recursive：默认会把test文件夹和子文件夹中的所有的测试文件执行一遍

详解参考官网<a href="http://mochajs.org/#usage" targe="_blank">Usage</a>

## describe it hook

初次接触mocha的人，常常会觉得这几个概念很抽象,用简单的语言概括来说：

- describe:用于将测试分类，可以嵌套，范围从大到小

- it：真正包裹测试断言的作用域

- hook：before beforeEach after afterEach 为测试做辅助的作用域，例如 before中可以执行数据库的初始化，或者检测活动；after中用于清除使用的变量等。

## mocha和BDD测试

mocha支持bdd和tdd的测试，支持should/expect的断言方式,常和<a href="http://chaijs.com/api/bdd/" target="_blank">chai</a>结合在一起使用

```javascript

//npm install chai之后
var chai = require('chai');
var expect = chai.expect;

var Person = function (name) {
    this.name = name;
};

var zhangmeng = new Person('zhangmeng');

describe('zhangmeng attribute', function () {
    it ('zhangmeng should be a person ', function () {
        expect(zhangmeng).to.be.an.instanceof(Person);
    })
});

```

## 异步的处理

在javascript的世界 测试异步程序是特别常见的，例如文件的读写、数据库的访问等等，mocha对异步的支持也特别好，你只需要在最里面的函数中增加对应的回调即可，此外mocha是支持promise的

```javascript
/**
 * @fileOverView mocha-async-demo
 * @author zhangmeng on 15/10/12
 */

//使用异步callback的方式

var fs = require('fs');
var fileName = '/opt/local/share/nginx/html/my-git/f2e-testing/basic/files/name.json';

var chai = require('chai');
var expect = chai.expect;
var Q = require('q');


//使用回调的方式测试

describe('file content validation through callback', function () {
    //读取文件内容
    var fileObj = {};
    before(function (done) {
        //async
        fs.readFile(fileName, 'utf-8', function (err, data) {
            if (err) {
                throw err;
            }
            fileObj = JSON.parse(data);
            done();
        });
    });

    it ('expect name to be zhangmeng', function () {
        var name = fileObj.name;
        expect(name).to.equal("zhangmeng");
    });

    it ('expect name to be zhangmeng', function () {
        var age = fileObj.age;
        expect(age).to.equal('29');
    });
});



//使用promise的方式例子
describe('file content validation through promise', function () {
    var fileObj = {};
    var readFilePromise = function(path, encoding) {
        var encoding = encoding || 'utf-8';
        var deferred = Q.defer();
        fs.readFile(path, encoding, function(err, text) {
            if(err) {
                deferred.reject(new Error(err));
            } else {
                deferred.resolve(text);
            }
        });
        return deferred.promise;
    };

    before('read name.json', function () {
        //return 支持promise的异步
        return readFilePromise(fileName).then(function(data) {
            try {
                fileObj = JSON.parse(data);
            } catch(err) {
                console.log(err);
            }
        })
    });

    it ('name should be zhangmeng', function () {
       var name = fileObj.name;
       expect(name).to.equal('zhangmeng');
    });

    it ('age should be 29', function () {
        var age = fileObj.age;
        expect(age).to.equal('29');
    });
});
```

## 执行顺序

关于it和hook之间的顺序，有时非常容易混淆，先上结论：

- beforeEach会对当前describe下的所有子case生效。
- before和after的代码没有特殊顺序要求。
- 同一个describe下可以有多个before，执行顺序与代码顺序相同。
- 同一个describe下的执行顺序为before, beforeEach, afterEach, after（*），见下例。
- 当一个it有多个before的时候，执行顺序从最外围的describe的before开始，其余同理。
- 当没有it的时候，before还有beforeEach的内容都不会执行（*）
- it的内容是按照顺序执行的 即使前面的it的内容完成的时间偏后，也会按照顺序执行（*）

```javascript

describe('earth', function(){
    beforeEach(function(){
        console.log('see.. this function is run EACH time, before each describe()')
    })
    describe('singapre', function(){
        before(function () {
            console.log('it will happen before beforeEach and only once')
        })
        it('birds should fly', function(){ /** ... */ })
        it('horse should gallop', function(){ /** ... */ })
    })
    describe('malaysia', function(){
        it('birds should soar', function(){ /** ... */ })
    })
})
//执行结果
//earth
//singapre
//it will happen before beforeEach and only once
//see.. this function is run EACH time, before each describe()
//✓ birds should fly
//see.. this function is run EACH time, before each describe()
//✓ horse should gallop
//malaysia
//see.. this function is run EACH time, before each describe()
//✓ birds should soar

```

## 源码

- <a href="https://github.com/zhangmeng712/f2e-testing/blob/master/basic/test/mocha-chai.js">mocha与chai的结合</a>
- <a href="https://github.com/zhangmeng712/f2e-testing/blob/master/basic/test/mocha-order.js">mocha执行顺序</a>
- <a href="https://github.com/zhangmeng712/f2e-testing/blob/master/basic/test/mocha-async-demo.js">mocha的异步（callback和promise）</a>
- <a href="https://github.com/strongloop/express/tree/master/test">复杂的mocha应用-express</a>