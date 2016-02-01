Pod::Spec.new do |s|
  s.name             = "Obj-C-FusionTables"
  s.version          = "2.0.2"

  s.summary          = "Integrates Google Fusion Tables into iOS apps."
  s.description      = <<-DESC
    Obj-C-FusionTables is an easy solution for integrating Google Fusion Tables into iOS apps, built on top of the Google gtm-oauth2 and gtm-http-fetcher libraries.
   DESC

  s.homepage         = "https://github.com/akpw/Obj-C-FusionTables"
  s.screenshots      = "https://goo.gl/3kI3uk"
  s.license          = 'Apache'
  s.author           = { "Arseniy Kuznetsov" => "k.arseniy@gmail.com" }

  s.source           = {
    :git => "https://github.com/akpw/Obj-C-FusionTables.git",
    :tag => s.version.to_s }
  s.platform        = :ios, '8.0'
  s.requires_arc    = true
  s.source_files    = 'Source/**/*'
  s.dependency 'gtm-oauth2', '~> 1.0.126'
end
