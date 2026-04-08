Pod::Spec.new do |spec|
  spec.name         = "PaintEngine"
  spec.version      = "1.0.0"
  spec.summary      = "C++ Paint Engine for Flutter"
  spec.description  = "Core C++ drawing engine used via FFI."
  spec.homepage     = "http://example.com"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  spec.author       = "Author"
  spec.source       = { :path => "." }
  spec.source_files = "*.{h,hpp,cpp,c,m,mm}"
  spec.public_header_files = "*.{h,hpp}"

  spec.ios.deployment_target = '12.0'
end
