# frozen_string_literal: true

require_relative "../ext/inih/inih"

# The primary namespace for {INIH}.
module INIH
  # The current version of ruby-inih.
  VERSION = "1.0.0"

  # Normalize a parsed INI file's values.
  # @api private
  def self.normalize(hsh)
    hsh.map do |k, sect|
      [k, normalize_sect(sect)]
    end.to_h
  end

  # Normalize the values in a section of a parsed INI file.
  # @api private
  def self.normalize_sect(sect)
    sect.map do |k, v|
      nv = case v
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
