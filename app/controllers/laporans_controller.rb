class LaporansController < ApplicationController
  def atasan
    return unless current_user.instance_of?(Atasan)

    @sasarans = current_user.users.asn_aktif.map { |u| u.sasarans.group_by(&:user) }
  end
end
