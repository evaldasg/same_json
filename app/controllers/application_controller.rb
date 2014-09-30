class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def index
  end

  def bonus_counter
    count_bonuses(params[:id])
    render 'index'
  end

  private
  def count_bonuses(user_id)
    @bonus_amount = 0
    # creating GET request for json
    uri = URI.parse("http://sheltered-refuge-8118.herokuapp.com/all.json")
    http = Net::HTTP.new(uri.host, uri.port)
    req = Net::HTTP::Get.new(uri.request_uri)
    res = http.request(req)

    if res.code == '200' # using response only if it was success
      results = JSON.parse(res.body) # parsing json to ruby

      # selecting all user's bonuses fragments and inserting into new array
      user_results = results.select { |r| r["user_id"] == user_id.to_i }
      array = []
      user_results.each do |result|
        result["fragments"].each do |fragment|
          if fragment["rel_type"] == 'b'
            fragment["date"] = result["date"] # this attribute is needed for fragment also
            array << fragment
          end
        end
      end
      array.each { |a| @bonus_amount += a["amount"] } # counting bonus amount
      @bonus = array.sort { |a, b| a["rel_id"] <=> b["rel_id"] }
    end
  end
end
