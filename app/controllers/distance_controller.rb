class DistanceController < ApplicationController
  def index
    uri = URI('https://data.sfgov.org/resource/rqzj-sfat.json')
    res = Net::HTTP.get_response(uri)

    r = JSON.parse(res.body)

    def find_distance(loc)
      rad_per_deg = Math::PI/180 
      rkm = 6371                  # Earth radius in kilometers
      rm = rkm * 1000             # Radius in meters

      dlat_rad = (loc[0]- 37.786163522) * rad_per_deg  # Delta, converted to rad
      dlon_rad = (loc[1]- -122.4066) * rad_per_deg

      lat1_rad = 37.786163522 * rad_per_deg
      lon1_rad = -122.4066 * rad_per_deg 
      lat2_rad, lon2_rad = loc.map {|i| i * rad_per_deg }

      a = Math.sin(dlat_rad/2)**2 + Math.cos(lat1_rad) * Math.cos(lat2_rad) * Math.sin(dlon_rad/2)**2
      c = 2 * Math::atan2(Math::sqrt(a), Math::sqrt(1-a))

      rm * c # meters
    end

    @closest_food = nil
    r.each do |key,value|    
      if(@closest_food == nil)
        distance = find_distance([key["location"]['latitude'].to_f,key["location"]['longitude'].to_f])
        key['distance'] = distance
        @closest_food = key
        next
      end

      if(key["facilitytype"] == "Truck" && key["status"] == "APPROVED")        
        distance = find_distance([key["location"]['latitude'].to_f,key["location"]['longitude'].to_f])    
        if(@closest_food['distance'] > distance)
          puts "replacing food #{@closest_food['applicant']} with #{key['applicant']}"
          key['distance'] = distance
          @closest_food = key
        end
      end
    end
    @latitude = @closest_food['location']['latitude']
    @longitude = @closest_food['location']['longitude']
  end

  def search
    food_trucks = find_trucks(params[:keyword])

    unless food_trucks
      flash[:alert] = 'No food trucks were found'
      return render action: :index
    end
  end
end
