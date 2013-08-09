module UsersHelper
  def get_user(email)
    user = User.find_by_email(email)
    if user
      user.display_name
    else
      email
    end
  end
  
  def get_user_with_email(email)
    user = User.find_by_email(email)
    if user
     display = "#{user.display_name} -  #{email}"
     unless user.identification.blank?
       display = "#{user.identification} - #{display}"
     end
     display
    else
      email
    end
  end
end
