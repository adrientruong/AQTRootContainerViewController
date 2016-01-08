Pod::Spec.new do |s|
  s.name     = 'AQTRootContainerViewController'
  s.version  = '1.0.0'
  s.license  = 'MIT'
  s.summary  = 'A container view controller to animate swapping root view controllers'
  s.homepage = 'https://github.com/adrientruong/AQTRootContainerViewController'
  s.authors  = { 'Adrien Truong' => 'adrien.truong@me.com' }
  s.source   = { :git => 'https://github.com/adrientruong/AQTRootContainerViewController.git', :tag => s.version }
  s.requires_arc = true
  s.source_files = 'AQTRootContainerViewController/AQTRootContainerViewController.{h,m}'
  s.ios.deployment_target = '8.0'
end
