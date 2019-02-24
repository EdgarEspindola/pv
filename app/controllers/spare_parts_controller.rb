class SparePartsController < ApplicationController
  before_action :set_spare_part, only: [:show, :edit, :update, :destroy]
  before_action :fixed_format_price, only: [:create, :update]

  def index
    @spare_parts = SparePart.order(control_number: :desc)
  end

  def show
  end

  def new
    @spare_part = SparePart.new
  end

  def edit
  end

  def create
    @spare_part = SparePart.new(spare_part_params)

    respond_to do |format|
      if @spare_part.save
        flash[:success] = 'Refacción creada exitosamente.'
        format.html { redirect_to spare_parts_url }
      else
        flash[:error] = 'Proporcione los datos correctos.'
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @spare_part.update(spare_part_params)
        flash[:success] = 'Refacción actualizada exitosamente.'
        format.html { redirect_to spare_parts_url }
      else
        flash[:error] = 'Proporcione los datos correctos.'
        format.html { render :edit }
      end
    end
  end

  def destroy
    begin
      @spare_part.destroy
      respond_to do |format|
        flash[:success] = 'Refacción eliminada exitosamente.'
        format.html { redirect_to spare_parts_url }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = 'La Refacción ya esta en uso.'
      redirect_to spare_parts_url
    end

  end

  def autocomplete
    @spare_parts = SparePart.search(params[:term]).order(created_at: :desc)
  end

  def search
    @spare_parts = SparePart.search(params[:search]).order(created_at: :desc)
  end

  private

    def set_spare_part
      @spare_part = SparePart.find(params[:id])
    end


    def spare_part_params
      params.require(:spare_part).permit(:name, :description, :price, :total)
    end

    def fixed_format_price
      params[:spare_part][:price] = params[:spare_part][:price].gsub('$ ', '').gsub(',','')
    end

end
