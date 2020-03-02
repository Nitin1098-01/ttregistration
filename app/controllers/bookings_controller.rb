
class BookingsController < ApplicationController
  before_action :set_booking, only: [:show, :edit, :update, :destroy]

  # GET /bookings
  # GET /bookings.json
  def index
    @bookings = Booking.all
  end

  # GET /bookings/1
  # GET /bookings/1.json
  def show
  end

  # GET /bookings/new
  def new
   
    
    @booking = Booking.new
  end

  # GET /bookings/1/edit
  def edit
  end
  def ranges_overlap?(a, b)
    a.include?(b.begin) || b.include?(a.begin)
  end

  # POST /bookings
  # POST /bookings.json
  def create

  @booking = Booking.new(booking_params)
  
  start_time=@booking.start_time.time
  end_time=@booking.end_time.time

  # General case 1 : The starting time should always be lesser than the Ending time
  # General case 2 : One player should not play for more than 4 hours
 
  if start_time>=end_time || TimeDifference.between(start_time, end_time).in_hours > 4 || TimeDifference.between(start_time, end_time).in_minutes < 10
    flash[:notice]="Invalid BookingTime"
   return redirect_to new_booking_path
  end
 
 if Booking.where(:date=>@booking.date).select(:start_time,:end_time,:date).present?

  @b=Booking.where(:date=>@booking.date).select(:start_time,:end_time,:date)
 else
  @booking.save
  flash[:notice]="Booking saved"

  return redirect_to home_index_path
 end

  @count=0
  @b.each do |booking|

  
    if (start_time.hour..end_time.hour).overlaps?(booking.start_time.hour..booking.end_time.hour)
       @count=@count+1
       if(start_time.hour==booking.end_time.hour && start_time.min>=booking.end_time.min)
        @count=@count-1
       end
      
       if(end_time.hour==booking.start_time.hour && end_time.min<=booking.start_time.min)
        @count=@count-1
       end
    end

  end

  if @count<4
    flash[:notice]="Available"
    @booking.save
    redirect_to @booking
  else
    redirect_to new_booking_path
    flash[:notice]= "Slot not available"
  end

  end

  # PATCH/PUT /bookings/1
  # PATCH/PUT /bookings/1.json
  def update
    respond_to do |format|
      if @booking.update(booking_params)
        format.html { redirect_to @booking, notice: 'Booking was successfully updated.' }
        format.json { render :show, status: :ok, location: @booking }
      else
        format.html { render :edit }
        format.json { render json: @booking.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookings/1
  # DELETE /bookings/1.json
  def destroy
    @booking.destroy
    respond_to do |format|
      format.html { redirect_to bookings_url, notice: 'Booking was successfully destroyed.' }
      format.json { head :no_content }
    end
  end


  def available
    @available = Booking.where(:date=>params[:date]).order(:start_time)
    redirect_to home_index_path
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_booking
      @booking = Booking.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def booking_params
     
      params.require(:booking).permit(:start_time, :end_time, :date)
    end
end
