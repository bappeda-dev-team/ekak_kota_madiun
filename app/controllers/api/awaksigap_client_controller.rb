module Api
  class AwaksigapClientController < ApplicationController
    def sync_inovasi_masyarakat
      UpdateInovasiMasyarakatJob.perform_later
      after_job "Update Inovasi Masyarakat Dikerjakan. Harap menunggu..."
    end

    private

    def after_job(message)
      flash.now[:success] = message
      render 'shared/_notifikasi_simple'
    end
  end
end
