require "administrate/base_dashboard"

class OpenScheduleDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    id: Field::Number,
    name: Field::String,
    seconds_per_block: Field::Number,
    blocks_per_span: Field::Number,
    span_name: Field::String,
    blocks: Field::Boolean,
    duration: Field::Number,
    start: Field::DateTime,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :id,
    :name,
    :seconds_per_block,
    :blocks_per_span,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = ATTRIBUTE_TYPES.keys

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :name,
    :seconds_per_block,
    :blocks_per_span,
    :span_name,
    :blocks,
    :duration,
    :start,
  ]

  # Overwrite this method to customize how open schedules are displayed
  # across all pages of the admin dashboard.
  #
  # def display_resource(open_schedule)
  #   "OpenSchedule ##{open_schedule.id}"
  # end
end
