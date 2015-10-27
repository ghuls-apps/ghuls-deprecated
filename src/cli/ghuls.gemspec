Gem::Specification.new do |s|
  s.name = 'ghuls'
  s.version = '1.0.0'
  s.required_ruby_version = '>= 2.0'
  s.authors = ['Eli Foster']
  s.description = 'Getting GitHub repository language data by user!'
  s.email = 'elifosterwy@gmail.com'
  s.files = [
    'lib/ghuls.rb',
    'lib/ghuls/cli.rb',
    'bin/ghuls'
  ]
  s.executables = 'bin/ghuls'
  s.homepage = 'http://github.com/elifoster/ghuls'
  s.summary = 'GHULS: GitHub User Language Statistics'
  s.add_runtime_dependency('octokit')
  s.add_runtime_dependency('require_all')
end
