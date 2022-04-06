class RolesController < ApplicationController
  before_action :set_role, only: %i[edit update destroy]
  def index
    @roles = Role.all
  end

  def new
    @role = Role.new
  end

  def edit
    render 'new'
  end

  def create
    @role = Role.new(role_params)
    respond_to do |format|
      if @role.save
        format.html { redirect_to roles_path, notice: 'Role Berhasil ditambahkan' }
        format.json { render :show, status: :created, location: @role }
      else
        format.html { render :new, notice: 'Failed create role' }
        format.json { render json: @role.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      format.html { redirect_to roles_path, notice: 'Role berhasil diupdate' } if @role.update(role_params)
    end
  end

  def destroy
    @role.destroy
    respond_to do |format|
      format.html { redirect_to roles_path, notice: 'Role dihapus' }
    end
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit!
  end
end
