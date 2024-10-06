class BiomarkersController < ApplicationController
  before_action :set_biomarker, only: %i[ show edit update destroy ]

  # GET /biomarkers or /biomarkers.json
  def index
    @biomarkers = Biomarker.all
  end

  # GET /biomarkers/1 or /biomarkers/1.json
  def show
  end

  # GET /biomarkers/new
  def new
    @biomarker = Biomarker.new
  end

  # GET /biomarkers/1/edit
  def edit
  end

  # POST /biomarkers or /biomarkers.json
  def create
    @biomarker = Biomarker.new(biomarker_params)

    respond_to do |format|
      if @biomarker.save
        format.html { redirect_to @biomarker, notice: "Biomarker was successfully created." }
        format.json { render :show, status: :created, location: @biomarker }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @biomarker.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /biomarkers/1 or /biomarkers/1.json
  def update
    respond_to do |format|
      if @biomarker.update(biomarker_params)
        format.html { redirect_to @biomarker, notice: "Biomarker was successfully updated." }
        format.json { render :show, status: :ok, location: @biomarker }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @biomarker.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /biomarkers/1 or /biomarkers/1.json
  def destroy
    @biomarker.destroy!

    respond_to do |format|
      format.html { redirect_to biomarkers_path, status: :see_other, notice: "Biomarker was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_biomarker
      @biomarker = Biomarker.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def biomarker_params
      params.require(:biomarker).permit(:name)
    end
end
