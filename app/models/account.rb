class Account < ApplicationRecord
  devise :omniauthable, :omniauth_providers => [:facebook, :twitter, :vkontakte]
  belongs_to  :user

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |account|
      account.email = auth.info.email
      account.user_id ||= User.create.id
    end
  end
end
