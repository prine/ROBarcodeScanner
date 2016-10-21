#
# Be sure to run `pod lib lint ROStorageBar.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#


Pod::Spec.new do |spec|
    spec.name         = 'ROBarcodeScanner'
    spec.version      = '2.1.0'
    spec.license      = { :type => 'MIT' }
    spec.homepage     = 'https://github.com/prine/ROBarcodeScanner'
    spec.authors      = { 'Robin Oster' => 'robin.oster@rascor.com' }
    spec.summary      = 'Scans different Barcodes and returns the result as String'
    spec.source       = { :git => 'https://github.com/prine/ROBarcodeScanner.git', :tag => "2.1.0" }
    spec.source_files = 'Source/*.swift'
    spec.framework    = 'SystemConfiguration'
    spec.ios.framework  = 'UIKit'
    spec.ios.deployment_target  = '8.4'
    spec.resources = ['Source/*.Storyboard']
end
