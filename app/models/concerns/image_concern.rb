module ImageConcern
  extend ActiveSupport::Concern

  module ClassMethods
    # DSL
    # @param [Symbol] field_name
    # @param [Attachment] attachment_class
    # @param [Symbol] polymorphic_relation Default as :imaginable
    def has_image(field_name, attachment_class, polymorphic_relation = :imaginable)
      has_one_params = {class_name: attachment_class.to_s, as: polymorphic_relation, cascade_callbacks: true}

      embeds_one field_name, has_one_params

      accepts_nested_attributes_for field_name, allow_destroy: true
    end

    alias :has_file :has_image
  end
end
