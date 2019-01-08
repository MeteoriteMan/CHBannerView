# CHBannerView

## 效果

![](https://github.com/MeteoriteMan/Assets/blob/master/gif/CHBannerView-Demo-iPhone%208.gif?raw=true)

## 使用

1.遵循`<CHBannerViewDelegate>`代理

2.UI展示实现

```
- (NSInteger)bannerView:(CHBannerView *)bannerView numberOfItemsInSection:(NSInteger)section;

- (UICollectionViewCell *)bannerView:(UICollectionView *)collectionView cellForItemAtIndex:(NSInteger)index;
```

3.点击代理实现

```
- (void)bannerView:(UICollectionView *)collectionView didSelectItemAtIndex:(NSInteger)index;
```

## 安装

使用 [CocoaPods](http://www.cocoapods.com/) 集成.
首先在podfile中
>`pod 'CHBannerView'`

安装一下pod

>`#import <CHBannerView/CHBannerView.h>`

## 更新记录

|版本|更新内容|
|:--|:--|
|0.0.1|内置一个默认FlowLayout样式.支持自定义FlowLayout.|