#
# Be sure to run `pod lib lint ROStorageBar.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "ROBarcodeScanner"
s.version          = "2.0.1"
s.summary          = "Scans different Barcodes and returns the result as String"
s.description      = <<-DESC
Scans different Barcodes and returns the result as String. Use the ROBarcodeScannerViewController for the View.
DESC
s.homepage         = "https://github.com/prine/ROBarcodeScanner"
s.screenshots     = "https://raw.githubusercontent.com/prine/ROBarcodeScanner/master/Screenshot.png"
s.license          = 'MIT'
s.author           = { "Robin Oster" => "robin.oster@rascor.com" }
s.source           = { :git => "https://github.com/prine/ROBarcodeScanner.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/prinedev'

s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'Source/**/*'
s.resource_bundles = {
'ROBarcodeScanner' => ['Pod/Assets/*.png']
}

s.resources = ["Source/*.Storyboard"]

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
