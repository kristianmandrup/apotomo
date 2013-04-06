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

    # Escape carrier returnamespace and single and double quotes for JavaScript segments.
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
      # --> Widget.TopBar.update('item': 1)
      def widget_class_call(class_name, function, hash={})
        widget_class_name = js_namespace_name(class_name)
        function_name = js_camelize(function)
        "Widget.#{widget_class_name}.#{function_name}(#{hash.to_json});"
      end
 
      # call existing widget
      # - widget_call :top_bar, :flash_light, action: 'search' 
      # --> widgets['top_bar'].flashLight('action': 'search')
      def widget_call(id, function, hash={})
        function_name = jq_helper.js_camelize(function)
        "widgets['#{id}'].#{function_name}(#{hash.to_json});"
      end

      protected

      def js_namespace_name(class_name)
        names = class_name.split('::')
        namespace = names[0..-2].map { |name| js_camelize(name) }.join('.')
        return names.last if namespace.blank?
        namespace << ".#{names.last}"
      end

      def js_camelize(str)
        str = str.to_s.camelize
        str.camelize.sub(/^\w/, str[0].downcase)
      end

    end
  end
end
