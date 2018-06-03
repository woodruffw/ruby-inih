# frozen_string_literal: true

module INIH
  # A generic error in {INIH}.
  class INIHError < RuntimeError
  end

  # Raised whenever parsing fails.
  class ParseError < INIHError
  end
end
