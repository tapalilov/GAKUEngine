# encoding: UTF-8
version = File.read(File.expand_path("../GAKU_ENGINE_VERSION",__FILE__)).strip

Gem::Specification.new do |s|
  s.platform     = Gem::Platform::RUBY
  s.name         = 'gaku_engine'
  s.version      = version
  s.summary      = 'GAKU Engine is a student/assignment focused student and school management system'
  s.description  = "It allows for full student management, grading etc. It's bascally what all student grading tools are with some unique features"
  s.required_ruby_version = '>= 1.9.2'

  s.authors      = ['Rei Kagetsuki', 'Nakaya Yukiharu', 'Vassil Kalkov', 'Georgi Tapalilov', 'Radoslav Georgiev', 'Marta Kostova']
  s.email        = 'info@genshin.org'
  s.homepage     = 'http://github.com/Genshin/GAKUEngine'

  s.files        = `git ls-files`.split("\n")
  s.test_files   = `git ls-files -- {spec}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'rails-i18n'
  s.add_dependency 'gaku_core', version
  s.add_dependency 'gaku_admissions', version
  s.add_dependency 'gaku_sample', version
end
