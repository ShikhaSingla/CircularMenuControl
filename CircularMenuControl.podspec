

Pod::Spec.new do |spec|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  spec.name         = "CircularMenuControl"
  spec.version      = "0.0.1"
  spec.summary      = "A rotating circular menu written in swift 5."
  spec.description  = "The Circular Menu Control is a completely customizable rotational control having menu options."

  spec.homepage     = "http://CircularMenuControl"


  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  spec.license      = "MIT"
  # spec.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  spec.author             = { "ShikhaSingla" => "shikha.singla@trantorinc.com" }
 
  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  # spec.platform     = :ios
  # spec.platform     = :ios, "12.0"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  #spec.source       = { :path => '.' }
  spec.source       = { :git => "https://github.com/ShikhaSingla/CircularMenuControl.git", :tag => "1.0.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  spec.source_files  = "CircularMenuControl", "CircularMenuControl/**/*.{swift}"  


  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #


  spec.resources = "CircularMenuControl/**/*.xcassets"
  spec.resource_bundles = { 'CircularMenuControl' => ['CircularMenuControl/**/*.{png,storyboard}'] }
  
  spec.swift_version = "5.0"


end
