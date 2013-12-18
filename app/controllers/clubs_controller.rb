class ClubsController < ApplicationController
  before_filter :authenticate_user!
  # GET /clubs
  # GET /clubs.json
  def index
    @clubs = Club.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clubs }
    end
  end

  # GET /clubs/1
  # GET /clubs/1.json
  def show
    @club = Club.find(params[:id])
    @pins = Pin.where('user_id in (?)', @club.userlist)

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @club }
    end
  end

  # GET /clubs/new
  # GET /clubs/new.json
  def new
    @club = Club.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @club }
    end
  end

  # GET /clubs/1/edit
  def edit
    @club = Club.find(params[:id])
  end

  # POST /clubs
  # POST /clubs.json
  def create
    @club = Club.new(params[:club])
    @club.userlist = @club.userlist.push(current_user.id)
    @club.admin = current_user.id

    respond_to do |format|
      if @club.save
        format.html { redirect_to @club, notice: 'Club was successfully created.' }
        format.json { render json: @club, status: :created, location: @club }
      else
        format.html { render action: "new" }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /clubs/1
  # PUT /clubs/1.json
  def update
    @club = Club.find(params[:id])

    respond_to do |format|
      if @club.update_attributes(params[:club])
        format.html { redirect_to @club, notice: 'Club was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @club.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /clubs/1
  # DELETE /clubs/1.json
  def destroy
    @club = Club.find(params[:id])
    @club.destroy

    respond_to do |format|
      format.html { redirect_to clubs_url }
      format.json { head :no_content }
    end
  end
  
  def joinclub
    @user = current_user
    @club = Club.find(params[:id])
    if user_signed_in?
      if @club.listed?
        if !@club.banneduser.include?(@user.id)
          if !@club.userlist.include?(@user.id)
            @club.userlist = @club.userlist.push(@user.id)
            @club.save
            redirect_to @club, notice: 'Welcome to ' + @club.name + '!'
          end
        else
          redirect_to clubs_path, notice: 'You have been banned from ' + @club.name + '.'
        end
      else
        if !@club.banneduser.include?(@user.id)
          if !@club.pendinguser.include?(@user.id)
            @club.pendinguser = @club.pendinguser.push(@user.id)
            @club.save
            UserMailer.requestmembership(@user, @club).deliver
            redirect_to clubs_path, notice: 'Your request to join ' + @club.name + ' has been sent to the administrator.'
          else
            redirect_to clubs_path, notice: 'Your request to join ' + @club.name + ' is still pending.'
          end
        else
          redirect_to clubs_path, notice: 'You have been banned from ' + @club.name + '.'
        end
      end
    end
  end
  
  def approvemember
    @user = current_user
    @club = Club.find(params[:id])
    @newmember = User.find(params[:newuser])
    if user_signed_in?
      if !@club.userlist.include?(@newmember.id)
        @club.userlist.push(@newmember.id)
        @club.pendinguser.delete(@newmember.id)
        @club.save
        UserMailer.membershipapproved(@user, @club).deliver
        redirect_to edit_club_path(@club), notice: @newmember.name + ' has been approved.'
      end
    end
  end
  
  def removemember
    @user = current_user
    @club = Club.find(params[:id])
    @removemember = User.find(params[:removeuser])
    if user_signed_in?
      if @club.admin != @removemember.id
        if @club.userlist.include?(@removemember.id)
          @club.userlist.delete(@removemember.id)
          @club.save
          redirect_to edit_club_path(@club), notice: @removemember.name + ' has been removed.'
        else
          @club.pendinguser.delete(@removemember.id)
          @club.save
          redirect_to edit_club_path(@club), notice: @removemember.name + ' has been denied membership.'
        end
      else
        redirect_to edit_club_path(@club), notice: 'Current admin cannot be removed.'
      end
    end
  end
  
  def banmember
    @user = current_user
    @club = Club.find(params[:id])
    @banmember = User.find(params[:banuser])
    if user_signed_in?
      if @club.admin != @banmember.id
        if @club.userlist.include?(@banmember.id)
          @club.userlist.delete(@banmember.id)
          @club.banneduser.push(@banmember.id)
          @club.save
          redirect_to edit_club_path(@club), notice: @banmember.name + ' has been banned.'
        else
          if @club.pendinguser.include?(@banmember.id)
            @club.pendinguser.delete(@banmember.id)
            @club.banneduser.push(@banmember.id)
            @club.save
            redirect_to edit_club_path(@club), notice: @banmember.name + ' has been banned.'
          else  
            if @club.banneduser.include?(@banmember.id)
              @club.banneduser.delete(@banmember.id)
              @club.save
              redirect_to edit_club_path(@club), notice: @banmember.name + ' has been unbanned.'
            end
          end
        end
      else
        redirect_to edit_club_path(@club), notice: 'Current admin cannot be banned.'
      end
    end
  end
  
end
