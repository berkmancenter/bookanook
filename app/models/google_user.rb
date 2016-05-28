class GoogleUser < User

  def self.find_or_create(auth)
    where(auth.slice(:authid)).first_or_create do |user|
      user.type = 'GoogleUser'
      user.authid = auth.uid
      user.email = auth.info.email
      user.password = Devise.friendly_token[0,20]
      user.skip_confirmation!
    end
  end

end
