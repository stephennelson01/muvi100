module NavigationHelper
  def nav_link_to(name, path, active: nil)
    active = current_page?(path) if active.nil?
    base = "px-3 py-2 rounded-md text-sm font-medium transition"
    active ? link_to(name, path, class: "#{base} bg-white text-neutral-900")
           : link_to(name, path, class: "#{base} text-neutral-200 hover:text-white hover:bg-neutral-700/60")
  end
end
