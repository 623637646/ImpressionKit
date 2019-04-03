inhibit_all_warnings!
platform :ios, '8.0'

target 'YNExposure' do
  pod 'Aspects', '1.4.1'
end

post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '8.0'
        end
    end
end
