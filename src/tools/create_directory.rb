# src/tools/create_directory.rb
require "ruby_llm/tool"
require_relative "../utils/log" # Assuming this exists
require 'shellwords'
require 'open3' # Using Open3 for better command execution control

module Tools
  class CreateDirectory < RubyLLM::Tool
    description <<~DESCRIPTION
      Creates a new directory, including any necessary parent directories.
      Does not raise an error if the directory already exists.
    DESCRIPTION
    param :path, desc: "The path for the new directory."

    def execute(path:)
      Log.info("Attempting to create directory: #{path}")

      escaped_path = Shellwords.escape(path)

      # Use mkdir -p to create parent directories and avoid errors if it exists
      command = "mkdir -p #{escaped_path}"
      Log.info("Executing command: #{command}")

      begin
        # Use Open3.capture3 to get stdout, stderr, and exit status
        stdout, stderr, status = Open3.capture3(command)

        if status.exitstatus == 0
          # mkdir -p doesn't typically output on success, but check stderr for potential warnings
          if stderr.strip.empty?
            # We can't definitively know if it was created or already existed from mkdir -p alone
            # but a status of 0 means the desired state (directory exists) is achieved.
            Log.success("Directory '#{path}' ensured.")
            return { success: true, message: "Directory '#{path}' created or already exists." }
          else
            # Handle potential warnings output to stderr by mkdir -p
            Log.warn("Command finished with warnings for directory '#{path}'. Stderr: #{stderr.strip}")
            return { success: true, message: "Directory '#{path}' ensured with warnings: #{stderr.strip}" }
          end
        else
          # Error occurred (exit status > 0)
          Log.error("Command failed with status #{status.exitstatus}. Stderr: #{stderr.strip}")
          return { success: false, error: stderr.strip }
        end

      rescue Errno::ENOENT => e
        # Handle case where the command (mkdir) is not found - highly unlikely on a standard system
        Log.error("Command not found: #{e.message}")
        return { success: false, error: "Shell command not found. Is mkdir installed?" }
      rescue => e
        # Handle any other unexpected errors
        Log.error("An unexpected error occurred: #{e.message}")
        return { success: false, error: "An unexpected error occurred: #{e.message}" }
      end
    end
  end
end
