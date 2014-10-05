$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'chatty_crow_errbit/version'

Gem::Specification.new do |s|
  s.name        = 'chatty_crow_errbit'
  s.version     = ChattyCrowErrbit::VERSION
  s.description = 'Extension for errbit error handler to send messages via ChattyCrow'
  s.summary     = 'Errbit error notification handler'
  s.license     = 'MIT'
  s.files = Dir['{app,config,db,lib}/**/*'] +
            ['MIT-LICENSE', 'Rakefile', 'README.textile']
  s.test_files = Dir['test/**/*']

  s.add_runtime_dependency('chatty_crow', '~> 1.2', '>= 1.2.1')

  s.authors = ['Netbrick s.r.o.']
  s.email   = ['support@netbrick.eu', 'info@chattycrow.com']
  s.homepage = 'http://www.chattycrow.com'

  s.platform = Gem::Platform::RUBY
end
