Pod::Spec.new do |s|

  s.name         = "ProximitySenseSDK"
  s.version      = "1.2.0"
  s.source       = { :git => "https://github.com/BlueSenseNetworks/iOS.git", :tag => "ProximitySenseSDK-1.2.0" }
  
  s.summary      = "Blue Sense Networks official iOS SDK for integration with the ProximitySense cloud platform."
  s.description  = <<-DESC
                   This is the Blue Sense Networks official iOS SDK for integration with the ProximitySense cloud platform.
                   For more information please visit the Knowledge base section.
                   DESC

  s.homepage     = "http://ProximitySense.com"
  s.license      = { :type => "Copyright", :text => "Copyright 2015 Blue Sense Networks ltd. All rights reserved." }

  s.authors            = { "Vladimir Petrov" => "vlad@bluesensenetworks.com", "Blue Sense Networks" => "contact@bluesensenetworks.com" }

  s.social_media_url   = "http://twitter.com/ProximitySense"

  s.platform     = :ios, "7.0"

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.public_header_files = "SDK/ProximitySenseSDK/**/*.h"
  s.preserve_paths = "SDK/ProximitySenseSDK/**/*.*"
  s.source_files = "SDK/ProximitySenseSDK/**/*.h"
  s.exclude_files = "SDK/ProximitySenseSDK/**/*.m"
  s.vendored_libraries = "SDK/ProximitySenseSDK/lib/libProximitySenseSDK.a"
  s.library = 'ProximitySenseSDK'

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  # s.framework  = "SomeFramework"
  s.frameworks = "UIKit", "Foundation", "CoreLocation"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #

  s.requires_arc = true

end
