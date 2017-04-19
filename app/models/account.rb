class Account < ApplicationRecord
  devise :omniauthable, :omniauth_providers => [:facebook, :twitter, :vkontakte]
  validates :email,
            :presence => true,
            :uniqueness => {
                :case_sensitive => false
            }
  belongs_to  :user

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |account|
      account.email = auth.info.email
      account.user ||= User.create
    end
  end
end
