require 'test_helper'
require 'generators/apotomo/widget_generator'

class WidgetGeneratorTest < Rails::Generators::TestCase
  destination File.join(Rails.root, "tmp")
  setup :prepare_destination
  tests ::Apotomo::Generators::WidgetGenerator
   
  context "Running rails g apotomo::widget" do
    context "Gerbil squeak snuggle" do
      should "create the standard assets" do
        run_generator %w(Gerbil squeak snuggle -t test_unit)
        
        assert_file "app/widgets/gerbil_widget.rb", /class GerbilWidget < Apotomo::Widget/
        assert_file "app/widgets/gerbil_widget.rb", /def snuggle/
        assert_file "app/widgets/gerbil_widget.rb", /def squeak/

        assert_file "app/widgets/gerbil/snuggle.html.erb", %r(app/widgets/gerbil/snuggle\.html\.erb)
        assert_file "app/widgets/gerbil/snuggle.html.erb", %r(<p>)
        assert_file "app/widgets/gerbil/squeak.html.erb", %r(app/widgets/gerbil/squeak\.html\.erb)

        assert_file "app/assets/javascripts/widgets/gerbil_widget.js", /Define your JavaScript code for the Gerbil widget*/
        assert_file "app/assets/stylesheets/widgets/gerbil_widget.css", /Define your CSS code for the Gerbil widget*/

        assert_file "test/widgets/gerbil_widget_test.rb", %r(class GerbilWidgetTest < Apotomo::TestCase)
        assert_file "test/widgets/gerbil_widget_test.rb", %r(widget\(:gerbil\))
      end
 
      should "create coffescript and scss assets" do
        run_generator %w(Gerbil squeak snuggle)
 
        assert_file "app/assets/javascripts/widgets/gerbil_widget.js", /Define your JavaScript code for the Gerbil widget*/
        assert_file "app/assets/stylesheets/widgets/gerbil_widget.css", /Define your CSS code for the Gerbil widget*/
      end
 
      should "create javascript assets" do
        run_generator %w(Gerbil squeak snuggle --js js --style css)
 
        assert_file "app/assets/javascripts/widgets/gerbil_widget.js", /Define your JavaScript code for the Gerbil widget*/
      end

      should "create css assets" do
        run_generator %w(Gerbil squeak snuggle --style css)
 
        assert_file "app/assets/stylesheets/widgets/gerbil_widget.css", /Define your CSS code for the Gerbil widget*/
      end

      should "create sass assets" do
        run_generator %w(Gerbil squeak snuggle --style sass)

        assert_file "app/assets/stylesheets/widgets/gerbil_widget.css.sass", /Define your SASS code for the Gerbil widget*/
      end

      should "create scss assets" do
        run_generator %w(Gerbil squeak snuggle --style scss)

        assert_file "app/assets/stylesheets/widgets/gerbil_widget.css.scss", /Define your SCSS code for the Gerbil widget*/
      end

      should "create haml assets with -e haml" do
        run_generator %w(Gerbil squeak snuggle -e haml -t test_unit)
        
        assert_file "app/widgets/gerbil_widget.rb", /class GerbilWidget < Apotomo::Widget/
        assert_file "app/widgets/gerbil_widget.rb", /def snuggle/
        assert_file "app/widgets/gerbil_widget.rb", /def squeak/
        assert_file "app/widgets/gerbil/snuggle.html.haml", %r(app/widgets/gerbil/snuggle\.html\.haml)
        assert_file "app/widgets/gerbil/snuggle.html.haml", %r(%p)
        assert_file "app/widgets/gerbil/squeak.html.haml", %r(app/widgets/gerbil/squeak\.html\.haml)
        assert_file "test/widgets/gerbil_widget_test.rb"
      end

      should "create slim assets with -e slim" do
        run_generator %w(Gerbil squeak snuggle -e slim -t test_unit)
        
        assert_file "app/widgets/gerbil_widget.rb", /class GerbilWidget < Apotomo::Widget/
        assert_file "app/widgets/gerbil_widget.rb", /def snuggle/
        assert_file "app/widgets/gerbil_widget.rb", /def squeak/
        assert_file "app/widgets/gerbil/snuggle.html.slim", %r(app/widgets/gerbil/snuggle\.html\.slim)
        assert_file "app/widgets/gerbil/snuggle.html.slim", %r(p)
        assert_file "app/widgets/gerbil/squeak.html.slim", %r(app/widgets/gerbil/squeak\.html\.slim)
        assert_file "test/widgets/gerbil_widget_test.rb"
      end
      
      should "work with namespaces" do
        run_generator %w(Gerbil::Mouse squeak -t test_unit)

        assert_file "app/widgets/gerbil/mouse_widget.rb", /class Gerbil::MouseWidget < Apotomo::Widget/
        assert_file "app/widgets/gerbil/mouse_widget.rb", /def squeak/
        assert_file "app/widgets/gerbil/mouse/squeak.html.erb", %r(app/widgets/gerbil/mouse/squeak\.html\.erb)
        assert_file "test/widgets/gerbil/mouse_widget_test.rb"
      end
    
    end
  end
end
