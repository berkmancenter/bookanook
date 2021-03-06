class GoogleUser < User

  def self.model_name
    User.model_name
  end

  def self.find_or_create(auth)
    where(authid: auth[:uid]).first_or_create do |user|
      user.type = 'GoogleUser'
      user.authid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
  end

end
