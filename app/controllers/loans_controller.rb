class LoansController < ApplicationController
  before_filter :authenticate_user!
  before_filter :set_loans

  helper_method :sort_column, :sort_direction

  def set_loans
    @loans = current_user.admin? ? Loan.order(sort_column + " " + sort_direction) : current_user.loans.order(sort_column + " " + sort_direction)
  end
  # GET /loans
  # GET /loans.json
  def index
    #@loans = Loan.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @loans }
    end
  end

  # GET /loans/1
  # GET /loans/1.json
  def show
    @loan = Loan.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @loan }
    end
  end

  # GET /loans/new
  # GET /loans/new.json
  def new
    @loan = Loan.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @loan }
    end
  end

  # GET /loans/1/edit
  def edit
    @loan = Loan.find(params[:id])
  end

  # POST /loans
  # POST /loans.json
  def create
    @pin = Pin.find(params[:pin_id])
    @loan = @pin.loans.create(params[:loan])
    @loan.user_id = current_user.id
    @loan.save
    redirect_to pin_path(@pin)
  end

  # PUT /loans/1
  # PUT /loans/1.json
  def update
    @loan = Loan.find(params[:id])

    respond_to do |format|
      if @loan.update_attributes(params[:loan])
        format.html { redirect_to @loan, notice: 'Loan was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @loan.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /loans/1
  # DELETE /loans/1.json
  def destroy
    @loan = Loan.find(params[:id])
    @pin = Pin.find(@loan.pin_id)
    @loan.destroy

    respond_to do |format|
      format.html { redirect_to pin_path(@pin) }
      format.json { head :no_content }
    end
  end
  
  private
  
  def sort_column
    Loan.column_names.include?(params[:sort]) ? params[:sort] : "loanedOn"
  end
  
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end
  
end
