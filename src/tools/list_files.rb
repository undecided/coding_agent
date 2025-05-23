require "ruby_llm/tool"
require_relative "../utils/log"
require_relative "../utils/report_tok_count"

module Tools
  class ListFiles < RubyLLM::Tool
    description "List files and directories at a given path. If no path is provided, lists files in the current directory."
    param :path, desc: "Optional relative path to list files from. Defaults to current directory if not provided."

    def execute(path: "")
      Log.info("Listing files in directory: #{path}")
      files = Dir.glob(File.join(path, "*"))
         .map { |filename| File.directory?(filename) ? "#{filename}/" : filename }
      Log.success("Found #{files.size} entries in #{path}")
      Utils::ReportTokCount.report_tok_count(files)
    rescue => e
      Log.error(e.message)
      Utils::ReportTokCount.report_tok_count({ error: e.message })
    end
  end
end
