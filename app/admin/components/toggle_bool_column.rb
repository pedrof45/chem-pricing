module ActiveAdminAddons::BoolValues
  module ::ActiveAdmin::Views
    class TableFor
      def toggle_bool_column(field, &block)
        column(field) do |obj|
          next unless block.nil? || block.call(obj)
          model = obj.class.name.underscore
          div class: 'toggle-bool-switches-container' do
            [true, false].each do |value|
              span image_tag(
                "switch_#{value ? :on : :off}.png",
                size: "40x16",
                id: "toggle-#{model}-#{obj.id}-#{field}-#{value}",
                class: "toggle-bool-switch #{'hidden-switch' if value == !obj.send(field)}",
                'data-model': model,
                'data-object_id': obj.id,
                'data-field': field,
                'data-value': value,
                'data-url': public_send("#{model}_path", id: obj.id)
              )
            end
          end
        end
      end
    end
  end
end
