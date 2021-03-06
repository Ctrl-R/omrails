class PinsController < ApplicationController
  before_filter :authenticate_user!, except: [:index, :show, :showforloan, :showforsale]
  
  # GET /pins
  # GET /pins.json
  
  def index
    if filter_categories.blank?
      @pins = Pin.page(params[:page]).per_page(20).where(:publicgear => true).search(params[:search])
    else
      @pins = Pin.page(params[:page]).per_page(20).where(category: filter_categories, :publicgear => true).search(params[:search])
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @pins }
    end
  end

  def showforloan
    if filter_categories.blank?
      @pins = Pin.page(params[:page]).per_page(20).where(:publicgear => true, :forloan => true).search(params[:search])
    else
      @pins = Pin.page(params[:page]).per_page(20).where(:forloan => true, category: filter_categories, :publicgear => true).search(params[:search])
    end

    respond_to do |format|
      format.html # showforloan.html.erb
      format.json { render json: @pins }
    end
  end

  def showforsale
    if filter_categories.blank?
      @pins = Pin.page(params[:page]).per_page(20).where(:forsale => true, :publicgear => true).search(params[:search])
    else
      @pins = Pin.page(params[:page]).per_page(20).where(:forsale => true, category: filter_categories, :publicgear => true).search(params[:search])
    end

    respond_to do |format|
      format.html # showforsale.html.erb
      format.json { render json: @pins }
    end
  end

  # GET /pins/1
  # GET /pins/1.json
  def show
    @pin = Pin.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @pin }
    end
  end

  # GET /pins/new
  # GET /pins/new.json
  def new
    @userclubs = Club.where('userlist like ?', ("% " + current_user.id.to_s + "\n%"))
    @pin = current_user.pins.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @pin }
    end
  end

  # GET /pins/1/edit
  def edit
    @userclubs = Club.where('userlist like ?', ("% " + current_user.id.to_s + "\n%"))
    if current_user == Pin.find(params[:id]).user
      @pin = current_user.pins.find(params[:id])
    else
      if current_user.admin
        @pin = Pin.find(params[:id])
      end
    end
  end

  # POST /pins
  # POST /pins.json
  def create
    @pin = current_user.pins.new(params[:pin])

    respond_to do |format|
      if @pin.save
        format.html { redirect_to @pin, notice: 'Pin was successfully created.' }
        format.json { render json: @pin, status: :created, location: @pin }
      else
        format.html { render action: "new" }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /pins/1
  # PUT /pins/1.json
  def update
    if current_user == Pin.find(params[:id]).user
      @pin = current_user.pins.find(params[:id])
    else
      if current_user.admin
        @pin = Pin.find(params[:id])
      end
    end

    respond_to do |format|
      if @pin.update_attributes(params[:pin])
        format.html { redirect_to @pin, notice: 'Pin was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @pin.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # DELETE /pins/1
  # DELETE /pins/1.json
  def destroy
    if current_user == Pin.find(params[:id]).user
      @pin = current_user.pins.find(params[:id])
    else
      if current_user.admin
        @pin = Pin.find(params[:id])
      end
    end
    @pin.destroy

    respond_to do |format|
      format.html { redirect_to pins_url }
      format.json { head :no_content }
    end
  end
  
  def favoritelist
    @user = current_user
    @favorites = @user.favorites
    @pins = Pin.page(params[:page]).per_page(20).find(:all, :conditions => ["pins.id IN (?)", @favorites])

    respond_to do |format|
      format.html # favoritelist.html.erb
      format.json { render json: @pins }
    end
  end
  
  def startoggle
    @user = current_user
    @favorites = @user.favorites
    @pin = Pin.find(params[:id])
    if user_signed_in?
      if !@favorites.blank?
        if !@favorites.include?(@pin.id)
          @favorites.push(@pin.id)
          @user.save
          redirect_to @pin, notice: 'Item has been added to favorites.'
        else
          @favorites.delete(@pin.id)
          @user.save
          redirect_to @pin, notice: 'Item has been removed from favorites.'
        end
      else
        @favorites.push(@pin.id)
        @user.save
        redirect_to @pin, notice: 'Item has been added to favorites.'
      end
    else
    end
  end
  
  def filter_categories
    Pin.uniq.pluck(:category).include?(params[:catfilter]) ? params[:catfilter] : nil
  end
  
  def sendrequest
    @user = current_user
    @pin = Pin.find(params[:id])
    if user_signed_in?
      UserMailer.request_pin(@user, @pin).deliver
      redirect_to @pin, notice: 'Request for contact sent.'
    else
    end
  end
  
  def reportabuse
    @user = current_user
    @pin = Pin.find(params[:id])
    if user_signed_in?
      UserMailer.report_pin(@user, @pin).deliver
      redirect_to @pin, notice: 'This pin has been reported to administration.'
    else
    end
  end
  
end
