---
title: browserify和webpack快速配置入门教程
tags:
  - browserify
  - javascript
  - nodejs
  - webpack
  - 前端自动化部署
  - 工具
  - 敏捷开发
id: 556
categories:
  - javascript
  - workflow
date: 2015-09-21 09:04:12
---

随着前端的工程越来越复杂，快速的模块化构建、部署前端app也就变得更加的重要，最近比较火爆的工具有browserify和webpack。真的是非常好用，本文的目的就是教会大家怎么使用这两个工具，因为强大所以配置也非常复杂，但是我们常用的核心功能非常简单，下面我们就从实战的角度，告诉大家怎么能用其快速的构建应用，本文中的打包代码基本是 即拷贝即用。

## browserify

### 简介

[browserify](http://browserify.org/) 简单概括来说就是：按照依赖(require)打包你的js文件。并让它(node端代码)跑在浏览器环境下。
浏览器兼容程度如下：

![](http://browserify.org/images/testling_badge.png)

### 快速使用方法

```shell
    npm install -g browserify
    browserify main.js -o bundle.js
```

假设main.js是你的node模块代码，且main.js依赖了 basicA.js basicB.js。你可以通过上述命令快速的产出bundle.js文件，在浏览器端使用<script src="bundle.js"></script>，在bundle.js中会实现如下功能，所以最终代码就直接引用bundle.js即可。

*   增加对node的require和exports的支持，使得main.js的内容能够在浏览器端执行
*   分析出main.js的依赖模块basicA.js basicB.js并将其打包在bundle.js中
*   上述只是最简单的使用方法，详情请参考 [browserify-handbook](https://github.com/substack/browserify-handbook)

### gruntfile版本react工程最简配置（支持文件修改自动部署）

我们知道react是支持使用node模块和页面内嵌jsx,但是一般来说，react应用还是需要打包的步骤，将jsx的语法解析成对应的js执行。browsify支持react项目的打包，只需要引入对应的[reactify](https://github.com/andreypopp/reactify) 插件即可。最简单的配置如下：

```javascript
    //package.json
    {
      "name": "react-app",
      "version": "0.0.1",
      "dependencies": {
        "grunt": "^0.4.5",
        "grunt-browserify": "^3.3.0",
        "grunt-contrib-watch": "^0.6.1",
        "reactify": "^1.0.0"
      }
    }
```

```javascript
    //gruntfile文件配置
    //其中所有的jsx组件放到src下，而最终的入口文件为app.js
    //开发的时候执行grunt watch就可以监控src中所有jsx模板将其翻译成对应的js模块，在最终的html中引入bundle.js即可
    module.exports = function(grunt) {
      grunt.initConfig({
        pkg: grunt.file.readJSON('package.json'),
        watch: {
          browserify: {
            files: ['src/**/*.js*', 'app.js'],
            tasks: ['browserify']
          }
        },
        browserify: {
          example : {
            src: ['app.js'],
            dest: 'bundle.js',
            options: {
              transform: ['reactify']
            }
          }
        }
      });

      grunt.loadNpmTasks('grunt-contrib-watch');
      grunt.loadNpmTasks('grunt-browserify');
      grunt.registerTask('bundle-example', ['browserify:example']);
    };  
```

## webpack

### 简介

[webpack](https://webpack.github.io/) 也是一个强大的模块管理工具，它将所有的资源都算作一个模块，如下图。
![](http://cdn2.infoqstatic.com/statics_s1_20150616-0050/resource/articles/react-and-webpack/zh/resources/0602005.jpg)
和前面提到的browsify相比，browsify只是支持js的打包，webpack更加的智能，主要体现：
- 支持CommonJs和AMD模块。
- 支持模块加载器和插件机制，可对模块灵活定制，比如babel-loader加载器，有效支持ES6。
- 可以通过配置，打包成多个文件。有效利用浏览器的缓存功能提升性能。
- 将样式文件和图片等静态资源也可视为模块进行打包。配合loader加载器，可以支持sass，less等CSS预处理器。
- 内置有source map，即使打包在一起依旧方便调试。

### 快速使用方法

```shell
    npm install -g webpack
    ##支持的命令行参数有:-d:支持调试；-w支持实时的编辑打包；-p支持压缩
    webpack -d
    webpack -w
    webpack -p
```

webpack的默认文件名为：webpack.config.js，下面就介绍一个简单的工程所使用的webpack配置。

```javascript
    //单入口文件的打包
    var path = require("path");
    module.exports = {
        entry: './src/search.js', //单入口文件
        output: {
            path: path.join(__dirname, 'out'),  //打包输出的路径
            filename: 'bundle.js',              //打包后的名字
            publicPath: "./out/"                //html引用路径，在这里是本地地址。
        }
    };
    //多入口文件
    module.exports = {
        entry: {
            bundle_page1: "./src/search.js",
            bundle_page2: "./src/login.js"
        },
        output: {
            path: path.join(__dirname, 'out'),
            publicPath: "./out/",
            filename: '[name].js'//最后产出的文件为 out/bundle_page1.js out/bundle_page2.js
        }
    };
```

### webpack加载器和插件

webpack最大的特色就是支持很多的[loader](http://webpack.github.io/docs/list-of-loaders.html)，这些loader为复杂的应用构建提供了便利的部署环境，而不仅仅局限于node文件的浏览器环境打包而已。常用的加载器有哪些呢，这里会介绍这几个的用法。

*   [babel-loader](https://github.com/babel/babel-loader)：不仅可以做ES6-ES5的loader还可以用来实现jsx的编译
*   [less-loader](https://github.com/webpack/less-loader):用于将less编译成对应的css
*   [css-loader](https://github.com/webpack/css-loader)：加载css文件
*   [style-loader](https://github.com/webpack/style-loader)：转化成内置的<style>样式。上面三个常常一起使用，style!css!less，loader之间用!连接。在项目中直接 require('xxx.less')即可
*   [json-loader](https://github.com/webpack/json-loader)
*   [url-loader]()image sprite 的替代方案，会将制定的图片文件合并加载，有limit参数
*   [extract-text-webpack-plugin](https://github.com/webpack/extract-text-webpack-plugin):项目中如果不采用按需加载，而是要将所有的css打包成一个文件，并使用link加载，这个插件就有所帮助了。

### webpack实战一个工程配置

有了上述的loader，我们就可以做很多的项目配置了，假设我们有个实际的项目, 基本的操作都包括如下这些环节，我们该如何使用webpack实现这个功能配置呢？

*   JS编译与加载：loader + react模板开发
*   CSS编译与加载：less编译
*   JS与CSS压缩

```javascript
    //package.json
    {
      "name": "order-view",
      "version": "0.0.1",
      "dependencies": {
        "babel-loader": "",
        "less-loader": "",
        "css-loader": "",
        "style-loader": "",
        "autoprefixer-loader": "",
        "extract-text-webpack-plugin":""
      }
    }

```

```javascript
    // webpack.config.js
    // 执行webpack -p即可完成压缩
    var path = require("path");
    var ExtractTextPlugin = require("extract-text-webpack-plugin");
    module.exports = {
        //多文件入口
        entry: {
            bundle_page1: "./src/search.js",
            bundle_page2: "./src/login.js"
        },
        //指定文件的输出
        output: {
            path: path.join(__dirname, 'out'),
            publicPath: "./out/",
            filename: '[name].js'
        },
        module: {
            loaders: [
                //处理react模板的配置
                {
                    test: /.jsx?$/,
                    exclude: /(node_modules|bower_components)/,
                    loader: 'babel'
                },
                //生成内置的样式&lt;style&gt;
                //{
                //    test: /.less$/,
                //    exclude: /(node_modules|bower_components)/,
                //    loader: "style!css!less"
                //},
                //将依赖打包成一个css文件
                {
                    test: /.less$/,
                    exclude: /(node_modules|bower_components)/,
                    test: /.less$/,
                    loader: ExtractTextPlugin.extract(
                        'css?sourceMap&amp;-minimize!' + 'autoprefixer-loader!' + 'less?sourceMap'
                    )

                },
                //图片自动合并加载
                {
                    test: /.(jpg|png)$/,
                    loader: "url?limit=8192"
                }
            ]
        },
        plugins: [
            new ExtractTextPlugin('[name].css')
        ]
    };
```
    