class UsulansController < ApplicationController
  def update_sasaran_asn
    sasaran = params[:sasaran_id]
    usulan = params[:usulan_id].to_i
    usulan_type = params[:usulan_type]
    u = Usulan.create(usulanable_id: usulan, usulanable_type: usulan_type, sasaran_id: sasaran)
    usulan = usulan_type.constantize.find(usulan)
    sasaran_permasalahan = Sasaran.find(sasaran)
    respond_to do |format|
      if u.save && usulan.update(sasaran_id: sasaran)
        sasaran_permasalahan.rincian.create_or_update(permasalahan_umum: usulan.uraian)
        format.js { render 'update_sasaran_asn' }
      else
        format.js { render 'update_sasaran_asn', status: :unprocessable_entity }
      end
    end
  end

  def hapus_usulan_dari_sasaran
    usulan = params[:usulan_id].to_i
    usulan_type = params[:usulan_type]
    u = Usulan.find_by(usulanable_id: usulan)
    usulan = usulan_type.constantize.find(usulan)
    u.destroy
    usulan.update(sasaran_id: nil)
    respond_to do |format|
        format.js { render 'update_sasaran_asn' }
      end
  end
end
