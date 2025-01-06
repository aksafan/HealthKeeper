# frozen_string_literal: true

class MeasurementsController < ApplicationController
  before_action :set_measurement, only: %i[show edit update destroy]
  before_action :build_measurement, only: %i[create]

  # GET /measurements or /measurements.json
  def index
    authorize Measurement
    @measurements = policy_scope(Measurement).where(user_id: @chosen_user_id)
  end

  # GET /measurements/1 or /measurements/1.json
  def show
    authorize @measurement
  end

  # GET /measurements/new
  def new
    @measurement = Measurement.new
    authorize @measurement
  end

  # GET /measurements/1/edit
  def edit
    authorize @measurement
  end

  # POST /measurements or /measurements.json
  def create
    authorize @measurement

    respond_to do |format|
      if @measurement.save
        format.html { redirect_to @measurement, notice: t('.success') }
        format.json { render :show, status: :created, location: @measurement }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /measurements/1 or /measurements/1.json
  def update
    authorize @measurement

    respond_to do |format|
      if @measurement.update(measurement_params)
        format.html { redirect_to @measurement, notice: t('.success') }
        format.json { render :show, status: :ok, location: @measurement }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @measurement.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /measurements/1 or /measurements/1.json
  def destroy
    authorize @measurement
    @measurement.destroy!

    respond_to do |format|
      if request.referer == measurement_url
        format.html do
          redirect_to measurements_path, status: :see_other, notice: t('.success')
        end
      else
        format.html do
          redirect_back_or_to measurement_path, status: :see_other, notice: t('.success')
        end
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_measurement
    @measurement = Measurement.find(params[:id])
  end

  def build_measurement
    @measurement = current_user.measurements.build(measurement_params)
  end

  # Only allow a list of trusted parameters through.
  def measurement_params
    params
      .require(:measurement)
      .permit(:user_id, :type, :value, :source, :recordable_type, :recordable_id, :notes, :created_at, :updated_at)
  end
end
