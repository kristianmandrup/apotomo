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
 
      class_option :js,     :type => :boolean, :default => false,  :desc => 'Generate javascript asset file'
      class_option :style,  :type => :string,  :default => 'scss', :desc => 'Style language to use: css, scss or sass'
 
      def create_cell_file
        template 'widget.rb', File.join(base_path, "#{file_name}_widget.rb")
      end
 
      def create_stylesheet_file
        if scss?
          template 'widget.scss', "#{css_path}_widget.css.scss"
        elsif sass?
          template 'widget.sass', "#{css_path}_widget.css.sass"
        else
          template 'widget.css', "#{css_path}_widget.css"
        end
      end            
 
      def create_script_file
        puts "create_script_file"
        if coffee?
          template 'widget.coffee', "#{js_path}_widget.js.coffee" 
        else
          puts "js: #{js_path}_widget.js" 
          template 'widget.js', "#{js_path}_widget.js"
        end
      end

      protected

      def ns_name
        names = class_name.split('::')
        ns = names[0..-2].map {|name| js_camelize name }.join('.')
        return names.last if ns.blank?
        ns << ".#{names.last}"
      end

      def js_camelize str
        str = str.to_s
        str.camelize.sub(/^\w/, str[0].downcase)
      end

      def style
        options[:style].to_s.downcase
      end

      def sass?
        style == 'sass'
      end

      def scss?
        style == 'scss'
      end

      def css?
        style == 'css'
      end

      def coffee?
        !javascript?
      end

      def javascript?
        options[:js]
      end
    end
  end
end
