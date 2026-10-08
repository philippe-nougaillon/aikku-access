# frozen_string_literal: true

class FieldInputComponentPreview < ViewComponent::Preview
  def text
    table = Table.first || Table.new(name: "Demo")
    field = Field.new(id: 1, name: "Titre", datatype: "Texte", obligatoire: true)
    render(FieldInputComponent.new(field: field, table: table, record_index: 1, value: "Mon titre", index: 0))
  end

  def euros
    table = Table.first || Table.new(name: "Demo")
    field = Field.new(id: 2, name: "Prix unitaire", datatype: "Euros", obligatoire: false)
    render(FieldInputComponent.new(field: field, table: table, record_index: 1, value: "29.99", index: 1))
  end

  def yes_no
    table = Table.first || Table.new(name: "Demo")
    field = Field.new(id: 3, name: "Disponible", datatype: "Oui_non?", obligatoire: false)
    render(FieldInputComponent.new(field: field, table: table, record_index: 1, value: "Oui", index: 2))
  end

  def select_list
    table = Table.first || Table.new(name: "Demo")
    field = Field.new(id: 4, name: "Catégorie", datatype: "Liste", items: "A, B, C", obligatoire: false)
    render(FieldInputComponent.new(field: field, table: table, record_index: 1, value: "B", index: 3))
  end

  def date
    table = Table.first || Table.new(name: "Demo")
    field = Field.new(id: 5, name: "Date d'échéance", datatype: "Date", obligatoire: false)
    render(FieldInputComponent.new(field: field, table: table, record_index: 1, value: "2026-10-08", index: 4))
  end

  def stars
    table = Table.first || Table.new(name: "Demo")
    field = Field.new(id: 6, name: "Note", datatype: "Stars", obligatoire: false)
    render(FieldInputComponent.new(field: field, table: table, record_index: 1, value: "4", index: 5))
  end
end
