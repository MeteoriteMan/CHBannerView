# CHPageControl

## 效果

> 默认样式

![](https://github.com/MeteoriteMan/Assets/blob/master/gif/CHPageControl-iPhone%208.gif?raw=true)

> 图片样式

![](https://github.com/MeteoriteMan/Assets/blob/master/gif/CHPageControl-Style1-iPhone%20X%20Max.gif?raw=true)

> 多图片样式

![](https://github.com/MeteoriteMan/Assets/blob/master/gif/CHPageControl-Style2-iPhone%20X%20Max.gif?raw=true)

## 使用

```
    self.pageControl = [[CHPageControl alloc] init];
    [self.view addSubview:self.pageControl];
    self.pageControl.numberOfPages = 10;
    
    /// CHPageControl属性设置
    self.pageControl.dotDiameter = 10;
    self.pageControl.magrin = 10;
    self.pageControl.normalPageColor = [UIColor redColor];
    self.pageControl.currentPageColor = [UIColor greenColor];
    
    
    [self.pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.collectionView);
        make.bottom.offset(-8);
    }];

```

## 安装

使用 CocoaPods 集成. 首先在podfile中

>pod 'CHPageControl'

安装一下pod

>#import <CHPageControl/CHPageControl.h>

## 更新记录

|版本|更新记录|
|:--|:--|
|0.0.4|上个版本错误的magrin单词更换为interval,其余无改变|
|0.0.3|新增设置不同page的不同状态图片的设置|
|0.0.2|支持设置当前和正常状态的图片|
|0.0.1|支持设置是,是否是圆.点否切边.圆角大小.每个圆点的间隙.控件高度.|
