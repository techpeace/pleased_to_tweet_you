class SignUp < ActiveRecord::Base
  validates_presence_of :name
  
  # Returns the member of press attribute formatted for the CSV file.
  def member_of_press_for_csv
    self[:member_of_press] ? '1' : '0'
  end
  
  # Returns the email opt in attribute formatted for the CSV file.
  def email_opt_in_for_csv
    self[:email_opt_in] ? '1' : '0'
  end
  
  # Normalize the twitter username.
  def twitter_username=(username)
    self[:twitter_username] = username.scan(/\w*/).join('')[0..19]
  end
  
  # Returns an array of up to ten of the most recently created sign up records.
  def self.recent
    find(:all, :order => 'created_at desc', :limit => 13, :conditions => "show_name = 't'")
  end
  
  # Attempt to tweet some arrivals.
  def self.tweet!
    tweetable_sign_ups = find(:all, :conditions => "show_name = 't' AND tweeted = 'f' AND twitter_username IS NOT NULL", :order => "created_at ASC")
    
    if tweetable_sign_ups.size > 0
      # Start to form the tweet and calculate its length.
      tweet = form_tweet(tweetable_sign_ups)
      
      # If the tweet is too short...
      if tweet.length < 140
        # ... then we don't want to do anything just yet.
        return nil
      # If the tweet is too long...
      else
        # Keep removing usernames from the list while it's too long
        while tweet.length >= 140
          tweetable_sign_ups.pop
          tweet = form_tweet(tweetable_sign_ups)
        end
        
        # Mark each of the tweetable attendees as tweeted
        tweetable_sign_ups.each do |sign_up|
          sign_up.tweeted = true
          sign_up.save
        end
        
        # Po-tee-weet!
        tweet
      end
    end
  end        
  
protected

  # Create a tweet of the form '@joe, @john, and @matt have arrived'
  def self.form_tweet(tweetable_sign_ups)
    # Choose a suitable closing for the tweet
    closing = [" have arrived", " are BarCamping", " fear the 'Dillo", " all love to BarCamp", " are attending BarCamp Austin",
     " are here", " just got here", " are up to something at BarCamp", " finally got here :)"].pick
    tweetable_sign_ups.collect{|sign_up| '@' + sign_up.twitter_username}.to_sentence(:skip_last_comma => true) + closing
  end
        
end


# = rand.rb -- library for picking random elements and shuffling
#
# Copyright (C) 2004  Ilmari Heikkinen
#
# Documentation:: Christian Neukirchen <mailto:chneukirchen@gmail.com>
# 


module Enumerable
  # Choose and return a random element of the Enumerable.
  #   [1, 2, 3, 4].pick  #=> 2 (or 1, 3, 4)
  def pick
    entries.pick
  end
end

class Array
  # Choose and return a random element of _self_.
  #   [1, 2, 3, 4].pick  #=> 2 (or 1, 3, 4)
  def pick
    self[pick_index]
  end

  # Return the index of an random element of _self_.
  #   ["foo", "bar", "baz"].pick_index  #=> 1 (or 0, or 2)
  def pick_index
    rand(size)
  end
end
