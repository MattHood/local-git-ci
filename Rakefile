require "standard/rake"
require "json"
require "fileutils"

class CITask < Rake::Task
  def needed?
    if ENV["SKIP_CI"] || ENV["SKIP_#{short_name.upcase}"]
      false
    else
      show_note
      $?.exitstatus != 0
    end
  end

  def call(command)
    puts "Running #{name}..."

    result = system(command)
    summary = {
      command:,
      hostname: `hostname`,
      is_success: result
    }

    store_note JSON.generate(summary) if working_tree_clean?
    abort "#{name} failed, aborting" unless summary[:is_success]
  end

  private

  def working_tree_clean? = `git status --porcelain`.strip.empty?

  def store_note(data)
    `git notes --ref 'ref/notes/devtools/ci/#{short_name}' add --force -m '#{data}'`
  end

  def show_note = `git notes --ref 'ref/notes/devtools/ci/#{short_name}' show 2> /dev/null`

  def short_name = name.split(":").last

  class << self
    def define_task(name:, command:)
      super(name) do |ci_task|
        ci_task.call command
      end
    end
  end
end

namespace :ci do
  task :default do
    Rake::Task["ci:lint"].invoke
    Rake::Task["ci:test"].invoke
  end

  CITask.define_task(
    name: :lint,
    command: "bundle exec standardrb"
  )

  CITask.define_task(
    name: :test,
    command: "bundle exec rspec"
  )
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
  end
end
