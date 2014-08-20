module JsendWrapper
  module Handlers
    class Success
      def self.call(template)
        json_handler = ActionView::Template.registered_template_handler :jbuilder
        json = json_handler.call template

        <<-RUBY
          content = instance_eval #{json.inspect}
          JsendWrapper::Handlers::Success.new(self).render content, local_assigns
        RUBY
      end

      #@param view [ActiveView::Base]
      def initialize(view)
        @view = view
      end

      #@param template [ActiveView::Template]
      #@param local_assigns [Hash]
      def render(template, local_assigns = {})
        @view.controller.headers["Content-Type"] ||= 'application/json'
        wrap template
      end

    private

      def wrap(json)
        json = 'null' if !json || json.empty?
        %[{"status":"success","data":#{json}}]
      end
    end
  end
end
