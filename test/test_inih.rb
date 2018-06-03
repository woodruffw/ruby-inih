# frozen_string_literal: true

require "minitest/autorun"
require "tempfile"
require "inih"

# Unit tests for INIH.
class INIHTest < Minitest::Test
  TEST_INI_DATA = <<~DATA
    bare=pair
    thisform : alsoworks
    thisone:too

    [strings]
    foo = bar
    baz = quux
    zap =

    [types]
    bool1 = true
    bool2 = false
    int1 = 100
    int2 = -100
    float1 = 100.0
    float2 = 3.1415
    float3 = -3.1415
  DATA

  TEST_EXP_HASH_NORMALIZED = {
    "" => {
      "bare" => "pair",
      "thisform" => "alsoworks",
      "thisone" => "too",
    },

    "strings" => {
      "foo" => "bar",
      "baz" => "quux",
      "zap" => nil,
    },

    "types" => {
      "bool1" => true,
      "bool2" => false,
      "int1" => 100,
      "int2" => -100,
      "float1" => 100.0,
      "float2" => 3.1415,
      "float3" => -3.1415,
    },
  }.freeze

  TEST_EXP_HASH_UNNORMALIZED = {
    "" => {
      "bare" => "pair",
      "thisform" => "alsoworks",
      "thisone" => "too",
    },

    "strings" => {
      "foo" => "bar",
      "baz" => "quux",
      "zap" => "",
    },

    "types" => {
      "bool1" => "true",
      "bool2" => "false",
      "int1" => "100",
      "int2" => "-100",
      "float1" => "100.0",
      "float2" => "3.1415",
      "float3" => "-3.1415",
    },
  }.freeze

  def test_parse
    hsh = INIH.parse TEST_INI_DATA

    assert_instance_of Hash, hsh
    assert_equal TEST_EXP_HASH_NORMALIZED, hsh

    hsh = INIH.parse TEST_INI_DATA, normalize: false

    assert_instance_of Hash, hsh
    assert_equal TEST_EXP_HASH_UNNORMALIZED, hsh
  end

  def test_parse_raises_parse_error
    assert_raises INIH::ParseError do
      INIH.parse "foo"
    end
  end

  def test_load
    file = Tempfile.new("test")
    file.write TEST_INI_DATA
    file.close

    hsh = INIH.load file.path

    assert_instance_of Hash, hsh
    assert_equal TEST_EXP_HASH_NORMALIZED, hsh

    hsh = INIH.load file.path, normalize: false

    assert_instance_of Hash, hsh
    assert_equal TEST_EXP_HASH_UNNORMALIZED, hsh
  ensure
    file.unlink
  end

  def test_load_raises_parse_error
    file = Tempfile.new("test")
    file.write "foo"
    file.close

    assert_raises INIH::ParseError do
      INIH.load file.path
    end
  ensure
    file.unlink
  end

  def test_load_raises_io_error
    assert_raises IOError do
      INIH.load "this/file/does/not/exist"
    end
  end
end
