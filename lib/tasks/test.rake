    if Rails.env.test? || Rails.env.development?
      require 'rspec/core/rake_task'
      require 'cucumber/rake/task'

      task test: [:spec, :cucumber]
    end
