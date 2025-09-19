module NavigationHelper
  # Usage:
  #   <%= nav_link_to "Home", root_path %>
  #   <%= nav_link_to "Movies", movies_path, class: "extra-classes" %>
  #
  def nav_link_to(name, path, active: nil, **options)
    active = current_page?(path) if active.nil?

    base = "px-3 py-2 rounded-md text-sm text-neutral-200 hover:text-white hover:bg-white/5"
    active_classes = " bg-white/10 text-white"

    computed_class = [base, (active ? active_classes : nil), options.delete(:class)].compact.join(" ")

    link_to(name, path, **options.merge(class: computed_class))
  end
end
