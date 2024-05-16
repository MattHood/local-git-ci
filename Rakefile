require "standard/rake"
require "json"
require "fileutils"

namespace :ci do
  task :default do
    Rake::Task["ci:lint"].invoke
    Rake::Task["ci:test"].invoke
  end

  def working_tree_clean? = `git status --porcelain`.strip.empty?

  def ci_task(name:, command:, success_path:, checked_units_path:)
    return if ENV["SKIP_CI"]
    puts "Running :#{name}..."
    unless working_tree_clean?
      abort "Aborting :#{name} - Working tree must be clean"
    end
    output = `#{command}`
    parsed = JSON.parse(output)
    results = {
      command:,
      hostname: `hostname`,
      is_success: parsed.dig(*success_path) == 0,
      checked_units: parsed.dig(*checked_units_path)
    }
    `git notes --ref 'ref/notes/devtools/ci/#{name}' add --force -m '#{JSON.generate(results)}'`
    unless results[:is_success]
      abort ":#{name} failed, aborting"
    end
  end

  task :lint do
    if ENV["SKIP_CI"]
      next
    end
    puts "Running :lint..."
    unless working_tree_clean?
      abort "Aborting :lint - Working tree must be clean"
    end
    output = `bundle exec standardrb --format json`
    parsed = JSON.parse(output)
    results = {
      command: "bundle exec standardrb --format json",
      hostname: `hostname`,
      is_success: parsed.dig("summary", "offense_count") == 0,
      checked_units: parsed.dig("summary", "inspected_file_count")
    }
    `git notes --ref 'ref/notes/devtools/ci/standardrb' add --force -m '#{JSON.generate(results)}'`
    unless results[:is_success]
      abort ":lint failed, aborting"
    end
  end

  task :test do
    if ENV["SKIP_CI"]
      next
    end
    puts "Running :test..."
    unless working_tree_clean?
      abort "Aborting :test - Working tree must be clean"
    end
    output = `bundle exec rspec --format json`
    parsed = JSON.parse(output)
    results = {
      command: "bundle exec rspec --format json",
      hostname: `hostname`,
      is_success: parsed.dig("summary", "failure_count") == 0,
      checked_units: parsed.dig("summary", "example_count")
    }
    `git notes --ref 'ref/notes/devtools/ci/rspec' add --force -m '#{JSON.generate(results)}'`
    unless results[:is_success]
      abort ":test failed, aborting"
    end
  end

  task :check do
    checks = %w[standardrb rspec]
    results = checks.map do |check|
      note = `git notes --ref 'ref/notes/devtools/ci/#{check}' show`
      JSON.parse(note)
    end
    failures = results.select { _1["is_success"] == false }
    unless failures.empty?
      abort "CI checks failed: #{failures.join(", ")}"
    end
  end
end

GIT_HOOKS = %w[
  applypatch-msg post-update pre-merge-commit pre-receive update
  commit-msg pre-applypatch pre-push prepare-commit-msg
  fsmonitor-watchman pre-commit pre-rebase push-to-checkout
]

namespace :git do
  task :init_hooks do
    GIT_HOOKS.each do |hook|
      File.write(".git/hooks/#{hook}", "#!/bin/sh\nrake git:#{hook.tr("-", "_")}")
      FileUtils.chmod("+x", ".git/hooks/#{hook}")
    end
  end

  GIT_HOOKS.each do |hook|
    task hook.tr("-", "_").to_sym do
    end
  end

  task :pre_commit do
    puts "Running :pre_commit"
  end

  task :pre_push do
    puts "Running :pre_push"
    Rake::Task["ci:lint"].invoke
    Rake::Task["ci:test"].invoke
    Rake::Task["ci:check"].invoke
  end
end
