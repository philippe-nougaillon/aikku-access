# frozen_string_literal: true

class TableCellComponentPreview < ViewComponent::Preview
  def text
    table = Table.first || Table.new(name: "Demo")
    field = Field.new(id: 1, name: "Désignation", datatype: "Texte")
    render(TableCellComponent.new(field: field, value: "Produit A", table: table, record_index: 1))
  end

  def euros
    table = Table.first || Table.new(name: "Demo")
    field = Field.new(id: 2, name: "Montant", datatype: "Euros")
    render(TableCellComponent.new(field: field, value: "19.50", table: table, record_index: 1))
  end

  def status
    table = Table.first || Table.new(name: "Demo")
    field = Field.new(id: 3, name: "Statut", datatype: "Statut", items: "En cours:jaune,Terminé:vert")
    render(TableCellComponent.new(field: field, value: "Terminé", table: table, record_index: 1))
  end
end
