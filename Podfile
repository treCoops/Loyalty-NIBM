# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

target 'Loyalty' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Loyalty

  pod 'Alamofire'
  pod 'Kingfisher'
  pod 'SwiftyJSON'
  pod 'SKToast', '~> 1.0.0'
  pod "Connectivity"

  pod 'Firebase/Auth'
  pod 'Firebase/Storage'
  pod 'Firebase/Database'

  target 'LoyaltyTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'LoyaltyUITests' do
    # Pods for testing
  end

post_install do |installer|
     installer.pods_project.targets.each do |target|
         target.build_configurations.each do |config|
             config.build_settings['DEBUG_INFORMATION_FORMAT'] = 'dwarf'
             config.build_settings.delete 'IPHONEOS_DEPLOYMENT_TARGET'
             config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'
         end
     end
  end

end
