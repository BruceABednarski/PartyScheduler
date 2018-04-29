class PartiesController < ApplicationController
  def index
    @parties = Array.new

    if !params[:sort].blank?
      order = "#{params[:sort]} #{(params[:asc].blank? || params[:asc] == 'true') ? 'DESC' : 'ASC'}"
      Party.order(order).all.each do |party|
        @parties << party
      end
    else
      order = "[when] #{(params[:asc].blank? || params[:asc] == 'true') ? 'DESC' : 'ASC'}"
      @parties = Party.order(order).all
    end
  end

  def new
    @party = Party.new
    # so the view shows 0 and not blank
    @party.numgsts = 0
  end

  def create
    @party = Party.new
    if params[:party][:numgsts].blank?
      params[:party][:numgsts]=0
    end

   #@party.attributes = params[:party]
    @party.attributes = party_params

    if @party.save
        # if end is blank, set to end of day
      if @party.when_its_over.blank?
        @party.when_its_over=@party.when.end_of_day
        @party.save
      end
      @party.after_save
     flash[:notice]=""
     redirect_to parties_url
    else
     flash[:notice]="Party was incorrect."
     redirect_to new_party_url
    end
  end
   def party_params
    params[:party].permit(:host_name, :host_email, :numgsts, :guest_names, :venue, :location, :theme, :when, :when_its_over, :descript)
  end

end
