require 'generators/cells/base'

module Apotomo
  module Generators
    module BasePathMethods
      private

      def base_path
        File.join('app/widgets', class_path, file_name)
      end


      def js_path
        File.join('app/assets/javascripts/widgets', class_path, file_name)
      end

      def css_path
        File.join('app/assets/stylesheets/widgets', class_path, file_name)
      end        
    end
    
    class WidgetGenerator < ::Cells::Generators::Base
      include BasePathMethods
      
      source_root File.expand_path('../../templates', __FILE__)
      
      hook_for(:template_engine)
      hook_for(:test_framework)  # TODO: implement rspec-apotomo.
      
      check_class_collision :suffix => "Widget"
      
      
      class_option :js, :type => :boolean, :default => false, :desc => 'Generate javascript asset file'

      def create_stylesheet_file
         template 'widget.css', "#{css_path}_widget.css"
       end            

      def creates_script_file
        return template 'widget.coffee', "#{js_path}_widget.coffee" if !javascript?
        template 'widget.js', "#{js_path}_widget.js"
      end

      protected

      def javascript?
        options[:js]
      end
    end
  end
end
