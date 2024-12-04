#
# Be sure to run `pod lib lint HFLogger.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'HFLogger'
  s.version          = '0.1.1'
  s.summary          = '日志打印'
  s.description      = <<-DESC
日志打印工具
                       DESC
  s.homepage         = 'https://github.com/Components-iOS/HFLogger'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'liuhongfei' => 'hongfei_liu@bizconf.cn' }
  s.source           = { :git => 'git@github.com:Components-iOS/HFLogger.git', :tag => s.version.to_s }
  s.ios.deployment_target = '12.0'
  s.source_files = 'HFLogger/Classes/**/*'
  s.dependency 'SwiftyBeaver', '1.9.5'
  s.requires_arc = true
end
