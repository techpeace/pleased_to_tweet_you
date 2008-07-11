require 'twitter'

class SignUpsController < ApplicationController  
  helper :transparent_message
    
  def collect
    @sign_up  = SignUp.new
    @sign_ups = SignUp.recent
  end
  
  def create
    @sign_up = SignUp.new(params[:sign_up])
    
    # If the attendee is registered successfully...
    if @sign_up.save
      # Attempt a tweet.
      tweet = SignUp.tweet!
      Twitter::Base.new('username', 'password').post(tweet) if tweet      
      
      # Alert whurley if it's a member of the press.
      TextMessage.deliver_press_alert(@sign_up)
      
      # Update the attendee list
      render :action => "saved.rjs"
    else
      # ... display the error messages.
      render :action => "errors.rjs"
    end
  end

  def generate_attendees_list
      @sign_ups = SignUp.find(:all)
      
      csv_string = FasterCSV.generate(:force_quotes => true) do |csv|
        # header row
        csv << ['Name', 'Twitter Account', 'Email Address', 'Is a Member of the Press', 'Okay to email']
	   
        # data rows
        @sign_ups.each do |sign_up|
          csv << [sign_up.name, sign_up.twitter_username, sign_up.email, sign_up.member_of_press_for_csv, sign_up.email_opt_in_for_csv]
        end
      end
	    
      # send it to the browsah
      send_data csv_string,
        :type => 'text/csv; charset=iso-8859-1; header=present',
        :disposition => "attachment; filename=barcamp-attendees-list.csv"
    end
end
