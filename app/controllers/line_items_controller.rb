class LineItemsController < ApplicationController
	skip_before_filter :authorize, :only => :create
	
  # GET /line_items
  # GET /line_items.xml
  def index
    @line_items = LineItem.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @line_items }
    end
  end

  # GET /line_items/1
  # GET /line_items/1.xml
  def show
    @line_item = LineItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @line_item }
    end
  end

  # GET /line_items/new
  # GET /line_items/new.xml
  def new
    @line_item = LineItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @line_item }
    end
  end

  # GET /line_items/1/edit
  def edit
    @line_item = LineItem.find(params[:id])
  end

  # POST /line_items
  # POST /line_items.xml
  def create
  	@cart = current_cart
  	product = Product.find(params[:product_id])
  	@line_item = @cart.add_product(product.id)

    respond_to do |format|
      if @line_item.save
        format.html { redirect_to(store_url) }
        format.js		{ @current_item = @line_item }
        format.xml  { render :xml => @line_item, :status => :created, :location => @line_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @line_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /line_items/1
  # PUT /line_items/1.xml
  def update
  	@cart = current_cart
    @line_item = LineItem.find(params[:id])
     if @line_item.quantity > 1
    	@line_item.quantity -= 1
    	respond_to do |format|
				if @line_item.update_attributes(params[:id])
					format.html { redirect_to(store_url) }
					format.js
					format.xml  { head :ok }
				else
					format.html { redirect_to(store_url) }
					format.xml  { render :xml => @cart.errors, :status => :unprocessable_entity }
				end
			end
    else
			respond_to do |format|
				format.html { redirect_to(store_url) }
				format.js
				format.xml  { head :ok }
			end
		end
  end

  # DELETE /line_items/1
  # DELETE /line_items/1.xml
  def destroy
  	@cart = current_cart

    @line_item = LineItem.find(params[:id])
		@line_item.destroy
		respond_to do |format|
			format.html { redirect_to(store_url) }
			format.js { @cart_size = @cart.total_items }
			format.xml  { head :ok }
		end
  end
end
