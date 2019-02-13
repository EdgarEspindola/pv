class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]
  before_action :fixed_format_price, only: [:create, :update]

  # GET /products
  # GET /products.json
  def index
    @products = Product.order(updated_at: :desc)
  end

  # GET /products/1
  # GET /products/1.json
  def show
  end

  # GET /products/new
  def new
    @product = Product.new
  end

  # GET /products/1/edit
  def edit
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        flash[:success] = 'Producto creado correctamente.'
        format.html { redirect_to products_url }
        format.json { render :show, status: :created, location: @product }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /products/1
  # PATCH/PUT /products/1.json
  def update
    respond_to do |format|
      if @product.update(product_params)
        flash[:success] = 'Producto actualizado correctamente.'
        format.html { redirect_to products_url }
        format.json { render :show, status: :ok, location: @product }
      else
        flash[:error] = 'Proporciona los datos correctos.'
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    begin
      @product.destroy
      respond_to do |format|
        flash[:success] = 'Producto eliminado correctamente.'
        format.html { redirect_to products_url }
        format.json { head :no_content }
      end
    rescue ActiveRecord::InvalidForeignKey => exception
      flash[:error] = "El producto ya esta en uso."
      redirect_to products_url
    end
  end

  def search
    @products = Product.search(params[:search]).order(created_at: :desc)
  end

  def search_sales
    product = Product.search_for_sales(params[:search]).order(created_at: :desc).first
    @new_product = false

    if product.present?
      if product.is_available?(1)
        if current_user.pending_in_sale?(product.code)
          @product = adjust_product_in_sale(product)
        else
          @product = adjust_new_product_to_sale(product)
          @new_product = true
        end
      else
          render js: "toastr['error']('Producto no disponible.');", status: :bad_request
      end
    else
      render js: "toastr['error']('Producto no encontrado.');", status: :bad_request
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_product
      @product = Product.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def product_params
      params.require(:product).permit(:code, :name, :quantity, :price)
    end

    def fixed_format_price
        params[:product][:price] = params[:product][:price].gsub('$ ', '').gsub(',','')
    end

    def adjust_product_in_sale(product)
      sale_product = current_user.give_me_product(product.code)
      sale_product.adjust_quantity(1)
      product.decrement_total
      sale_product
    end

    def adjust_new_product_to_sale(product)
      sale_product = SaleProduct.new_from(product)
      sale_product.user = current_user
      sale_product.save
      product.decrement_total
      sale_product
    end

end