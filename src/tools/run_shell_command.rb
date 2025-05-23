require "ruby_llm/tool"
require_relative "../utils/log"
require_relative "../utils/report_tok_count"

module Tools
  class RunShellCommand < RubyLLM::Tool
    description "Execute a linux shell command"
    param :command, desc: "The command to execute"

    def execute(command:)
      Log.info("Shell command requested: '#{command}'")
      print "Do you want to execute it? (y/n) "
      response = gets.chomp
      unless response == "y"
        Log.warning("User declined to execute the command")
        Utils::ReportTokCount.report_tok_count({ error: "User declined to execute the command" })
        return { error: "User declined to execute the command" }
      end

      output = `#{command}`
      Log.success("Shell command executed successfully")
      Utils::ReportTokCount.report_tok_count(output)
      output
    rescue => e
      Log.error(e.message)
      Utils::ReportTokCount.report_tok_count({ error: e.message })
      { error: e.message }
    end
  end
end
