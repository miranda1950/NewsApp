# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'NewsApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for NewsApp
pod 'Alamofire', '~> 4.8.2'
pod 'Kingfisher', '~> 7.0'

post_install do |installer|
     installer.generated_projects.each do |project|
         project.targets.each do |target|
                target.build_configurations.each do |config|
                    config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '14.0'
    config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
                  end
              end
          end
      end
end
