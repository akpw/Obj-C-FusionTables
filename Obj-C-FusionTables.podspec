Pod::Spec.new do |s|
  s.name             = "Obj-C-FusionTables"
  s.version          = "2.0.1"

  s.summary          = "Integrates Google Fusion Tables into iOS apps."
  s.description      = <<-DESC
    Obj-C-FusionTables is an easy solution for integrating Google Fusion Tables into iOS apps, built entirely on top of the gtm-oauth2 and gtm-http-fetcher libraries.
   DESC

  s.homepage         = "https://github.com/akpw/Obj-C-FusionTables"
  s.screenshots     = "https://camo.githubusercontent.com/15886e31caf68541ed01631aad2b3e49b2e7c68b/68747470733a2f2f6c68362e676f6f676c6575736572636f6e74656e742e636f6d2f2d3844307a527346794339382f564b6278594b4e497a6f492f41414141414141414641342f396c614f727574647930342f77313135372d683730372d6e6f2f75332e706e67"
  s.license          = 'Apache'
  s.author           = { "Arseniy Kuznetsov" => "k.arseniy@gmail.com" }

  s.source           = {
    :git => "https://github.com/akpw/Obj-C-FusionTables.git",
    :tag => s.version.to_s }
  s.platform     = :ios, '7.0'
  s.requires_arc = true
  s.source_files = 'Obj-C-FusionTablesAPI/**/*'
  s.dependency 'gtm-oauth2', '~> 1.0.126'
end
