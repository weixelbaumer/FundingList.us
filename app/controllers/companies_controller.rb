class CompaniesController < ApplicationController
  respond_to :json, :html
  def index
    @companies = Company.where(:featured => true)
    respond_to do |format|
      format.html
      format.json { render :json => Company.all.to_json }
    end
  end

  def show
    @company = Company.find(params[:id])
    respond_with @company
  end

  def create
    @company = Company.create(params[:company])
    if @company
      respond_with @company
    else
      render :status => 500
    end
  end

  def subscribe
    @email = EmailUpdate.create(:email => params[:email], :company_id => params[:id]) if EmailUpdate.where(:email => params[:email], :company_id => params[:id]).empty?
    respond_to do |format|
      format.html { redirect_to '/'}
      format.json { render :json => @email }
    end
  end

  def unsubscribe
    @email = EmailUpdate.where(:email => params[:email]).each { |email| email.destroy }
    respond_to do |format|
      format.html { redirect_to '/', :notice => "You won't receive any more emails from FundingList" }
      format.json { render :json => nil}
    end
  end

  def search
    @results = Company.where("name like ?", "#{params[:query]}%").limit(8) unless params[:query] == ''
    respond_to do |format|
      format.json
    end
  end
end
