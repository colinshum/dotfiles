#!/usr/bin/env ruby

module Dotfiles
  ROOT = File.expand_path("~")
  PROJ_DIR = File.expand_path('../../', __FILE__)

  class Support
    class << self
      def queue_task(title, &block)
        @tasks << [title, block]
      end

      def run_tasks
        CLI::UI::StdoutRouter.enable

        @tasks.each do |(title, block)|
          CLI::UI::Frame.open("#{title}") do
            block.call
          end
        end
      end

      def ask(message, options: nil)
        CLI::UI::Prompt.ask(message, options: options)
      end

      def confirm(message)
        CLI::UI::Prompt.confirm(message)
      end
    end
  end
end