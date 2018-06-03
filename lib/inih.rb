# frozen_string_literal: true

require_relative "inih/exceptions"
require_relative "ext/inih"

# The primary namespace for {INIH}.
module INIH
  module_function

  # The current version of ruby-inih.
  VERSION = "2.0.0"

  # Parse an INI-formatted string into a Hash.
  # @param string [String] the INI-formatted string to parse
  # @param normalize [Boolean] whether or not to normalize the types of parsed values
  # @return [Hash] the parsed hash
  # @raise [INIH::ParseError] if a parse error occurs
  def parse(string, normalize: true)
    parse_intern string, normalize
  end

  # Parse an INI-formatted file into a Hash.
  # @param filename [String] the INI-formatted file to parse
  # @param normalize [Boolean] whether or not to normalize the types of parsed values
  # @return [Hash] the resulting hash
  # @raise [INIH::ParseError] if a parse error occurs
  # @raise [IOError] if an I/O error occurs
  def load(filename, normalize: true)
    load_intern filename, normalize
  end

  # Normalize a parsed INI file's values.
  # @api private
  def normalize_hash(hsh)
    hsh.map do |k, sect|
      [k, normalize_sect(sect)]
    end.to_h
  end

  # Normalize the values in a section of a parsed INI file.
  # @api private
  def normalize_sect(sect)
    sect.map do |k, v|
      nv = case v
           when "" then nil
           when "true" then true
           when "false" then false
           when /\A-?\d+\Z/ then Integer v
           when /\A-?\d+\.\d+\Z/ then Float v
           else v
           end

      [k, nv]
    end.to_h
  end
end
