Pod::Spec.new do |s|
  s.name         = "LFSCoreData"
  s.version      = "1.0.8"
  s.summary      = "Core Data Wrapper for building core data transparent to developer."
  s.homepage     = "https://github.com/lafosca/LFSCoreData"

  s.author       = { "David Cortés" => "david@lafosca.cat" }
   s.license      = { :type => 'All rights reserved'}
  s.source       = { 
    :git => "https://github.com/lafosca/LFSCoreData.git", 
    :tag => "1.0.8"
  }

  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.source_files = 'LFSCoreData/*.{h,m}'
  s.requires_arc = true
  s.framework    = 'CoreData'
end
