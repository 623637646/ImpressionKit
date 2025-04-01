Pod::Spec.new do |s|

  s.name         = "ImpressionKit"
  s.version      = "3.7.7"
  s.summary      = "A tool to detect impression events for UIView (exposure of UIView) in iOS."

  s.description  = <<-DESC
  This is a user behavior tracking (UBT) tool to analyze impression events for UIView (exposure of UIView) in iOS.
                   DESC

  s.homepage     = "https://github.com/623637646/ImpressionKit"

  s.license      = "MIT"

  s.author       = { "Yanni Wang" => "wy19900729@gmail.com" }

  s.platform     = :ios, "12.0"
  
  s.swift_versions = "5"

  s.source       = { :git => "https://github.com/623637646/ImpressionKit.git", :tag => "#{s.version}" }

  s.source_files  = "ImpressionKit/**/*.{swift}"

  s.dependency "EasySwiftHook", "~> 3.5.3"

end
