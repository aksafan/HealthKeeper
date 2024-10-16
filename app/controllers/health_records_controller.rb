class HealthRecordsController < ApplicationController
  before_action :set_health_record, only: %i[ show edit update destroy ]

  # GET /health_records or /health_records.json
  def index
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
    @health_record = current_user.health_records.build(health_record_params)
    authorize @health_record

    respond_to do |format|
      if @health_record.save
        format.html { redirect_to @health_record, notice: "Health record was successfully created." }
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
        format.html { redirect_to @health_record, notice: "Health record was successfully updated." }
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
      format.html { redirect_to health_records_path, status: :see_other, notice: "Health record was successfully removed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_health_record
    @health_record = HealthRecord.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def health_record_params
    params.require(:health_record).permit(:user_id, :notes, :created_at, :updated_at)
  end
end
