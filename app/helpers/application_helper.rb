module ApplicationHelper

  def gravatar_for(user, opts = {})
    opts[:alt] = user.email
    image_tag "https://www.gravatar.com/avatar/#{Digest::MD5.hexdigest(user.email)}?s=#{opts.delete(:size) { 40 }}",
              opts
  end

  def hashCode(str)
    hash = 0

    for ii in 0..(str.length - 1) do
      hash = str[ii].ord + ((hash << 5) - hash)
    end

    hash
  end

  def intToRGB(i)
    c = (i & 0x00FFFFFF).to_s(16).upcase

    return (c)
  end

  def ConnectedUsersForDisplay(users)
    returnArray = []

    users.each do |i|
      user_hash = Hash.new
      user = User.find(i)
      user_hash[:email] = user.email
      user_hash[:last_sign_in_at] = user.last_sign_in_at
      returnArray << user_hash
    end
    returnArray
  end

end
