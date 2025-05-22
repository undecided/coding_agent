require "ruby_llm/tool"

module Tools
  class NewFile < RubyLLM::Tool
    description "Create a new file with specified content."
    param :filepath, desc: "Path to the new file to create."
    param :content, desc: "Content to write to the new file."

    def execute(filepath:, content:)
      begin
        File.open(filepath, 'w') do |f|
          f.write(content)
        end
        { success: true, message: "Successfully created file: #{filepath}" }
      rescue => e
        { error: e.message }
      end
    end
  end
end

