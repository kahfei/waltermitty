class OrdersController < ApplicationController
  include CurrentCart
  before_action :set_cart, only: [:new, :create]
  before_action :set_order, only: [:show, :edit, :update, :destroy]

  # GET /orders
  # GET /orders.json
  def index
    @orders = Order.all
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
  end

  # GET /orders/new
  def new
    if @cart.line_items.empty?
      redirct_to store_url, notice: "Your cart is empty"
      return
    end
    @order = Order.new
  end

  # GET /orders/1/edit
  def edit
  end

  # POST /orders
  # POST /orders.json
  # def create
  #   @order = Order.new(order_params)
  #   @order.add_line_items_from_cart(@cart)
  #   # @order = current_cart.build_order(params[:order])
  #   @order.ip_address = request.remote_ip

  #   respond_to do |format|
  #     if @order.save
  #       if @order.purchase
  #         Cart.destroy(session[:cart_id])
  #         session[:cart_id] = nil
  #         format.html { redirect_to store_url, notice: 'Thank you for your order.' }
  #         format.json { render :show, status: :created, location: @order }
  #         render :action => "sucess"
  #       else
  #         render :action => "failure"
  #       end
  #     else
  #       format.html { render :new }
  #       format.json { render json: @order.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def create
    @order = current_cart.build_order(order_params)
    @order.ip_address = request.remote_ip
    if @order.save
      if @order.purchase
        Cart.destroy(session[:cart_id])
        session[:cart_id] = nil
        render :action => "success"
      else
        render :action => "failure"
      end
    else
      render :action => 'new'
    end
  end

  # PATCH/PUT /orders/1
  # PATCH/PUT /orders/1.json
  def update
    respond_to do |format|
      if @order.update(order_params)
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
        format.json { render :show, status: :ok, location: @order }
      else
        format.html { render :edit }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order.destroy
    respond_to do |format|
      format.html { redirect_to orders_url, notice: 'Order was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_order
      @order = Order.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def order_params
      params.require(:order).permit(:name, :address, :email, 
        :pay_type, :card_number, :card_verification, :card_expires, 
        :card_type, :first_name, :last_name )
    end
end


