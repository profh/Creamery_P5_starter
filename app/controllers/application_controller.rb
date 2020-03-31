class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  # handle 404 errors with an exception as well
  rescue_from ActiveRecord::RecordNotFound do |exception|

    # consider creating your own 404 page within home and redirecting there...
    
    flash[:error] = "Seek and you shall find... but not this time"
    redirect_to home_path
  end
  
end
