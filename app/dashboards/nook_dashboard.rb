require "administrate/base_dashboard"

class NookDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    location: Field::BelongsTo,
    manager: Field::BelongsTo.with_options(class_name: "User"),
    reservations: Field::HasMany,
    id: Field::Number,
    name: Field::String,
    description: Field::Text,
    type: Field::String,
    place: Field::Text,
    photos: CarrierwaveField,
    min_capacity: Field::Number,
    max_capacity: Field::Number,
    min_schedulable: Field::Number,
    max_schedulable: Field::Number,
    min_reservation_length: Field::Number,
    max_reservation_length: Field::Number,
    amenities: SelectizeField,
    attrs: Field::Text,
    hidden_attrs: Field::Text,
    use_policy: Field::Text,
    bookable: Field::Boolean,
    requires_approval: Field::Boolean,
    repeatable: Field::Boolean,
    user_id: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :name,
    :location,
    :manager,
    :reservations,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :location,
    :manager,
    :reservations,
    :name,
    :description,
    :type,
    :place,
    :photos,
    :min_capacity,
    :max_capacity,
    :min_schedulable,
    :max_schedulable,
    :min_reservation_length,
    :max_reservation_length,
    :amenities,
    :attrs,
    :hidden_attrs,
    :use_policy,
    :bookable,
    :requires_approval,
    :repeatable,
    :user_id,
  ]

  # Overwrite this method to customize how nooks are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(nook)
  #   "Nook ##{nook.id}"
  # end
end
