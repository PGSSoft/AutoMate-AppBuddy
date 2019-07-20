Pod::Spec.new do |s|
  s.name         = "AutoMate-AppBuddy"
  s.version      = "1.5.1"
  s.summary      = "Helper framework for writing UI automation tests with AutoMate."
  s.homepage     = "https://github.com/PGSSoft/AutoMate-AppBuddy"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }

  s.authors      = {
    "Joanna Bednarz"   => "jbednarz@pgs-soft.com",
    "Bartosz Janda"    => "bjanda@pgs-soft.com"
  }

  s.ios.deployment_target = '9.3'
  s.osx.deployment_target = '10.12'
  s.tvos.deployment_target = '9.2'
  s.swift_versions = ['5.0']

  s.source          = { :git => "https://github.com/PGSSoft/AutoMate-AppBuddy.git", :tag => "#{s.version}" }

  s.source_files    = "Classes", "AutoMate-AppBuddy/**/*.{swift}"

  s.weak_frameworks =  "Contacts", "EventKit"
end
