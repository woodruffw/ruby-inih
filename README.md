ruby-inih
=========

[![Gem Version](https://badge.fury.io/rb/inih.svg)](https://badge.fury.io/rb/inih)

A Ruby wrapper for [inih](https://github.com/benhoyt/inih), a simple INI parser.

### Installation

```ruby
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

Integers, floating-point numbers, and booleans are coerced into their respective Ruby types.

### TODO

* Unit tests
* Coerce scientific-notation?

### License

inih itself is licensed under the BSD License.

For the exact terms, see the [LICENSE](ext/inih/LICENSE) file.

ruby-inih is licensed under the MIT License.

For the exact terms, see the [LICENSE](./LICENSE) file.
