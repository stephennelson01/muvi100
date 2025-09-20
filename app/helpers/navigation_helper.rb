# app/helpers/navigation_helper.rb
module NavigationHelper
  # Red underline on hover; persistent red underline + red text when active
  def nav_link_to(label, path)
    active = current_page?(path)

    base = "nav-tab border-b-2"
    cls  = if active
      "#{base} nav-tab--active"
    else
      "#{base}"
    end

    link_to label, path, class: cls
  end
end
