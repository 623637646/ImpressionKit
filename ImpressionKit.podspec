Pod::Spec.new do |s|

  s.name         = "ImpressionKit"
  s.version      = "3.6.1"
  s.summary      = "A tool to analyze impression events for UIView in iOS (exposure of UIView)."

  s.description  = <<-DESC
  					This is a library to analyze impression events for UIView in iOS (exposure of UIView).
                   DESC

  s.homepage     = "https://github.com/623637646/ImpressionKit"

  s.license      = "MIT"

  s.author       = { "Yanni Wang" => "wy19900729@gmail.com" }

  s.platform     = :ios, "11.0"
  
  s.swift_versions = "5"

  s.source       = { :git => "https://github.com/623637646/ImpressionKit.git", :tag => "#{s.version}" }

  s.source_files  = "ImpressionKit/**/*.{swift}"

  s.dependency "EasySwiftHook", "~> 3.3"

end
