class MedicineSchedulesController < ApplicationController
  before_action :set_patient
  before_action :set_medicine_schedule, only: [:show, :edit, :update]

  def new
    @medicine_schedule = MedicineSchedule.new
  end

  def show
  end

  def create
    @medicine_schedule = @patient.medicine_schedules.build(medicine_schedule_params)
    if @medicine_schedule.save
      redirect_to patient_path(@patient), notice: "Medicine schedule was successfully created."
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @medicine_schedule.update(medicine_schedule_params)
      redirect_to patient_path(@patient), notice: "Medicine schedule was successfully updated."
    else
      render :edit
    end
  end

  private

  def set_patient
    @patient = Patient.find(params[:patient_id])
  end

  def set_medicine_schedule
    @medicine_schedule = MedicineSchedule.find(params[:id])
  end

  def medicine_schedule_params
    params.require(:medicine_schedule).permit(:disease, :start_date, :end_date, :status)
  end
  
end
