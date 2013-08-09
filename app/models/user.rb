class User < ActiveRecord::Base
	rolify
  # Include default devise modules. Others available are:
  # :token_authenticatable, :encryptable, :confirmable, :lockable, :timeoutable and :omniauthable, :registerable, :recoverable, :rememberable
  devise :database_authenticatable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :display_name, :email, :password, :password_confirmation, :remember_me, :identification

  def vacations
      Vacations.find_by_identification(self.identification)
  end

end
