#
# Be sure to run `pod lib lint JMMessageInput.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JMMessageInput'
  s.version          = '0.1.0'
  s.summary          = 'Yet another mobile chat input field'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
Adds a messanger like input. You have all seen how this works.
                       DESC

  s.homepage         = 'https://github.com/staeblorette/JMMessageInput'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'staeblorette' => 'martin.staehler@gmail.com' }
  s.source           = { :git => 'https://github.com/staeblorette/JMMessageInput.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '10.0'

  s.source_files = 'JMMessageInput/Classes/**/*'
  
  # s.resource_bundles = {
  #   'JMMessageInput' => ['JMMessageInput/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
	s.frameworks = 'UIKit', 'JMContainerControllers'
	s.dependency 'JMContainerControllers'
end
