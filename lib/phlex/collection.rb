module Phlex
  class Collection < Phlex::Component
    def initialize(resource: nil, resources: nil)
      unless !!resource ^ !!resources
        raise ArgumentError,
          "You can pass a collection component either a list of `resources` or a single `resource` but not both."
      end

      super
    end

    def template
      if @resources
        collection_template(@resources)
      elsif @resource
        item_template(@resource)
      else
        raise ArgumentError
      end
    end
  end
end
