#
#  Be sure to run `pod spec lint QRScannerModule.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://docs.cocoapods.org/specification.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name           = 'QRScannerModule'
  spec.version        = '0.0.1'
  spec.summary        = 'A short description of QRScannerModule.'
  spec.description    = <<-DESC
  QRScanner Module
  DESC

  spec.homepage       = 'https://ibuldapp.com'
  spec.license        = 'COMMERCIAL'
  spec.author         = { 'Vitaly Potlov' => 'vitaly.potlov@icloud.com' }
  spec.platform       = :ios, '10.0'
  spec.source         = { :git => 'git@gitlab.vladimir.ibuildapp.com:ios/qrscannerwidget.git', :tag => '#{spec.version}' }
  spec.source_files   = 'Source/*.swift', 'Source/**/*.swift'
  spec.frameworks     = 'UIKit', 'Foundation'
  spec.dependency       'IBACore'
  spec.dependency       'IBACoreUI'

end
