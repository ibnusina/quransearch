platform :ios, '15.0'

target 'QuranSearch' do
  use_frameworks!
  pod 'RealmSwift', '10.8.0'
  pod 'FirebaseRemoteConfig'
end

post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '15.0'
    end
  end
end