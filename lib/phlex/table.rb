module Phlex
  class Table < Phlex::Collection
    class << self
      def property(header, th_attributes: {}, td_attributes: {}, &block)
        if header.is_a?(String)
          header_text = header
          header = -> { text header_text }
        end

        properties << {
          header: header,
          th_attributes: th_attributes,
          td_attributes: td_attributes,
          body: block
        }
      end

      def properties
        @properties ||= []
      end
    end

    def collection_template(resources)
      table do
        thead do
          tr do
            properties.each do |property|
              th **property[:th_attributes].merge(scope: "col") do
                @_parent.instance_exec(&property[:header])
              end
            end
          end
        end

        tbody do
          resources.each do |resource|
            item_template(resource)
          end
        end
      end
    end

    def item_template(resource)
      tr do
        properties.each do |property|
          td **property[:td_attributes] do
            @_parent.instance_exec(resource, &property[:body])
          end
        end
      end
    end

    private

    def properties
      self.class.properties
    end
  end
end
