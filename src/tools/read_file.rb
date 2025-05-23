require "ruby_llm/tool"
require_relative "../utils/log"
require_relative "../utils/report_tok_count"

module Tools
  class ReadFile < RubyLLM::Tool
    description "Read the contents of a given relative file path. Use this when you want to see what's inside a file. Do not use this with directory names."
    param :path, desc: "The relative path of a file in the working directory."

    def execute(path:)
      Log.info("Reading file: #{path}")
      content = File.read(path)
      Log.success("Read file: #{path}, #{content.length} chars")
      Utils::ReportTokCount.report_tok_count(content)
    rescue => e
      Log.error(e.message)
      Utils::ReportTokCount.report_tok_count({ error: e.message })
    end
  end
end
