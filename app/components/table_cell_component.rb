# frozen_string_literal: true

class TableCellComponent < ViewComponent::Base
  attr_reader :field, :value, :table, :record_index, :is_link, :relation

  def initialize(field:, value:, table:, record_index:, is_link: false, relation: nil, sum: nil)
    @field = field
    @value = value
    @table = table
    @record_index = record_index
    @is_link = is_link
    @relation = relation
    @sum = sum
  end

  def render?
    return true unless %w[details related_tables].include?(helpers.action_name)
    !(@field.Collection? && @relation&.field == @field)
  end

  def before_render
    if @field.operation && @sum && @value
      @sum[@field.id] += @value.to_f
    end
  end

  def cell_style
    styles = ["vertical-align: middle;"]
    styles << "text-align: right;" if @field.is_numeric
    styles.join(" ")
  end
end
