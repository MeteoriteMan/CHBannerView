Pod::Spec.new do |s|
    s.name         = "CHBannerView"
    s.version      = "0.0.1"
    s.summary      = "CHBannerView is a easy way to build bannerView"
    s.homepage     = "https://github.com/MeteoriteMan/CHBannerView"
    s.license      = "MIT"
    s.license      = { :type => "MIT", :file => "LICENSE" }
    s.author       = { "张晨晖" => "shdows007@gmail.com" }
    s.platform     = :ios
    s.source       = { :git => "https://github.com/MeteoriteMan/CHBannerView.git", :tag => s.version }
    s.source_files = "CHBannerView/**/*.{h,m}"
    s.frameworks   = 'Foundation', 'UIKit', 'CHPageControl'
    s.dependency 'CHPageControl'
    s.requires_arc = true
end