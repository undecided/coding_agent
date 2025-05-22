require "ruby_llm/tool"
require "duckduckgo"

module Tools
  class SearchWeb < RubyLLM::Tool
    description "Search the web using DuckDuckGo and return URLs, titles, and descriptions."
    param :query, desc: "The search query string."

    def execute(query:)
      STDOUT.puts "Searching the web for: #{query}"
      results = DuckDuckGo::search(:query => query)

      # Format the results
      formatted_results = results.map do |result|
        {
          uri: result.uri,
          title: result.title,
          description: result.description
        }
      end

      formatted_results
    rescue => e
      { error: e.message }
    end
  end
end
