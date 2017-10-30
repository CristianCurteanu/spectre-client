# frozen_string_literal: true

module FieldHelper
  def render_field(field, type = 'reconnect')
    return render_select(field, type) if field.nature == 'select'
    content_tag :input, nil, name: "#{type}[#{field.name}]",
                             type: field.nature.to_s,
                             id:   "#{type}_#{field.name}"
  end

  def render_select(field, type)
    select_tag "#{type}[#{field.name}]",
               options_for_select(field.field_options.map { |c| [c.english_name, c.option_value] }),
               class: 'select2-input'
  end
end
