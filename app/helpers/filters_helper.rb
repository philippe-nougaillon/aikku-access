module FiltersHelper
  def filter_icon_addon(field, extra_class = nil)
    classes = ["input-group-text bg-white border-end-0 text-black-50", extra_class].compact.join(" ")
    tag.span(class: classes) do
      tag.span(field.icon, class: "material-symbols-outlined")
    end
  end
end
