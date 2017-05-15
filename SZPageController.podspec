Pod::Spec.new do |s|

s.name         = "SZPageController"
s.version      = "1.0.1"
s.summary      = "类似驾考宝典和小说阅读器覆盖翻页的控件."

s.description  = <<-DESC
类似驾考宝典和小说阅读器覆盖翻页的控件,仿UITableView提供代理接口，提供多种控制。
DESC

s.homepage     = "https://github.com/StenpZ/SZPagecontroller"
s.license      = "MIT"
s.author       = { "zxc" => "zhouc520@foxmail.com" }
s.platform     = :ios,'7.0'

s.source       = { :git => "https://github.com/StenpZ/SZPagecontroller.git", :tag => "#{s.version}" }
s.source_files = "SZPagecontroller/*.{h,m}"
s.framework    = "UIKit"
s.requires_arc = true

end
