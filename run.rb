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

# List available profiles
profiles_dir = File.join(__dir__, "profiles")
profile_files = Dir.glob(File.join(profiles_dir, "*.txt")).reject { |f| File.basename(f) == "base.txt" }.sort

puts "Available profiles:"
profile_files.each_with_index do |file, index|
  puts "#{index + 1}. #{File.basename(file, ".txt")}"
end

# Get user selection
selected_profile_index = nil
while selected_profile_index.nil?
  print "Enter the number of the profile you want to use: "
  input = gets.chomp
  index = input.to_i - 1
  if index >= 0 && index < profile_files.length
    selected_profile_index = index
  else
    puts "Invalid selection. Please try again."
  end
end

# Read selected profile content
selected_profile_path = profile_files[selected_profile_index]
system_prompt = File.read(selected_profile_path)

# Read base profile content and append it
base_profile_path = File.join(__dir__, "profiles", "base.txt")
base_prompt = File.read(base_profile_path)
system_prompt += "\n" + base_prompt # Add a newline for separation

# Initialize and run the agent with the selected system prompt
Agent.new(system_prompt: system_prompt).run

