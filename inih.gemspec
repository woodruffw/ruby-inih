# frozen_string_literal: true

require_relative "lib/inih"

Gem::Specification.new do |s|
  s.name = "inih"
  s.version = INIH::VERSION
  s.summary = "inih - a Ruby wrapper for a simple C INI parser"
  s.description = "A native library for parsing INI files."
  s.authors = ["William Woodruff"]
  s.email = "william@tuffbizz.com"
  s.files = Dir["LICENSE", "README.md", ".yardopts", "lib/**/*.rb", "ext/**/*.c"]
  s.extensions << "ext/inih/extconf.rb"
  s.homepage = "https://github.com/woodruffw/ruby-ini"
  s.license = "MIT"
end
