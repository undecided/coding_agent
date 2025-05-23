require "ruby_llm/tool"
require_relative "../utils/log"
require_relative "../utils/report_tok_count"

module Tools
  class NewFile < RubyLLM::Tool
    description "Create a new file with specified content."
    param :filepath, desc: "Path to the new file to create."
    param :content, desc: "Content to write to the new file."

    def execute(filepath:, content:)
      begin
        Log.info("Creating file: #{filepath}")
        File.open(filepath, 'w') do |f|
          f.write(content)
        end
        result = { success: true, message: "Successfully created file: #{filepath}" }
        Log.success("Successfully created file: #{filepath}")
        Utils::ReportTokCount.report_tok_count(result)
      rescue => e
        Log.error(e.message)
        Utils::ReportTokCount.report_tok_count({ error: e.message })
      end
    end
  end
end

