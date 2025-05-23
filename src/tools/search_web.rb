require "ruby_llm/tool"
require "duckduckgo"
require_relative "../utils/log"
require_relative "../utils/report_tok_count"

module Tools
  class SearchWeb < RubyLLM::Tool
    description "Search the web using DuckDuckGo and return URLs, titles, and descriptions."
    param :query, desc: "The search query string."

    def execute(query:)
      Log.info("Searching the web for: #{query}")
      results = DuckDuckGo::search(:query => query)

      # Format the results
      formatted_results = results.map do |result|
        {
          uri: result.uri,
          title: result.title,
          description: result.description
        }
      end
      Log.success("Found #{formatted_results.size} results for query: #{query}")
      Utils::ReportTokCount.report_tok_count(formatted_results)
    rescue => e
      Log.error(e.message)
      Utils::ReportTokCount.report_tok_count({ error: e.message })
    end
  end
end
