source 'https://github.com/CocoaPods/Specs.git'
source 'http://git.garena.com/ios-dev/btlibrary.git'
source 'https://git.garena.com/shopee/ios/shopee-specs-library.git'

inhibit_all_warnings!
platform :ios, '8.0'

target 'SHPExposure' do
  pod 'Aspects', '1.4.1'
  pod 'SHPUtilityKit', '0.0.14'
end

post_install do |installer|
	installer.pods_project.targets.each do |target|
		target.build_configurations.each do |config|
			if config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'].to_f < 8.0
				config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
			end
		end
	end
end
