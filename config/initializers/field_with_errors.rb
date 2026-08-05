# config/initializers/field_with_errors.rb
require 'nokogiri'

ActionView::Base.field_error_proc = proc do |html_tag, instance|
  html = Nokogiri::HTML::DocumentFragment.parse(html_tag)
  element = html.children.first

  if element
    # Add Bootstrap's is-invalid class to the element
    if element.name == 'input' || element.name == 'select' || element.name == 'textarea'
      element['class'] = [(element['class'] || ''), 'is-invalid'].join(' ').strip
    end
    element.to_html.html_safe
  else
    html_tag.html_safe
  end
end
