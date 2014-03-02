Spree::User.class_eval do

  alias :devise_valid_password? :valid_password?

  def valid_password?(password_input)
    return true if devise_valid_password?(password_input)
    return false unless Digest::MD5.hexdigest(password_input) == encrypted_password
    
    logger.info "User #{email} is using the old password hashing method, updating attribute."
    # Only save if user pass has 6 characters or more
    if password_input.length >= 6
      self.password = password_input
      self.save!
    end
    true
  end

end
