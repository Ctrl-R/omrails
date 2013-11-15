module ApplicationHelper

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to "#{title} <i class='#{column == sort_column ? (direction == "desc" ? "icon-chevron-up" : "icon-chevron-down") : nil}'></i>".html_safe, {:sort => column, :direction => direction}, {:class => css_class}
  end

end
