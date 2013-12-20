class ClubsController < ApplicationController
  before_filter :authenticate_user!
  # GET /clubs
  # GET /clubs.json
  helper_method :sort_column, :sort_direction, :filter_location
  
  def index
    if filter_location.blank?
      @clubs = Club.order(sort_column + " " + sort_direction).search(params[:search])
    else
      @clubs = Club.order(sort_column + " " + sort_direction).where(location: filter_location).search(params[:search])
    end

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
    if current_user.id == @club.admin or current_user.admin?
      if @club.userlist.size == 1
        @club.destroy
        redirect_to clubs_path, notice: @club.name + ' has been closed.'
      else
        redirect_to club_path(@club), notice: 'You cannot close a group that has more than one member.'
      end
    end
  end
  
  def reportabuse
    @user = current_user
    @club = Club.find(params[:id])
    if user_signed_in?
      UserMailer.report_club(@user, @club).deliver
      redirect_to @club, notice: @club.name + ' has been reported to administration.'
    else
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
    else
      redirect_to edit_club_path(@club), notice: 'Only current admin can do that!'
    end
  end
  
  def changeadmin
    @user = current_user
    @club = Club.find(params[:id])
    @newadmin = User.find(params[:changeadminuser])
    if user_signed_in? and (@club.admin == @user.id)
      if @club.userlist.include?(@newadmin.id)
        @club.admin = @newadmin.id
        @club.save
        UserMailer.changeadminnotice(@user, @newadmin, @club).deliver
        redirect_to club_path(@club), notice: @newadmin.name + ' has been set as admin of ' + @club.name + '.'
      else
        redirect_to edit_club_path(@club), notice: 'New admin must be a current member of ' + @club.name + '.'
      end
    else
      redirect_to edit_club_path(@club), notice: 'Only current admin of ' + @club.name + ' can transfer admin rights!'
    end
  end
  
  def removemember
    @user = current_user
    @club = Club.find(params[:id])
    @removemember = User.find(params[:removeuser])
    if user_signed_in? and (@club.admin == @user.id)
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
    else
      redirect_to edit_club_path(@club), notice: 'Only current admin can do that!'
    end
  end
  
  def leaveclub
    @user = current_user
    @club = Club.find(params[:id])
    if user_signed_in?
      if @club.admin != @user.id
        if @club.userlist.include?(@user.id)
          @club.userlist.delete(@user.id)
          @club.save
          redirect_to clubs_path, notice: 'You have left ' + @club.name + '.'
        else
          redirect_to clubs_path, notice: 'You are not a member of that club.'
        end
      else
        redirect_to club_path(@club), notice: 'Current admin cannot leave, please transfer admin rights first.'
      end
    else
      redirect_to new_user_session_path
    end
  end
  
  def banmember
    @user = current_user
    @club = Club.find(params[:id])
    @banmember = User.find(params[:banuser])
    if user_signed_in? and (@club.admin == @user.id)
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
    else
      redirect_to edit_club_path(@club), notice: 'Only current admin can do that!'
    end
  end
  
  def filter_location
    Club.uniq.pluck(:location).include?(params[:locationfilter]) ? params[:locationfilter] : nil
  end
  
  def sort_column
    Club.column_names.include?(params[:sort]) ? params[:sort] : "name"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end
  
end
