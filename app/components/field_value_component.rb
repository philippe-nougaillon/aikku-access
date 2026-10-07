# frozen_string_literal: true

class FieldValueComponent < ViewComponent::Base
  delegate :policy, to: :helpers

  attr_reader :field, :value, :table, :record_index, :is_link, :context

  def initialize(field:, value:, table: nil, record_index: nil, is_link: false, context: :table)
    @field = field
    @value = value
    @table = table
    @record_index = record_index
    @is_link = is_link
    @context = context # :table, :card, :detail
  end

  def blob
    @blob ||= Blob.find_by(id: @value)
  end

  def valid_date?
    Value.is_valid_date?(@value)
  end

  def formatted_date
    l(@value.to_date) if @value.present? && valid_date?
  rescue
    nil
  end

  def status_color
    items = @field.items_splitted.map { |e| e.split(':') }.to_h
    Field.bootstrap_class(items[@value])
  end

  def uri_host
    URI.parse(@value).host
  rescue
    @value
  end

  def linked_table
    @linked_table ||= Table.find_by(id: @field.relation&.relation_with_id)
  end

  def linked_record_label
    @linked_record_label ||= @field.get_linked_table_record(@value.to_i)
  end

  def youtube_embed?
    @value.to_s.include?('embed')
  end

  def tags
    @value.to_s.split(', ')
  end

  def star_count
    @value.to_i.clamp(0, 5)
  end

  def text_long_value
    @context == :table ? helpers.truncate(@value, length: 80) : @value
  end

  def image_thumbnail_size
    @context == :table ? [100, 100] : [200, 250]
  end

  def details_link?
    @is_link && @table.present? && @record_index.present?
  end

  def details_path
    helpers.details_table_path(@table, record_index: @record_index)
  end
end
