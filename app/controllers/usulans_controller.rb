class UsulansController < ApplicationController
  def update_sasaran_asn
    sasaran = params[:sasaran_id]
    usulan = params[:usulan_id].to_i
    usulan_type = params[:usulan_type]
    u = Usulan.create(usulanable_id: usulan, usulanable_type: usulan_type, sasaran_id: sasaran)
    respond_to do |format|
      if u.save
        format.js { render 'musrenbangs/update_sasaran_asn' }
      else
        format.js { render 'musrenbangs/update_sasaran_asn', status: :unprocessable_entity }
      end
    end
  end
end
