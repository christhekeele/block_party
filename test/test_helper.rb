require "rubygems"
require "minitest/autorun"
require "simplecov"

SimpleCov.start do
  add_filter "/test"
end

require "block_party"
