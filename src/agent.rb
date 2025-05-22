require "ruby_llm"
# Load tools
Dir.glob("./src/tools/*.rb").each { |file| require file }

class Agent
  def initialize
    @chat = RubyLLM.chat(provider: :gemini, assume_model_exists: true)
    tools_constants = Tools.constants.map { |c| Tools.const_get(c) }
    @chat.with_tools(*tools_constants)
  end

  def run
    puts "Chat with the agent. Type 'exit' to ... well, exit"
    loop do
      print "> "
      user_input = gets.chomp
      break if user_input == "exit"

      response = @chat.ask user_input
      puts response.content
    end
  end
end
