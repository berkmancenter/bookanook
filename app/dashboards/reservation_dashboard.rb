require "administrate/base_dashboard"

class ReservationDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    nook: Field::BelongsTo,
    requester: Field::BelongsTo.with_options(class_name: "User"),
    id: Field::Number,
    user_id: Field::Number,
    public: Field::Boolean,
    name: Field::String,
    url: Field::String,
    stream_url: Field::String,
    status: Field::StatusField.with_options(statuses: Reservation::STATUSES),
    priority: Field::Number,
    start: Field::DateTime,
    end: Field::DateTime,
    description: Field::Text,
    notes: Field::Text,
    repeats_every: Field::String,
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
    :nook,
    :requester,
    :start,
    :end,
    :created_at,
    :status,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :status,
    :public,
    :name,
    :url,
    :stream_url,
    :priority,
    :start,
    :end,
    :description,
    :notes,
  ]

  FIXED_ATTRIBUTES = [
    :nook,
    :requester
  ]

  # Overwrite this method to customize how reservations are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(reservation)
  #   "Reservation ##{reservation.id}"
  # end
end
