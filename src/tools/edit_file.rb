require "ruby_llm/tool"
require_relative "../utils/log"
require_relative "../utils/report_tok_count"

module Tools
  class EditFile < RubyLLM::Tool
    description <<~DESCRIPTION
      Make edits to a text file.

      Replaces 'old_str' with 'new_str' in the given file.
      'old_str' and 'new_str' MUST be different from each other.

      If the file specified with path doesn't exist, it will be created.
    DESCRIPTION
    param :path, desc: "The path to the file"
    param :old_str, desc: "Text to search for - must match exactly and must only have one match exactly"
    param :new_str, desc: "Text to replace old_str with"

    def execute(path:, old_str:, new_str:)
      old_lines = old_str.lines
      new_lines = new_str.lines
      removed = old_lines.size
      added = new_lines.size
      removed_str = "#{Log.red("-#{removed}")}"
      added_str = "#{Log.green("+#{added}")}"
      Log.info("Editing file: #{path} (lines #{removed_str} #{added_str})")
      content = File.exist?(path) ? File.read(path) : ""
      File.write(path, content.sub(old_str, new_str))
      result = { success: true, message: "Edited file: #{path}" }
      Log.success("Edit complete for file: #{path}")
      Utils::ReportTokCount.report_tok_count(result)
    rescue => e
      Log.error(e.message)
      Utils::ReportTokCount.report_tok_count({ error: e.message })
    end
  end
end
