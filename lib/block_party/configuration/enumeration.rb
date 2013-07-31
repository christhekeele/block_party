require "block_party/configuration"
require 'block_party/configuration/conversion'

module BlockParty
  class Configuration
    module Enumeration

      include Enumerable
      def each(*args, &block)
        to_hash.each(*args, &block)
      end

    end
  end
end
