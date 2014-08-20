require 'rails/railtie'

module JsendWrapper
  module Rails
    class Railtie < ::Rails::Railtie
      initializer "jsend_wrapper-rails.configure_rails_initialization" do
        ActionView::Template.register_template_handler :jsend,
          JsendWrapper::Handlers::Success
      end
    end
  end
end
