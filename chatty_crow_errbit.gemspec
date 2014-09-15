$LOAD_PATH.push File.expand_path('../lib', __FILE__)

require 'chatty_crow_errbit/version'

Gem::Specification.new do |s|
  s.name        = 'chatty_crow_errbit'
  s.version     = ChattyCrowErrbit::VERSION
  s.authors     = %w(NetBrick Strnadj)
  s.email       = %w(support@netbrick.cz)
  s.homepage    = 'http://chattycrow.com/'

  s.files = Dir['{app,config,db,lib}/**/*'] +
            ['MIT-LICENSE', 'Rakefile', 'README.textile']
  s.test_files = Dir['test/**/*']
end
