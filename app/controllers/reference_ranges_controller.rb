# frozen_string_literal: true

class ReferenceRangesController < ApplicationController
  before_action :set_reference_range, only: %i[show edit update destroy]
  before_action :set_biomarker, only: %i[new create]

  # GET /reference_ranges or /reference_ranges.json
  def index
    authorize ReferenceRange
    @reference_ranges = policy_scope(ReferenceRange.all)
  end

  # GET /reference_ranges/1 or /reference_ranges/1.json
  def show
    authorize @reference_range
  end

  # GET /reference_ranges/new
  def new
    @reference_range = @biomarker.reference_ranges.build
    authorize @reference_range
  end

  # GET /reference_ranges/1/edit
  def edit
    authorize @reference_range
  end

  # POST /reference_ranges or /reference_ranges.json
  def create
    @reference_range = @biomarker.reference_ranges.new(reference_range_params)
    authorize @reference_range

    respond_to do |format|
      if @reference_range.save
        format.html { redirect_to @biomarker, notice: t('.success') }
        format.json { render :show, status: :created, location: @reference_range }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @reference_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /reference_ranges/1 or /reference_ranges/1.json
  def update
    authorize @reference_range

    respond_to do |format|
      if @reference_range.update(reference_range_params)
        format.html { redirect_to @reference_range, notice: t('.success') }
        format.json { render :show, status: :ok, location: @reference_range }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @reference_range.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /reference_ranges/1 or /reference_ranges/1.json
  def destroy
    authorize @reference_range
    @reference_range.destroy!

    respond_to do |format|
      format.html do
        redirect_back_or_to reference_range_path,
                            status: :see_other, notice: 'Reference range was successfully removed.'
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_reference_range
    @reference_range = ReferenceRange.find(params[:id])
  end

  def set_biomarker
    @biomarker = Biomarker.find(params[:biomarker_id])
  end

  # Only allow a list of trusted parameters through.
  def reference_range_params
    params
      .require(:reference_range)
      .permit(:biomarker_id, :min_value, :max_value, :unit, :source, :created_at, :updated_at)
  end
end
