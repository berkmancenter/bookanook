require "administrate/base_dashboard"

class UserDashboard < Administrate::BaseDashboard
  # ATTRIBUTE_TYPES
  # a hash that describes the type of each of the model's fields.
  #
  # Each different type represents an Administrate::Field object,
  # which determines how the attribute is displayed
  # on pages throughout the dashboard.
  ATTRIBUTE_TYPES = {
    reservations: Field::HasMany,
    id: Field::Number,
    email: Field::String,
    sign_in_count: Field::Number,
    created_at: Field::DateTime,
    updated_at: Field::DateTime,
    password: PasswordField,
    password_confirmation: PasswordField,
  }

  # COLLECTION_ATTRIBUTES
  # an array of attributes that will be displayed on the model's index page.
  #
  # By default, it's limited to four items to reduce clutter on index pages.
  # Feel free to add, remove, or rearrange items.
  COLLECTION_ATTRIBUTES = [
    :email,
    :reservations,
  ]

  # SHOW_PAGE_ATTRIBUTES
  # an array of attributes that will be displayed on the model's show page.
  SHOW_PAGE_ATTRIBUTES = [
    :reservations,
    :id,
    :email,
    :sign_in_count,
    :created_at,
    :updated_at,
  ]

  # FORM_ATTRIBUTES
  # an array of attributes that will be displayed
  # on the model's form (`new` and `edit`) pages.
  FORM_ATTRIBUTES = [
    :email,
    :password,
    :password_confirmation,
  ]

  # Overwrite this method to customize how users are displayed
  # across all pages of the admin dashboard.

  def display_resource(user)
    user.full_name
  end
end
