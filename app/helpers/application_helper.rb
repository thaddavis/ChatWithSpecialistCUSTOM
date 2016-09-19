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

#   function hashCode(str) { // java String#hashCode
#     var hash = 0;
#     for (var i = 0; i < str.length; i++) {
#        hash = str.charCodeAt(i) + ((hash << 5) - hash);
#     }
#     return hash;
# }
# function intToRGB(i){
#     var c = (i & 0x00FFFFFF)
#         .toString(16)
#         .toUpperCase();

#     return "00000".substring(0, 6 - c.length) + c;
# }

end
