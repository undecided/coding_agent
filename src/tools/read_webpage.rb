require "ruby_llm/tool"
require_relative "../utils/log"
require_relative "../utils/report_tok_count"

module Tools
  class ReadWebpage < RubyLLM::Tool
    description "Read the contents of a webpage."
    param :url, desc: "The URL to read."

    def execute(url:)
      Log.info("Reading webpage: #{url}")
      tmp = ENV.fetch('TMPDIR', '/tmp')
      output_file = "#{tmp}/extracted_text_#{SecureRandom.hex(6)}.txt"
      Log.info("Running command: lynx -dump #{url}")
      Log.info("If this fails, make sure lynx is installed!")
      File.write(output_file, `lynx -dump #{url}`)
      Log.success("Read webpage: #{url}, filesize: #{File.size(output_file)} bytes")

      if $?.success?
        result = { success: true, message: "Text extracted and saved to: #{output_file}" }
        Log.success("Text extracted and saved to: #{output_file}")
        Utils::ReportTokCount.report_tok_count(result)
      else
        Log.error("Error fetching or processing URL: #{url}")
        Utils::ReportTokCount.report_tok_count({ error: "Error fetching or processing URL: #{url}" })
      end
    end
  end
end
