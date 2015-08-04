#
# Be sure to run `pod lib lint ROStorageBar.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
s.name             = "ROConcurrency"
s.version          = "1.0.0"
s.summary          = "Simple helper classes which will reduce the complexity for using concurrent methods in Swift."
s.description      = <<-DESC
Simple helper classes which will reduce the complexity for using concurrent methods in Swift. There is a Barrier class, BarrierComplex class and a Synchronized logger which will simplify the concurrent developing process.
DESC
s.homepage         = "https://github.com/prine/ROConcurrency"
s.screenshots     = "https://camo.githubusercontent.com/54ac217836c172791733d1464e805a7401db3dea/687474703a2f2f7072696e652e63682f2f524f53746f726167654261722e706e67", "https://camo.githubusercontent.com/62c5d8ec8583b876d890236c4c6784e1ef54422b/687474703a2f2f7072696e652e63682f2f524f53746f726167654261725f63617074696f6e2e706e67"
s.license          = 'MIT'
s.author           = { "Robin Oster" => "robin.oster@rascor.com" }
s.source           = { :git => "https://github.com/prine/ROConcurrency.git", :tag => s.version.to_s }
s.social_media_url = 'https://twitter.com/prinedev'

s.platform     = :ios, '8.0'
s.requires_arc = true

s.source_files = 'Source/**/*'
s.resource_bundles = {
'ROStorageBar' => ['Pod/Assets/*.png']
}

# s.public_header_files = 'Pod/Classes/**/*.h'
# s.frameworks = 'UIKit', 'MapKit'
# s.dependency 'AFNetworking', '~> 2.3'
end
