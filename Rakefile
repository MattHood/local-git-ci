require "standard/rake"
require "json"
require "debug"

task :lint do
  output = `bundle exec standardrb --format json`
  git_result = `git notes --ref 'ref/notes/devtools/ci/rspec' add --force -m '#{output}'`
  puts JSON.parse(output)
  puts git_result
end

task :test do
  output = `bundle exec rspec --format json`
  git_result = `git notes --ref 'ref/notes/devtools/ci/rspec' add --force -m '#{output}'`
  puts JSON.parse(output)
  puts git_result
end
