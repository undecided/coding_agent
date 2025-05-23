# frozen_string_literal: true
require 'json'

module Utils
  # Estimates token count of a string or JSON object and logs it
  module ReportTokCount
    # Estimate 1.5 tokens per word (default). Returns the original object.
    def self.report_tok_count(obj, tokens_per_word: 1.5)
      text =
        case obj
        when String
          obj
        when Hash, Array
          JSON.generate(obj)
        else
          obj.to_s
        end
      word_count = text.split(/\s+/).size
      token_count = (word_count * tokens_per_word).ceil
      Log.info("Replying with ~#{token_count} tokens")
      obj
    end
  end
end
