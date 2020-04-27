# Uncomment the next line to define a global platform for your project
# platform :ios, '13.0'

abstract_target 'STUBase' do
  use_frameworks!
  pod 'SwiftLint'
	
  target 'STU' do
    target 'STUTests' do
      inherit! :search_paths
      pod 'Quick'
      pod 'Nimble'
    end
        
    target 'STUUITests' do
      inherit! :search_paths
      pod 'Quick'
      pod 'Nimble'
    end
  end
    
  target 'STUCore' do
    target 'STUCoreTests' do
      inherit! :search_paths
      pod 'Quick'
      pod 'Nimble'
    end
  end
end


