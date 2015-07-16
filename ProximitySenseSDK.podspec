#
#  Be sure to run `pod spec lint BlueBarSDK.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see http://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |s|

  s.name         = "ProximitySenseSDK"
  s.version      = "1.0.0"
  s.summary      = "Blue Sense Networks official iOS SDK for integration with the ProximitySense cloud platform."

  s.description  = <<-DESC
                   This is the Blue Sense Networks official iOS SDK for integration with the ProximitySense cloud platform.
                   For more information please visit the Knowledge base section.
                   DESC

  s.homepage     = "http://ProximitySense.com"
  s.license      = { :type => "Copyright", :text => "Copyright 2014 Blue Sense Networks ltd. All rights reserved." }

  s.authors            = { "Vladimir Petrov" => "vlad@bluesensenetworks.com", "Blue Sense Networks" => "contact@bluesensenetworks.com" }

  s.social_media_url   = "http://twitter.com/ProximitySense"

  s.platform     = :ios, "7.0"

  #  When using multiple platforms
  # s.ios.deployment_target = "5.0"
  # s.osx.deployment_target = "10.7"


  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Specify the location from where the source should be retrieved.
  #  Supports git, hg, bzr, svn and HTTP.
  #

  s.source       = { :git => "https://github.com/BlueSenseNetworks/iOS.git", :tag => "1.0.0" }


  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  CocoaPods is smart about how it includes source code. For source files
  #  giving a folder will include any h, m, mm, c & cpp files. For header
  #  files it will include any header in the folder.
  #  Not including the public_header_files will make all headers public.
  #

  s.public_header_files = "SDK/ProximitySenseSDK/**/*.h"
  s.preserve_paths = "SDK/ProximitySenseSDK/**/*.*"
  s.source_files = "SDK/ProximitySenseSDK/**/*.h"
  s.vendored_libraries = "SDK/ProximitySenseSDK/lib/libProximitySenseSDK.a"
  s.library = 'ProximitySenseSDK'

  # ――― Resources ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  A list of resources included with the Pod. These are copied into the
  #  target bundle with a build phase script. Anything else will be cleaned.
  #  You can preserve files from being cleaned, please don't preserve
  #  non-essential files like tests, examples and documentation.
  #

  # s.resource  = "icon.png"
  # s.resources = "Resources/*.png"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"


  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  Link your library with frameworks, or libraries. Libraries do not include
  #  the lib prefix of their name.
  #

  # s.framework  = "SomeFramework"
  s.frameworks = "UIKit", "Foundation", "CoreLocation"

  # s.library   = "iconv"
  # s.libraries = "iconv", "xml2"


  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  If your library depends on compiler flags you can set them in the xcconfig hash
  #  where they will only apply to your library. If you depend on other Podspecs
  #  you can include multiple dependencies to ensure it works.

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  # s.dependency "ISO8601DateFormatter", "~> 0.6"

end
