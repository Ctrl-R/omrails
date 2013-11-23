class PinimagesController < ApplicationController
  before_filter :authenticate_user!, except: [:show]
  # GET /pinimages
  # GET /pinimages.json
  def index
    @pinimages = Pinimage.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pinimages }
    end
  end

  # GET /pinimages/1
  # GET /pinimages/1.json
  def show
    @pinimage = Pinimage.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pinimage }
    end
  end

  # GET /pinimages/new
  # GET /pinimages/new.json
  def new
    @pinimage = Pinimage.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pinimage }
    end
  end

  # GET /pinimages/1/edit
  def edit
    @pinimage = Pinimage.find(params[:id])
  end

  # POST /pinimages
  # POST /pinimages.json
  def create
    @pin = Pin.find(params[:pin_id])
    @pinimage = @pin.pinimages.create(params[:pinimage])
    redirect_to pin_path(@pin)

#    respond_to do |format|
#      if @pinimage.save
#        format.html { redirect_to @pinimage, notice: 'Pin image was successfully created.' }
#        format.json { render json: @pinimage, status: :created, location: @pinimage }
#      else
#        format.html { render action: "new" }
#        format.json { render json: @pinimage.errors, status: :unprocessable_entity }
#      end
#    end
  end

  # PUT /pinimages/1
  # PUT /pinimages/1.json
  def update
    @pinimage = Pinimage.find(params[:id])

    respond_to do |format|
      if @pinimage.update_attributes(params[:pinimage])
        format.html { redirect_to @pinimage, notice: 'Pin image was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pinimage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /pinimages/1
  # DELETE /pinimages/1.json
  def destroy
    @pinimage = Pinimage.find(params[:id])
    @pinimage.destroy

    respond_to do |format|
      format.html { redirect_to pinimages_url }
      format.json { head :no_content }
    end
  end
end
