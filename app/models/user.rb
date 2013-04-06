class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,  #:recoverable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :firstname, :lastname,  :authentication_token,:image
  # attr_accessible :title, :body

  has_many :pins, dependent: :destroy
  has_many :evaluations, class_name: "RSEvaluation", as: :source

def self.from_omniauth(auth)
  where(auth.slice(:provider, :uid)).first_or_create do |user|
    user.firstname = auth.info.first_name
    user.lastname = auth.info.last_name
    user.provider = auth.provider
    user.uid = auth.uid
    user.authentication_token = auth.credentials.access_token
    user.image = auth.info.image
  end
end

def self.new_with_session(params, session)
  if session["devise.user_attributes"]
    new(session["devise.user_attributes"], without_protection: true) do |user|
      user.attributes = params
      user.valid?
    end
  else
    super
  end
 end

def password_required?
  super && provider.blank?
end

def update_with_password(params, *options)
  if encrypted_password.blank?
    update_attributes(params, *options)
  else
    super
  end
 end


end
