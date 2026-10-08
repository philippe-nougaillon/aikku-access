# frozen_string_literal: true

class FieldValueComponentPreview < ViewComponent::Preview
  def text
    field = Field.new(name: "Titre", datatype: "Texte")
    render(FieldValueComponent.new(field: field, value: "Exemple de texte"))
  end

  def euros
    field = Field.new(name: "Montant", datatype: "Euros")
    render(FieldValueComponent.new(field: field, value: "149.99"))
  end

  def date
    field = Field.new(name: "Date", datatype: "Date")
    render(FieldValueComponent.new(field: field, value: "2026-10-08"))
  end

  def status
    field = Field.new(name: "Statut", datatype: "Statut", items: "actif:vert,attente:jaune,clos:rouge")
    render(FieldValueComponent.new(field: field, value: "actif"))
  end

  def stars
    field = Field.new(name: "Note", datatype: "Stars")
    render(FieldValueComponent.new(field: field, value: "4"))
  end

  def tags
    field = Field.new(name: "Tags", datatype: "Tags")
    render(FieldValueComponent.new(field: field, value: "ruby, rails, view_component"))
  end

  def youtube
    field = Field.new(name: "Vidéo", datatype: "Vidéo_YouTube")
    render(FieldValueComponent.new(field: field, value: "https://www.youtube.com/embed/dQw4w9WgXcQ"))
  end
end
