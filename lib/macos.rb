#!/usr/bin/env ruby

require_relative 'load'
require 'fileutils'

module Dotfiles
  class MacOS < Support
    class << self
      def run
        @tasks = []

        queue_task("Homebrew") { homebrew }
        queue_task("Casks and Brews") { brew_install }
        queue_task("Generate SSH Keys") { ssh_gen }
        queue_task("Set macOS Defaults") { macos_defaults }
        queue_task("ZSH") { zsh }
        queue_task("App Preferences") { app_prefs }
        queue_task("Symlink Dotfiles") { dotfiles_symlink }
        queue_task("Wrapping Up") { cleanup }

        CLI::UI::StdoutRouter.enable
        run_tasks
      end

      private

      def homebrew
        if `which brew`
          sg = CLI::UI::SpinGroup.new

          sg.add("Updating Homebrew") do |spinner|
            system("brew update >/dev/null")
          end

          sg.wait
        else
          if confirm("Do you want to install Homebrew?")
            sg = CLI::UI::SpinGroup.new

            sg.add("Installing Homebrew") do |spinner|
              `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"`
            end

            sg.wait
          else
            puts CLI::UI.fmt "{{x}} Skipping Homebrew."
          end
        end
      end

      def brew_install
        if `which brew`
          if confirm("Do you want to install casks and brews?")
            Dir.chdir(Dotfiles::PROJ_DIR) do
              sg = CLI::UI::SpinGroup.new
              output = ""

              sg.add("Verifying Brewfile") do |spinner|
                output = `brew bundle check`

                if !output.include?("are satisfied")
                  `brew bundle install`
                end
              end

              sg.wait
            end
          else
            puts CLI::UI.fmt "{{x}} Skipping casks and brews."
          end
        else
          puts CLI::UI.fmt "{{x}} Homebrew is not installed. Skipping installation."
        end
      end

      def ssh_gen
        if confirm("Do you want to set up SSH keys?")
          email = ask("Enter the email to be associated with this SSH key. (Hint: If you have private emails enabled on GitHub, enter your @users.noreply.github.com email)")
          system("ssh-keygen -t rsa -b 4096 -C \"#{email}\" -f ~/.ssh/id_rsa -q")
          system("pbcopy < ~/.ssh/id_rsa.pub")

          puts CLI::UI.fmt "{{v}} SSH key has been copied to clipboard. Opening GitHub in your browser to complete setup."
          sleep(2)
          system('open https://github.com/settings/ssh/new')
          system('eval "$(ssh-agent -s)"')
        else
          puts CLI::UI.fmt "{{x}} Skipping SSH keys."
        end
      end

      def macos_defaults
        Dir.chdir(Dotfiles::PROJ_DIR) do
          sg = CLI::UI::SpinGroup.new

          sg.add("Setting macOS defaults") do |spinner|
            system("zsh ./bin/defaults.sh")
          end

          sg.wait
        end
      end

      def zsh
        Dir.chdir(Dotfiles::PROJ_DIR) do
          sg = CLI::UI::SpinGroup.new

          sg.add("Installing Oh My ZSH") do |spinner|
            output = `zsh ./config/apps/zsh/zsh.sh`
          end

          sg.wait
        end
      end

      def app_prefs
        Dir.chdir(Dotfiles::PROJ_DIR) do
          sg = CLI::UI::SpinGroup.new

          sg.add("Setting up VSCode") do |spinner|
            output = `zsh ./config/apps/vscode/vscode.sh`
          end

          sg.add("Setting up iTerm") do |spinner|
            output = `zsh ./config/apps/iterm/iterm.sh`
          end

          sg.wait
        end
      end

      def dotfiles_symlink
        dotfiles = %w(aliases zshrc zshenv)

        dotfiles.each do |file|
          src = "#{Dotfiles::PROJ_DIR}/config/.#{file}"
          dest = "#{Dotfiles::ROOT}/.#{file}"
          FileUtils.ln_s(src, dest, force: true)

          puts CLI::UI.fmt "{{v}} Symlinked #{src} to #{dest}"
        end
      end

      def cleanup
        puts CLI::UI.fmt "{{v}} Please restart your terminal session to finish installation."
        puts CLI::UI.fmt "{{*}} Opening iTerm..."
        sleep(2)
        `osascript -e 'tell application "iTerm" to activate'`
      end
    end
  end

  Dotfiles::MacOS.run
end