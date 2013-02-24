require 'digest'

class Token

  def self.create
    input = [Time.now.nsec, Kernel.rand]
    Digest::SHA1.hexdigest(input.join)[0,16]
  end

end