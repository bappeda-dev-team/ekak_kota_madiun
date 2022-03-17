class UsulansController < ApplicationController
  def update_sasaran_asn
    sasaran = Sasaran.find params[:sasaran_id]
    usulan = params[:usulan_id].to_i
    usulan_type = params[:usulan_type]
    u = Usulan.create(usulanable_id: usulan, usulanable_type: usulan_type, sasaran: sasaran)
    respond_to do |format|
      format.js { render 'musrenbangs/update_sasaran_asn' } if u.save
    end
  end
end
