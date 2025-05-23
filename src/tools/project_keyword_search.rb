# src/tools/project_keyword_search.rb
require "ruby_llm/tool"
require 'shellwords'
require 'open3' # Using Open3 for better command execution control

module Tools
  class ProjectKeywordSearch < RubyLLM::Tool
    description <<~DESCRIPTION
      Searches for a keyword or pattern within the content of files in the project or a specified subdirectory.
      Reports file paths and line numbers where matches are found.
    DESCRIPTION
    param :keyword, desc: "The keyword or pattern to search for."
    param :directory, desc: "Optional: The directory to search within. Defaults to the project root."

    def execute(keyword:, directory: ".")
      Log.info("Searching for keyword '#{keyword}' in directory '#{directory}'")

      escaped_keyword = Shellwords.escape(keyword)
      escaped_directory = Shellwords.escape(directory)

      # Use grep -RnH for recursive search, line numbers, and no color
      # --colour=never ensures clean output for parsing
      command = "grep -RnH --colour=never #{escaped_keyword} #{escaped_directory}"
      Log.info("Executing command: #{command}")

      begin
        # Use Open3.capture3 to get stdout, stderr, and exit status
        stdout, stderr, status = Open3.capture3(command)
        Log.info("Command output length: #{stdout.length}")

        if status.exitstatus == 0 # Matches found
          results = []
          stdout.each_line do |line|
            line = line.strip
            next if line.empty?

            # Expected grep -H format: filepath:line_number:matching_line
            # Split only on the first two colons to preserve colons in the match itself
            parts = line.split(':', 3)
            if parts.length == 3
              filepath = parts[0]
              line_number = parts[1].to_i
              match = parts[2]
              results << { filepath: filepath, line_number: line_number, match: match }
            else
              Log.warn("Could not parse grep output line: #{line}")
            end
          end
          Log.success("Found #{results.size} matches.")
          # Return a hash with a success flag and the results
          return { success: true, results: results }
        elsif status.exitstatus == 1 # No matches found
          Log.info("No matches found for keyword '#{keyword}' in directory '#{directory}'.")
          # Return success true with an empty results array
          return { success: true, results: [] }
        else # Error occurred (exit status > 1)
          Log.error("Command failed with status #{status.exitstatus}. Stderr: #{stderr.strip}")
          # Return success false and the error message
          return { success: false, error: stderr.strip }
        end

      rescue Errno::ENOENT => e
        # Handle case where the command (grep) is not found
        Log.error("Command not found: #{e.message}")
        return { success: false, error: "Shell command not found. Is grep installed?" }
      rescue => e
        # Handle any other unexpected errors
        Log.error("An unexpected error occurred: #{e.message}")
        return { success: false, error: "An unexpected error occurred: #{e.message}" }
      end
    end
  end
end
