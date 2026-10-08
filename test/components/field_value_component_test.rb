# frozen_string_literal: true

require "test_helper"

class FieldValueComponentTest < ViewComponent::TestCase
  setup do
    @table = tables(:articles)
  end

  test "renders default text without link" do
    field = Field.new(name: "Nom", datatype: "Texte")

    render_inline(FieldValueComponent.new(field: field, value: "Exemple de texte"))

    assert_text "Exemple de texte"
    assert_no_selector "a"
  end

  test "renders link when is_link is true and table and record_index are present" do
    field = Field.new(name: "Nom", datatype: "Texte")

    render_inline(FieldValueComponent.new(field: field, value: "Lien article", table: @table, record_index: 1, is_link: true))

    assert_selector "a[href*='/tables/#{@table.slug}/details?record_index=1']", text: "Lien article"
  end

  test "renders currency for Euros" do
    field = Field.new(name: "Montant", datatype: "Euros")

    render_inline(FieldValueComponent.new(field: field, value: "49.99"))

    assert_text "49,99 €"
  end

  test "renders formatted date when valid" do
    field = Field.new(name: "Date début", datatype: "Date")

    render_inline(FieldValueComponent.new(field: field, value: "2026-05-12"))

    assert_text "12/05/2026"
  end

  test "renders error when date is invalid" do
    field = Field.new(name: "Date début", datatype: "Date")

    render_inline(FieldValueComponent.new(field: field, value: "invalid-date"))

    assert_text I18n.t("tables.error")
  end

  test "renders status badge with appropriate styling" do
    field = Field.new(name: "Statut", datatype: "Statut", items: "En cours:jaune,Terminé:vert")

    render_inline(FieldValueComponent.new(field: field, value: "Terminé"))

    assert_selector "span.badge.bg-success", text: "Terminé"
  end

  test "renders URL with extracted host" do
    field = Field.new(name: "Site", datatype: "URL")

    render_inline(FieldValueComponent.new(field: field, value: "https://rubyonrails.org/doctrine"))

    assert_selector "a[href='https://rubyonrails.org/doctrine']", text: "rubyonrails.org"
  end

  test "renders star rating" do
    field = Field.new(name: "Note", datatype: "Stars")

    render_inline(FieldValueComponent.new(field: field, value: "4"))

    assert_selector "i.bi-star-fill", count: 4
    assert_selector "i.bi-star", count: 1
  end

  test "renders tags as badges" do
    field = Field.new(name: "Mots-clés", datatype: "Tags")

    render_inline(FieldValueComponent.new(field: field, value: "tech, open source"))

    assert_selector "span.badge.bg-secondary", text: "Tech"
    assert_selector "span.badge.bg-secondary", text: "Open source"
  end

  test "renders Oui_non with translation" do
    field = Field.new(name: "Actif", datatype: "Oui_non?")

    render_inline(FieldValueComponent.new(field: field, value: "Oui"))

    assert_text I18n.t("misc.Oui")
  end

  test "truncates long text in table context but preserves full text in detail context" do
    long_text = "A" * 150
    field = Field.new(name: "Description", datatype: "Texte_long")

    render_inline(FieldValueComponent.new(field: field, value: long_text, context: :table))
    assert_text "..."

    render_inline(FieldValueComponent.new(field: field, value: long_text, context: :detail))
    assert_text long_text
  end

  test "renders YouTube embed iframe when value contains embed" do
    field = Field.new(name: "Vidéo", datatype: "Vidéo_YouTube")

    render_inline(FieldValueComponent.new(field: field, value: "https://www.youtube.com/embed/dQw4w9WgXcQ"))

    assert_selector "iframe[src='https://www.youtube.com/embed/dQw4w9WgXcQ']"
  end

  test "renders YouTube error icon and link when value is not embed format" do
    field = Field.new(name: "Vidéo", datatype: "Vidéo_YouTube")

    render_inline(FieldValueComponent.new(field: field, value: "https://www.youtube.com/watch?v=dQw4w9WgXcQ"))

    assert_no_selector "iframe"
    assert_selector "span.material-symbols-outlined", text: "error"
    assert_selector "a[href='https://www.youtube.com/watch?v=dQw4w9WgXcQ']"
  end

  test "renders mailto link for email datatype" do
    field = Field.new(name: "Courriel", datatype: "Email")

    render_inline(FieldValueComponent.new(field: field, value: "test@example.com"))

    assert_selector "a[href='mailto:test@example.com']", text: "test@example.com"
  end

  test "renders distance with km suffix in table context" do
    field = Field.new(name: "Distance", datatype: "Distance")

    render_inline(FieldValueComponent.new(field: field, value: "42", context: :table))

    assert_text "~42 km"
  end

  test "renders collection field without policy errors" do
    linked_table = tables(:articles)
    field = Field.new(name: "Article lié", datatype: "Collection")
    field.build_relation(relation_with_id: linked_table.id)

    render_inline(FieldValueComponent.new(field: field, value: "1"))

    # When policy does not authorize details, it does not raise and renders without linking
    assert_no_selector "a[href*='details']"
  end
end
