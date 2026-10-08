# frozen_string_literal: true

Rails.application.config.to_prepare do
  if defined?(ViewComponentsController)
    ViewComponentsController.class_eval do
      include Pundit::Authorization

      def default_url_options
        { locale: I18n.locale }
      end
    end
  end
end
