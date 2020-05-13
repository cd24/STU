# Uncomment the next line to define a global platform for your project
platform :ios, '13.2'

def testing_pods
  pod 'Quick'
  pod 'Nimble'
end

abstract_target 'STUBase' do
  use_frameworks!
  pod 'SwiftLint'
	
  target 'STU' do
    target 'STUTests' do
      inherit! :search_paths
      testing_pods
    end
        
    target 'STUUITests' do
      inherit! :search_paths
      testing_pods
    end
  end
    
  target 'STUCore' do
    target 'STUCoreTests' do
      inherit! :search_paths
      testing_pods
    end
  end
end


