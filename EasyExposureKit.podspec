Pod::Spec.new do |s|

  s.name         = "EasyExposureKit"
  s.version      = "1.0.0"
  s.summary      = "Help to analyze exposure events for UIView in iOS."

  s.description  = <<-DESC
  					This is a library to help to analyze exposure events for UIView in iOS.
                   DESC

  s.homepage     = "https://github.com/623637646/ExposureKit"

  s.license      = "MIT"

  s.author       = { "Yanni Wang" => "wy19900729@gmail.com" }

  s.platform     = :ios, "10.0"

  s.source       = { :git => "https://github.com/623637646/ExposureKit.git", :tag => "#{s.version}" }

  s.source_files  = "ExposureKit/**/*.{h,m,swift}"

  s.public_header_files = "ExposureKit/Public/**/*.h"

  s.dependency "EasySwiftHook", "~> 3.1.2"

end
