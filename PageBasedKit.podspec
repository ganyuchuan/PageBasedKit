Pod::Spec.new do |s|

  s.name         = "PageBasedKit"
  s.version      = "1.0.0"

  s.summary      = "A collection of iOS page-based components"
  s.homepage     = "https://github.com/ganyuchuan/PageBasedKit"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.authora      = { "ganyuchuan" => "ganyuchuan@huxiu.com" }
  s.platform     = :ios, "8.0"
  s.ios.deployment_target = "8.0"

  s.source       = { :git => "https://github.com/ganyuchuan/PageBasedKit.git", :tag => s.version }

  s.source_files  = "Classes/**/*.{h,m}"

  s.frameworks = "UIKit"

  s.requires_arc = true

end
