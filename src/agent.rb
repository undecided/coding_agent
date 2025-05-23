require "ruby_llm"
# Load utils
Dir.glob("./src/utils/*.rb").each { |file| require file }
# Load tools
Dir.glob("./src/tools/*.rb").each { |file| require file }

class RubyLLM::Message
  def summarized! ; @summarized = true ; self ; end
  def summarized? ; @summarized ; end
end

class Agent
  def initialize(system_prompt: nil)
    @chat = RubyLLM.chat(provider: :gemini, assume_model_exists: true)
    @chat.with_instructions system_prompt
    tools_constants = Tools.constants.map { |c| Tools.const_get(c) }
    @chat.with_tools(*tools_constants)
  end

  def run
    Log.line do |l|
      l << l.green("Chat with the agent.")
      l.newline << l.red("Type 'exit' to ... well, exit.")
      l << l.blue("Type 'summary' to see a summary of the conversation")
    end
    loop do
      print "> "
      user_input = gets.chomp
      break if user_input == "exit"
      summary(@chat.messages) && next if user_input == "summary"

      begin
        response = @chat.ask user_input
      rescue RubyLLM::ServerError => e
        Log.line do |l|
          l << l.red("RubyLLM::ServerError caught: #{e.message}")
        end
        sleep(10)
        puts "please continue"
        next
      end
      rewritables = []

      rewritables.unshift(@chat.messages.pop) while @chat.messages&.last && !@chat.messages.last.summarized?

      rewrite_messages(rewritables).each do |m|
        @chat.messages << m.summarized!
      end

      puts response.content
      summary(rewritables)
    end
  end

  def rewrite_messages(q_and_a_arr)
    rewriter = new_rewriter
    q_and_a_arr
      .map { |m| [m, rewriter.ask("Summarize the following interaction from #{m.role} in as few words as possible:\nINTERACTION_START\n#{m.content}\nINTERACTION_END")]}
      .map { |(m, reworked)| RubyLLM::Message.new(m.to_h.merge(reworked.to_h.slice(:content, :input_tokens, :output_tokens))) }
  end

  def new_rewriter
    rewriter = RubyLLM.chat(provider: :gemini, assume_model_exists: true)
    rewriter.with_instructions "You are summarizer. Summarize short. No fluff. Mention file paths and line numbers and edits made where mentioned. Make short and snappy."
    rewriter
  end

  def summary(messages)
    messages.each do |m|
      Log.line do |l|
        l << l.orange(m.role)
        l << l.blue(m.input_tokens)
        l << l.green(m.output_tokens)
        l << m.content
      end
    end
    true
  end
end
