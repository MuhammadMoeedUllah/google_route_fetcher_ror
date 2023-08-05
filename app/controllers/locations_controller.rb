class LocationsController < ApplicationController
    def index
        @locations = Location.all
        render json: @locations
    end

    def show
       @location = Location.find(params[:id]) 
       render json: @location
    end
    
    def create
        allowed_categories = ["HOME","WORK"]
        if allowed_categories.include?(params[:category]) == false || params.has_key?(:category) == false || params.has_key?(:locationData) == false || params.has_key?(:address) == false
            return render :json => { :errors => "Parameters Not Allowed" }, :code => 503
            
        end
        @location = Location.create(category:  params[:category], locationData:  params[:locationData], address: params[:address])
        render json: @location
    end

    def destroy
        @location =Location.find(params[:id])
        @location.destroy
        render json: "#{@location.id} has been deleted! " 
    end
end
