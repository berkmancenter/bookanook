module ExtensibleAttrs
  extend ActiveSupport::Concern

  included do
    serialize :attrs
    serialize :hidden_attrs
  end
end
