#
# Be sure to run `pod lib lint KYPhotoKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KYPhotoKit'
  s.version          = '2.1'
  s.summary          = 'A simple for system lib photos,and a custom images scanner'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = 'A simple for system lib photos,and a custom images scanner,it just afford some ideas,you still need to do some work before you use it.'

  s.homepage         = 'https://github.com/massyxf/YPhotokit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'massyxf' => 'messy007@163.com' }
  s.source           = { :git => 'https://github.com/massyxf/YPhotokit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

s.source_files = 'KYPhotoKit/Classes/**/*'


#s.subspec 'sources' do |b|
#    b.source_files = 'KYPhotoKit/Classes/sources/**/*'
#end
#
#  s.subspec 'display' do |b|
#      b.dependency 'KYPhoto/sources'
#      b.source_files = 'KYPhotoKit/Classes/display/**/*'
#  end
#
#  s.subspec 'hud' do |b|
#      b.source_files = 'KYPhotoKit/Classes/hud/**/*'
#  end
#
#  s.subspec 'scanner' do |b|
#      b.dependency 'KYPhoto/sources'
#      b.source_files = 'KYPhotoKit/Classes/scanner/**/*'
#  end

  # s.resource_bundles = {
  #   'KYPhotoKit' => ['KYPhotoKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
