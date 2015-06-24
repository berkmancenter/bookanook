class SelectizeInput < SimpleForm::Inputs::StringInput
  def input_html_classes
    super.push('selectize')
  end
end
