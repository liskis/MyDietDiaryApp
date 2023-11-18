# Uncomment the next line to define a global platform for your project
platform :ios, '16.0'

post_install do |installer|
  installer.pods_project.targets.each do |target|
    if target.name == 'Realm'
      create_symlink_phase = target.shell_script_build_phases.find { |x| x.name == 'Create Symlinks to Header Folders' }
      create_symlink_phase.always_out_of_date = "1"
    end
  end
  installer.generated_projects.each do |project|
    project.targets.each do |target|
      target.build_configurations.each do |config|
        config.build_settings['IPHONEOS_DEPLOYMENT_TARGET'] = '16.0'
      end
   end
  end
end

target 'MyDietDiaryApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  pod 'FSCalendar'
  pod 'RealmSwift'
  pod 'DGCharts'

  # Pods for MyDietDiaryApp

  target 'MyDietDiaryAppTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'MyDietDiaryAppUITests' do
    # Pods for testing
  end

end








