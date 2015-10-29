Gem::Specification.new do |s|
  s.name = 'ghuls'
  s.version = '1.0.0'
  s.required_ruby_version = '>= 2.0'
  s.authors = ['Eli Foster']
  s.description = 'Getting GitHub repository language data by user! It also ' \
                  'has a web alternative at http://ghuls.herokuapp.com!'
  s.email = 'elifosterwy@gmail.com'
  s.files = [
    'cli/lib/ghuls.rb',
    'cli/lib/ghuls/cli.rb',
    'cli/bin/ghuls',
    'utils/utilities.rb'
  ]
  s.executables = 'bin/ghuls'
  s.homepage = 'http://ghuls.herokuapp.com'
  s.summary = 'GHULS: GitHub User Language Statistics'
  s.add_runtime_dependency('octokit')
  s.add_runtime_dependency('rainbow')
  s.add_runtime_dependency('string-utility')
end
