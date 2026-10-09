# frozen_string_literal: true

class ApplicationComponent < ViewComponent::Base
  delegate :rich_text_area_tag, to: :helpers

  def current_user
    helpers.current_user if helpers.respond_to?(:current_user)
  rescue Devise::MissingWarden
    nil
  end

  def policy(record)
    if helpers.respond_to?(:policy)
      helpers.policy(record)
    elsif defined?(Pundit)
      Pundit.policy(current_user, record)
    end
  rescue Devise::MissingWarden
    Pundit.policy(nil, record)
  end
end
