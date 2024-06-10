Pod::Spec.new do |s|

  s.name         = "ImpressionKit"
  s.version      = "3.7.6"
  s.summary      = "A tool to detect impression events for UIView/NSView (exposure of UIView/NSView) in iOS/MacOS."

  s.description  = <<-DESC
  This is a user behavior tracking (UBT) tool to analyze impression events for UIView/NSView (exposure of UIView/NSView) in iOS/MacOS.
                   DESC

  s.homepage     = "https://github.com/623637646/ImpressionKit"

  s.license      = "MIT"

  s.author       = { "Yanni Wang" => "wy19900729@gmail.com" }

  s.platforms = { :ios => "12.0", :osx => "11.0", :watchos => "7.0", :tvos => "9.0" }
  
  s.swift_versions = "5"

  s.source       = { :git => "https://github.com/623637646/ImpressionKit.git", :tag => "#{s.version}" }

  s.source_files  = "ImpressionKit/**/*.{swift}"

  s.dependency "EasySwiftHook", "~> 3.5.2"

end
