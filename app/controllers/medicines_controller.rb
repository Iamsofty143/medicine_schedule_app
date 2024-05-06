class MedicinesController < ApplicationController
  include ErrorHandler
  include ScheduleEmailNotificationConcern

  before_action :find_patient
  before_action :find_medicine_schedule
  before_action :find_medicine, only: [:edit, :update, :destroy]

  def new
    @frequency = params["frequency"]
    if @frequency == "custom"
      @slot_type = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
    else
      @slot_type = ["Time"]
    end
    @medicine = Medicine.new
  end

  def create
    @medicine = @medicine_schedule.medicines.build(medicine_params)
    schedule_hash = JSON.parse(params["medicine"]["schedule"]) if params["medicine"]["schedule"].present?
    @medicine.schedule = schedule_hash if schedule_hash
    if @medicine.save
      data = schedule_notification(@medicine, @medicine.start_date)
      if data[:next_schedule]
        time_to_perform = Time.parse(data[:time_difference]) - 15.minutes
        MedicationJob.perform_at(time_to_perform, @medicine.id, @medicine_schedule.patient.id )
      end
      redirect_to patient_medicine_schedule_path(@patient, @medicine_schedule), notice: "Medicine was successfully added."
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def destroy
    @medicine.destroy
    redirect_to patient_medicine_schedule_medicines_path(@patient, @medicine_schedule), notice: "Medicine was successfully deleted."
  end

  def update
  end

  private

  def find_patient
    @patient = Patient.find(params[:patient_id])
  end

  def find_medicine
    @medicine = @medicine_schedule.medicines.find(params[:id])
  end

  def find_medicine_schedule
    @medicine_schedule = @patient.medicine_schedules.find(params[:medicine_schedule_id])
  end

  def medicine_params
    params.require(:medicine).permit(
      :name, 
      :frequency, 
      :number_of_frequency, 
      :number_of_pill, 
      :schedule, 
      :status, 
      :start_date, 
      :end_date,
      medicine_schedule_attributes: [:id] # Add other permitted attributes as needed
    )
  end

end
