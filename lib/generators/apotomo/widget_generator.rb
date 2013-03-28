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
 
      class_option :js,     :type => :string, :default => 'js',  :desc => 'Javascript language to use: js or coffee'
      class_option :style,  :type => :string, :default => 'css', :desc => 'Style language to use: css, scss or sass'
 
      def create_cell_file
        template 'widget.rb', "#{base_path}_widget.rb"
      end
 
      def create_stylesheet_file
        style_extension = style == 'css' ? 'css' : "css.#{style}"
        template "widget.#{style}", "#{css_path}_widget.#{style_extension}"
      end            
 
      def create_script_file
        js_extension = js == 'js' ? 'js' : "js.#{js}"
        template "widget.#{js}", "#{js_path}_widget.#{js_extension}"
      end

      protected

      def ns_name
        names = class_name.split('::')
        ns = names[0..-2].map {|name| js_camelize name }.join('.')
        return names.last if ns.blank?
        ns << ".#{names.last}"
      end

      def simple_name
        class_name.to_s.demodulize
      end

      def js_camelize(str)
        str = str.to_s
        str.camelize.sub(/^\w/, str[0].downcase)
      end

      def style
        options[:style].to_s.downcase
      end

      def js
        options[:js].to_s.downcase
      end
    end
  end
end
