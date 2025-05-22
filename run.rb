#!/usr/bin/env ruby

# Load the gems and environment variables from .env file.
Dir.chdir(__dir__) do
  require "bundler/setup"
  require "dotenv/load"
end

require "ruby_llm"
require_relative "src/agent"

RubyLLM.configure do |config|
  config.gemini_api_key = ENV.fetch("GEMINI_API_KEY", nil)
  config.default_model = "gemini-2.5-flash-preview-04-17"
end

Agent.new.run
