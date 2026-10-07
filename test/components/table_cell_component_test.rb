# frozen_string_literal: true

require "test_helper"

class TableCellComponentTest < ViewComponent::TestCase
  test "renders blank td when value is nil" do
    field = Field.new(name: "Test", datatype: "Texte")
    table = Table.new(name: "Test Table")

    render_inline(TableCellComponent.new(field: field, value: nil, table: table, record_index: 1))

    assert_selector "td", text: ""
    assert_no_selector "td[style]"
  end

  test "renders right-aligned td for numeric fields" do
    field = Field.new(name: "Prix", datatype: "Euros")
    table = Table.new(name: "Test Table")

    render_inline(TableCellComponent.new(field: field, value: "12.50", table: table, record_index: 1))

    assert_selector "td[style*='text-align: right;']"
    assert_text "12,50 €"
  end

  test "renders status badge with appropriate styling" do
    field = Field.new(name: "Statut", datatype: "Statut", items: "actif:vert,inactif:rouge")
    table = Table.new(name: "Test Table")

    render_inline(TableCellComponent.new(field: field, value: "actif", table: table, record_index: 1))

    assert_selector "span.badge.bg-success", text: "actif"
  end

  test "renders stars for star ratings" do
    field = Field.new(name: "Note", datatype: "Stars")
    table = Table.new(name: "Test Table")

    render_inline(TableCellComponent.new(field: field, value: "3", table: table, record_index: 1))

    assert_selector "i.bi-star-fill", count: 3
    assert_selector "i.bi-star", count: 2
  end
end
