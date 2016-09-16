platform :ios, '9.0'
use_frameworks!

target 'personality' do

pod 'Bolts'
pod 'FBSDKCoreKit'
pod 'FBSDKShareKit'
pod 'FBSDKLoginKit'
pod 'AWSCognito'
pod 'AWSCore'
pod 'AWSDynamoDB'
pod 'AWSS3'
post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['ONLY_ACTIVE_ARCH'] = 'NO'
            config.build_settings['ENABLE_BITCODE'] = 'NO'
            config.build_settings['SWIFT_VERSION'] = '2.3'
        end
    end
end
end
