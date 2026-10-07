# frozen_string_literal: true

require "test_helper"

class FieldInputComponentTest < ViewComponent::TestCase
  setup do
    @table = tables(:articles)
  end

  test "renders text input with proper name, required and autofocus" do
    field = Field.new(id: 42, name: "Titre", datatype: "Texte", obligatoire: true)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 1, value: "Mon titre", index: 0))

    assert_selector "fieldset.mb-3"
    assert_selector "label", text: "* Titre"
    assert_selector "input[type='text'][name='[data][1][42]'][value='Mon titre'][required]"
    assert_selector "input[autofocus]"
  end

  test "renders number input for Euros with € placeholder" do
    field = Field.new(id: 43, name: "Prix", datatype: "Euros", obligatoire: false)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 1, value: "19.99", index: 1))

    assert_selector "input[type='number'][name='[data][1][43]'][value='19.99'][placeholder='€']"
    assert_no_selector "input[required]"
    assert_no_selector "input[autofocus]"
  end

  test "renders Oui_non radio buttons" do
    field = Field.new(id: 44, name: "Disponible", datatype: "Oui_non?", obligatoire: false)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 2, value: "Oui", index: 1))

    assert_selector "input[type='radio'][value='Oui'][checked]"
    assert_selector "input[type='radio'][value='Non']"
  end

  test "renders select tag for Liste" do
    field = Field.new(id: 45, name: "Catégorie", datatype: "Liste", items: "A, B, C", obligatoire: false)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 1, value: "B", index: 1))

    assert_selector "select[name='[data][1][45]']"
    assert_selector "option[value='B'][selected]"
  end

  test "renders geolocation controller markup for GPS" do
    field = Field.new(id: 46, name: "Position", datatype: "GPS", obligatoire: false)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 1, value: "48.85,2.35", index: 1))

    assert_selector "div[data-controller='geolocation']"
    assert_selector "input[data-geolocation-target='gpstextfield'][value='48.85,2.35']"
    assert_selector "button[data-action='click->geolocation#search']"
  end
end
