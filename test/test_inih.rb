# frozen_string_literal: true

require "minitest/autorun"
require "tempfile"
require "inih"

# Unit tests for INIH.
class INIHTest < Minitest::Test
  TEST_INI_DATA = <<~EOS
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
  EOS

  TEST_EXP_HASH = {
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

  def test_parse
    hsh = INIH.parse TEST_INI_DATA

    assert_instance_of Hash, hsh
    assert_equal TEST_EXP_HASH, hsh
  end

  def test_load
    file = Tempfile.new("test")
    file.write TEST_INI_DATA
    file.close

    hsh = INIH.load file.path

    assert_instance_of Hash, hsh
    assert_equal TEST_EXP_HASH, hsh
  ensure
    file.unlink
  end
end
