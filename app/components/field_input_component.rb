# frozen_string_literal: true

class FieldInputComponent < ApplicationComponent
  attr_reader :field, :table, :record_index, :index, :relation_param, :value_param

  NON_INPUT_GROUP_DATATYPES = %w[Oui_non? Stars Signature Texte_riche].freeze

  def initialize(field:, table:, record_index: nil, value: nil, index: 0, relation_param: nil, value_param: nil)
    @field = field
    @table = table
    @record_index = record_index
    @value = value
    @index = index
    @relation_param = relation_param
    @value_param = value_param
  end

  def field_name
    "[data][#{@record_index}][#{@field.id}]"
  end

  def field_value
    @field_value ||= calculate_field_value
  end

  def autofocus?
    @index.zero?
  end

  def input_group?
    !@field.datatype.in?(NON_INPUT_GROUP_DATATYPES)
  end

  def input_icon_addon(extra_class = nil)
    classes = ["input-group-text bg-white border-end-0 text-black-50", extra_class].compact.join(" ")
    tag.span(class: classes) do
      tag.span(field.icon, class: "material-symbols-outlined")
    end
  end

  def label_text
    @field.obligatoire ? @field.name.humanize.insert(0, "* ") : @field.name.humanize
  end

  def blob
    @blob ||= Blob.find_by(id: field_value) if field_value.present?
  end

  def status_keys
    @field.items_splitted.map { |e| e.split(":").first }
  end

  def users_names
    @table.users.pluck(:name)
  end

  private

  def calculate_field_value
    case @field.datatype
    when "Formule"
      @record_index.present? ? @field.evaluate(@table, @record_index) : "n/a"
    when "Collection"
      if @relation_param.present? && Relation.find_by(id: @relation_param)&.field_id == @field.id
        @value_param
      else
        @value
      end
    when "UUID"
      @value.presence || SecureRandom.uuid
    else
      @value
    end
  end
end
