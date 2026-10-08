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

  test "renders date input for Date" do
    field = Field.new(id: 47, name: "Échéance", datatype: "Date", obligatoire: true)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 1, value: "2026-10-08", index: 1))

    assert_selector "input[type='date'][name='[data][1][47]'][value='2026-10-08'][required]"
  end

  test "renders email input for Email" do
    field = Field.new(id: 48, name: "Contact", datatype: "Email", obligatoire: false)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 1, value: "user@test.org", index: 1))

    assert_selector "input[type='email'][name='[data][1][48]'][value='user@test.org']"
  end

  test "renders textarea for Texte_long" do
    field = Field.new(id: 49, name: "Remarques", datatype: "Texte_long", obligatoire: false)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 1, value: "Longue description", index: 1))

    assert_selector "textarea[name='[data][1][49]']", text: "Longue description"
  end

  test "generates a UUID when value is blank for UUID datatype" do
    field = Field.new(id: 50, name: "Identifiant", datatype: "UUID", obligatoire: true)

    component = FieldInputComponent.new(field: field, table: @table, record_index: 1, value: nil, index: 1)
    render_inline(component)

    assert_match(/\A[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\z/i, component.field_value)
    assert_selector "input[name='[data][1][50]']"
  end

  test "renders 5 radio buttons for Stars" do
    field = Field.new(id: 51, name: "Avis", datatype: "Stars", obligatoire: false)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 1, value: "3", index: 1))

    assert_selector "input[type='radio'][name='[data][1][51]']", count: 5
    assert_selector "input[type='radio'][value='3'][checked]"
  end

  test "renders trix editor for Texte_riche" do
    field = Field.new(id: 52, name: "Contenu", datatype: "Texte_riche", obligatoire: false)

    render_inline(FieldInputComponent.new(field: field, table: @table, record_index: 1, value: "<div>Texte</div>", index: 1))

    assert_selector "trix-editor[data-testid='Contenu']"
  end
end

