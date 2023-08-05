require 'dotenv'
require 'json'
Dotenv.load

class RoutesController < ApplicationController
    def index
        begin 
            @routes = Route.select([:id, :routeSummary, :totalTravelTime, :travelMode, :totalTravelDistance]).where(origin: params['origin'], destination: params['destination'])
            render json: @routes
        rescue Exception

            render json: "Something went wrong"
        end
    end

    def show
        begin
            @routes = Route.find(params[:id])
            render json: @routes
        rescue => err
            logger.error err
            render json: "Something went wrong"

        end
    end
    
    def create
        begin
            @location = Location.find(params["locationId"])
            logger.info @location
            @response =  RestClient.get "#{ENV["GOOGLE_DIRECTIONS_API"]}?origin=#{params["start"]}&destination=#{params["end"]}&key=#{ENV["GOOGLE_API_KEY"]}"
            @parsedResponse = JSON.parse(@response.body)
            
            if @parsedResponse["status"] == "REQUEST_DENIED"
                logger.error @parsedResponse
                return render :json => {:errors =>  "Something went wrong"}, :code => 403
            end
            for route in @parsedResponse["routes"] do
                logger.info route
                temp = Route.create(
                        origin: params["start"],
                        destination: params["end"],
                        routeSummary: route["summary"],
                        data: route.to_json,
                        location: @location,
                        totalTravelTime: route["legs"][0]["distance"]["text"],
                        travelMode: route["legs"][0]["duration"]["text"],
                        totalTravelDistance: route["legs"][0]["steps"][0]["travel_mode"],
                    )
                temp.save
            end
            render json: "Success"
        rescue => e
            logger.error e.message
            logger.error e.backtrace.join("\n")
            render json: "Something went wrong"
        end

    end

    def update
        begin
            Route.select([:id]).where(origin: params['start'], destination: params['end']).destroy_all()
            @location = Location.find(params["locationId"])
            logger.info @location
            @response =  RestClient.get "#{ENV["GOOGLE_DIRECTIONS_API"]}?origin=#{params["start"]}&destination=#{params["end"]}&key=#{ENV["GOOGLE_API_KEY"]}"
            @parsedResponse = JSON.parse(@response.body)
            
            if @parsedResponse["status"] == "REQUEST_DENIED"
                logger.error @parsedResponse
                return render :json => {:errors =>  "Something went wrong"}, :code => 403
            end
            for route in @parsedResponse["routes"] do
                logger.info route
                temp = Route.create(
                        origin: params["start"],
                        destination: params["end"],
                        routeSummary: route["summary"],
                        data: route.to_json,
                        location: @location,
                        totalTravelTime: route["legs"][0]["distance"]["text"],
                        travelMode: route["legs"][0]["duration"]["text"],
                        totalTravelDistance: route["legs"][0]["steps"][0]["travel_mode"],
                    )
                temp.save
            end
            render json: "Success"
        rescue => e
            logger.error e.message
            logger.error e.backtrace.join("\n")
            render json: "Something went wrong"
        end    
    end

    def destroy
        begin
            @location =Route.find(params[:id])
            @location.destroy
            render json: "#{@location.id} has been deleted! " 
        rescue Exception
            render json: "Something went wrong"
        end

    end
end
