class LoadsController < ApplicationController
  
  def index
    
  end
  
  def show
    
  end
  
  def new
    params[:type] == "save" ? @render_form = "save_form" : @render_form = "load_form"
    respond_to do |f|
      f.js {render 'form', :layout => false }
    end
  end
  
  def download
    @employees = Employee.all
    respond_to do |f|
      f.json do
        stream = render_to_string()
        send_data(stream, :type=>"application/json", :filename => "#{params[:filename]}_export_#{Time.now.to_s}.json")
      end
#      f.json 
    end
  end
  
  def upload
    name = params[:import].original_filename
    directory = "public/imports"
    path = File.join(directory, name)
    File.open(path, "wb") { |f| f.write(params[:import].tempfile.read) }
    flash[:notice] = "File uploaded"
    @import = ImportHandler.new(path).parse
    redirect_to loads_path
  end
  
  
  
end
