require "ruby_llm/tool"

module Tools
  class ReadWebpage < RubyLLM::Tool
    description "Read the contents of a webpage."
    param :url, desc: "The URL to read."

    def execute(url:)
      output_file = "/tmp/extracted_text_#{SecureRandom.hex(6)}.txt"
      $stdout.puts "Reading webpage: #{url}"

      $stdout.puts "Running command: lynx -dump #{url}"
      $stdout.puts "If this fails, make sure lynx is installed!"
      $stdout.puts File.write(output_file, `lynx -dump #{url}`)
      $stdout.puts "Read webpage: #{url}, filesize: #{File.size(output_file)} bytes"

      if $?.success?
        { success: true, message: "Text extracted and saved to: #{output_file}" }
      else
        { error: "Error fetching or processing URL: #{url}" }
      end
    end
  end
end
