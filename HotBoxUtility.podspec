#
# Be sure to run `pod lib lint HotBoxUtility.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HotBoxUtility'
  s.version          = '0.1.0'
  s.summary          = 'A short description of HotBoxUtility.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/chenzq1019/HotBoxUtility'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'chen zhuqing' => 'chenzq1019@163.com' }
  s.source           = { :git => 'https://github.com/chenzq1019/HotBoxUtility.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

#  s.source_files = 'HotBoxUtility/Classes/**/*'
  
  # s.resource_bundles = {
  #   'HotBoxUtility' => ['HotBoxUtility/Assets/*.png']
  # }
  s.requires_arc = true
  s.exclude_files = "HotBoxUtility/Exclude"
  s.resources = "HotBoxUtility/Assets/Resources/*.png"
  s.subspec 'Category' do |ss|
      ss.source_files = 'HotBoxUtility/Classes/Category/*.{h,m}'
      ss.public_header_files = 'HotBoxUtility/Classes/Category/*.h'
  end
  s.subspec 'UIKit' do |ss|
      ss.source_files = 'HotBoxUtility/Classes/UIKit/*.{h,m}'
      ss.public_header_files = 'HotBoxUtility/Classes/UIKit/*.h'
      ss.dependency "HotBoxUtility/Category"
      ss.dependency 'MBProgressHUD'
  end
  s.subspec 'Tools' do |ss|
      ss.source_files = 'HotBoxUtility/Classes/Tools/*.{h,m}'
      ss.public_header_files = 'HotBoxUtility/Classes/Tools/*.h'
      ss.dependency 'HotBoxUtility/Category'
  end
  s.frameworks = 'UIKit'
  s.dependency "MBProgressHUD"
  s.dependency 'SDWebImage'
end
