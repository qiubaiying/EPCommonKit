Pod::Spec.new do |s|
  s.name         = "EPCommonKit" # 项目名称
  s.version      = "0.0.1"        # 版本号 与 你仓库的 标签号 对应
  s.license      = "MIT"          # 开源证书
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.summary      = "EP通用组建库" # 项目简介


  s.homepage     = "https://github.com/qiubaiying/EPCommonKit.git" # 仓库的主页
  s.source       = { :git => "https://github.com/qiubaiying/EPCommonKit.git", :tag => "#{s.version}" } #你的仓库地址，不能用SSH地址
  # s.source = { :git => "https://github.com/xiaofei86/LPPushService.git", :commit => "68defea" } #commit => "68defea" 表示将这个Pod版本与Git仓库中某个commit绑定
  # s.source = { :git => "https://github.com/xiaofei86/LPPushService.git", :tag => 1.0.0 }        #tag => 1.0.0 表示将这个Pod版本与Git仓库中某个版本的comit绑定
  # s.source = { :git => "https://github.com/xiaofei86/LPPushService.git", :tag => s.version }    #tag => s.version 表示将这个Pod版本与Git仓库中相同版本的comit绑定

  # s.source_files = "EPCommonKit/*.{h,m}", "EPCommonKit/**/*.{h,m}"
  # “*” 表示匹配所有文件
  # “*.{h,m}” 表示匹配所有以.h和.m结尾的文件
  # “**” 表示匹配所有子目录
  
  s.requires_arc = true # 是否启用ARC
  s.platform     = :ios, "9.0" #平台及支持的最低版本
  s.frameworks   = "UIKit", "Foundation" #支持的框架
  # 依赖库
  s.dependency 'AFNetworking' 
  s.dependency 'SDWebImage'

  s.subspec 'HXTagsView' do |ss|
    ss.source_files = 'EPCommonKit/HXTagsView.{h,m}'
  end

  # User
  s.author             = { "BY" => "qiubaiying@gmail.com" } # 作者信息
  s.social_media_url   = "http://qiubaiying.github.io" # 个人主页

end