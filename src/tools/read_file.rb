require "ruby_llm/tool"

module Tools
  class ReadFile < RubyLLM::Tool
    description "Read the contents of a given relative file path. Use this when you want to see what's inside a file. Do not use this with directory names."
    param :path, desc: "The relative path of a file in the working directory."

    def execute(path:)
      STDOUT.puts "Reading file: #{path}"
      File.read(path).tap { |content| $stdout.puts "File content: #{content.length} chars" }
    rescue => e
      { error: e.message }
    end
  end
end
