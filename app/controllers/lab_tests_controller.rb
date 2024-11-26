class LabTestsController < ApplicationController
  before_action :set_lab_test, only: %i[ show edit update destroy ]

  # GET /lab_tests or /lab_tests.json
  def index
    @recordables = policy_scope(LabTest)
                   .select(:recordable_id, :created_at)
                   .order(:created_at)
                   .group(:recordable_id, :created_at)
    @biomarkers = policy_scope(Biomarker)
                  .includes(:reference_ranges, :lab_tests)
                  .where(lab_tests: { user_id: current_user.id })
  end

  # GET /lab_tests/1 or /lab_tests/1.json
  def show
    authorize @lab_test
  end

  # GET /lab_tests/new
  def new
    @lab_test = LabTest.new
    authorize @lab_test
  end

  # GET /lab_tests/1/edit
  def edit
    authorize @lab_test
  end

  # POST /lab_tests or /lab_tests.json
  def create
    @lab_test = current_user.lab_tests.build(lab_test_params)
    authorize @lab_test

    respond_to do |format|
      if @lab_test.save
        format.html { redirect_to @lab_test, notice: "Lab test was successfully created." }
        format.json { render :show, status: :created, location: @lab_test }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @lab_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /lab_tests/1 or /lab_tests/1.json
  def update
    authorize @lab_test

    respond_to do |format|
      if @lab_test.update(lab_test_params)
        format.html { redirect_to @lab_test, notice: "Lab test was successfully updated." }
        format.json { render :show, status: :ok, location: @lab_test }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @lab_test.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /lab_tests/1 or /lab_tests/1.json
  def destroy
    authorize @lab_test
    @lab_test.destroy!

    respond_to do |format|
      if request.referer == lab_test_url
        format.html { redirect_to lab_tests_path, status: :see_other, notice: "Lab test was successfully removed." }
      else
        format.html do
          redirect_back_or_to lab_tests_path, status: :see_other, notice: "Lab test was successfully removed."
        end
      end
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_lab_test
    @lab_test = LabTest.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def lab_test_params
    params
      .require(:lab_test)
      .permit(:user_id, :biomarker_id, :value, :unit, :reference_range_id, :recordable_type, :recordable_id, :notes, :created_at, :updated_at)
  end
end
