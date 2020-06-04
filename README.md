ruby-inih
=========

![license](https://raster.shields.io/badge/license-MIT%20with%20restrictions-green.png)
[![Gem Version](https://badge.fury.io/rb/inih.svg)](https://badge.fury.io/rb/inih)
[![Build Status](https://img.shields.io/github/workflow/status/woodruffw/ruby-inih/CI/master)](https://github.com/woodruffw/ruby-inih/actions?query=workflow%3ACI)

A Ruby wrapper for [inih](https://github.com/benhoyt/inih), a simple INI parser.

### Installation

```bash
$ gem install inih
```

### Example

Given the following INI data:

```ini
; example.ini
[example]
foo=bar
baz = quux
integer = 10
float = 3.14
bool = true
```

```ruby
# load directly from a file
INIH.load "example.ini"
# => {"example"=>{"foo"=>"bar", "baz"=>"quux", "integer"=>10, "float"=>3.14, "bool"=>true}}

# parse from a string
INIH.parse "[section]\nkey=value"
#=> {"section"=>{"key"=>"value"}}
```

Integers, floating-point numbers, and booleans are coerced into their respective Ruby types by
default, **unless** `normalize: false` is passed to either method.

### TODO

* Coerce scientific notation?

### License

inih itself is licensed under the BSD License.

For the exact terms, see the [LICENSE](ext/inih/LICENSE) file.

ruby-inih is licensed under the MIT License.

For the exact terms, see the [LICENSE](./LICENSE) file.
