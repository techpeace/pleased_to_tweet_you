class TextMessage < ActionMailer::Base
  def press_alert(sign_up)
    recipients '8179091718@txt.att.com'
    from 'press-alert@matthewbuck.com'
    
    subject "Press Alert"
    body :name => sign_up.name, :email => sign_up.email
  end
end