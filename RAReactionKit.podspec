Pod::Spec.new do |s|
	s.platform     = :ios, '5.0'
	s.name         = "RAReactionKit"
	s.version      = "0.0.2"
	s.summary      = "A short description of RAReactionKit."
	s.homepage     = "http://github.com/evadne/RAReactionKit"
	s.author       = { "Evadne Wu" => "ev@radi.ws" }
	s.source       = { :git => "http://github.com/evadne/RAReactionKit.git", :tag => "0.0.1" }
	s.source_files = 'RAReactionKit', 'Classes/**/*.{h,m}'
	s.framework  = 'Foundation'
	s.requires_arc = true
end
