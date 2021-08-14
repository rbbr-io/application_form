<% module_namespacing do -%>
class <%= class_name %>Form < <%= options['model'].classify %>
  include ApplicationForm
end
<% end -%>
