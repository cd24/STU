# Uncomment the next line to define a global platform for your project
platform :ios, '13.0'

abstract_target 'STUBase' do
    use_frameworks!
	pod 'SwiftLint'
	
    target 'STU' do
    end
    
    target 'STUCore' do
    end
    
    abstract_target "STUTestBase" do
        use_frameworks!
        pod 'Quick'
        pod 'Nimble'
        
        target 'STUCoreTests' do
          inherit! :search_paths
        end
        
        target 'STUTests' do
          inherit! :search_paths
        end
        
        target 'STUUITests' do
        end
    end
end


