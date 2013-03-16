require 'action_view/helpers/javascript_helper'
require "active_support/core_ext" # for Hash.to_json etc.

module Apotomo
  class JavascriptGenerator
    def initialize(framework)
      raise "No JS framework specified" if framework.blank?
      extend "apotomo/javascript_generator/#{framework}".camelize.constantize
    end
    
    def <<(javascript)
      "#{javascript}"
    end
    
    JS_ESCAPER = Object.new.extend(::ActionView::Helpers::JavaScriptHelper)

    # Escape carrier returns and single and double quotes for JavaScript segments.
    def self.escape(javascript)
      JS_ESCAPER.escape_javascript(javascript)
    end
    
    def escape(javascript)
      self.class.escape(javascript)
    end
    
    module Prototype
      def prototype;              end
      def element(id);            "$(\"#{id}\")"; end
      def update(id, markup);     element(id) + '.update("'+escape(markup)+'");'; end
      def replace(id, markup);    element(id) + '.replace("'+escape(markup)+'");'; end
      def update_id(id, markup);  update(id, markup); end
      def replace_id(id, markup); replace(id, markup); end
    end
    
    module Right
      def right;                  end
      def element(id);            "$(\"#{id}\")"; end
      def update(id, markup);     element(id) + '.update("'+escape(markup)+'");'; end
      def replace(id, markup);    element(id) + '.replace("'+escape(markup)+'");'; end
      def update_id(id, markup);  update(id, markup); end
      def replace_id(id, markup); replace(id, markup); end
    end
    
    module Jquery
      def jquery;                 end
      def element(id);            "$(\"#{id}\")"; end
      def update(id, markup);     element(id) + '.html("'+escape(markup)+'");'; end
      def replace(id, markup);    element(id) + '.replaceWith("'+escape(markup)+'");'; end
      def update_id(id, markup);  update("##{id}", markup); end
      def replace_id(id, markup); replace("##{id}", markup); end

      # call existing widget
      # - widget_class_call :top_bar, :update, item: 1
 
      # --> Widget.TopBar.update('action': 1)
      def widget_class_call id, function, hash
        function_name = jq_helper.js_camelize function
        widget_name = jq_helper.ns_name id.to_s.camelize
        namespace = "Widget.#{widget_name}"
        "#{namespace}.#{function_name}(#{hash.to_json});"
      end
 
      # call existing widget
      # - widget_call :top_bar, :flash_light, action: 'search'
 
      # --> Widgets.topBar.flashLight('action': 'search')
 
      def widget_call id, function, hash
        function_name = jq_helper.js_camelize function
        "Widgets.#{id}.#{function_name}(#{hash.to_json});"
      end

    end
  end
end
