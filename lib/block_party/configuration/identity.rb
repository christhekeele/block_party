require "block_party/configuration"
require 'block_party/configuration/conversion'

module BlockParty
  class Configuration
    module Identity

      def hash
        as_hash.hash
      end

      def empty?
        instance_variables.empty?
      end

    end
  end
end
