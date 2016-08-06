use_frameworks!
pod 'Bolts'
pod 'FBSDKCoreKit', '~>4.12.0'
pod 'FBSDKShareKit', '~>4.12.0'
pod 'FBSDKLoginKit', '~>4.12.0'
pod 'AWSCognito', '~> 2.3.6'
pod 'AWSCore', '~> 2.3.6'
pod 'AWSDynamoDB', '~> 2.3.6'
pod 'AWSS3', '~> 2.3.6'
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
        end
    end
end

