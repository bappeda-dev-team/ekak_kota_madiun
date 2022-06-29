class LaporansController < ApplicationController
  def atasan
    # current_user == atasan
    # @users = User.asn_aktif
    @atasans = current_user.users.asn_aktif.includes([:sasarans])
  end
end
