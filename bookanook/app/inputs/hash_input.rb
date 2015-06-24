class HashInput < SimpleForm::Inputs::Base
  include ActionView::Helpers::FormTagHelper
  def input(wrapper_options)
    merged_input_options = merge_wrapper_options(input_html_options, wrapper_options)
    puts merged_input_options.inspect
    merged_input_options[:class] << :hash_key
    
    input = ''
    input += text_field_tag "#{object_name}[#{attribute_name}][][key]", '', merged_input_options
    input += ' : '
    merged_input_options[:class].pop
    merged_input_options[:class] << :hash_value
    input += text_field_tag "#{object_name}[#{attribute_name}][][value]", '', merged_input_options
    input.html_safe
  end
end
