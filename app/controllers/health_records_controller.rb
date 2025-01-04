# frozen_string_literal: true

class HealthRecordsController < ApplicationController
  before_action :set_health_record, only: %i[show edit update destroy]
  before_action :build_health_record, only: %i[create]

  # GET /health_records or /health_records.json
  def index
    authorize HealthRecord
    @health_records = policy_scope(HealthRecord.all)
  end

  # GET /health_records/1 or /health_records/1.json
  def show
    authorize @health_record
  end

  # GET /health_records/new
  def new
    @health_record = HealthRecord.new
    authorize @health_record
  end

  # GET /health_records/1/edit
  def edit
    authorize @health_record
  end

  # POST /health_records or /health_records.json
  def create
    authorize @health_record

    respond_to do |format|
      if @health_record.save
        format.html { redirect_to @health_record, notice: t('.success') }
        format.json { render :show, status: :created, location: @health_record }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @health_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /health_records/1 or /health_records/1.json
  def update
    authorize @health_record

    respond_to do |format|
      if @health_record.update(health_record_params)
        format.html { redirect_to @health_record, notice: t('.success') }
        format.json { render :show, status: :ok, location: @health_record }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @health_record.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /health_records/1 or /health_records/1.json
  def destroy
    authorize @health_record
    @health_record.destroy!

    respond_to do |format|
      format.html do
        redirect_to health_records_path, status: :see_other, notice: t('.success')
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_health_record
    @health_record = HealthRecord.find(params[:id])
  end

  def build_health_record
    @health_record = current_user.health_records.build(health_record_params)
  end

  # Only allow a list of trusted parameters through.
  def health_record_params
    params.require(:health_record).permit(:user_id, :notes, :created_at, :updated_at)
  end
end
