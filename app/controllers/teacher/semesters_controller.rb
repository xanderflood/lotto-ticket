class Teacher::SemestersController < Teacher::BaseController
  before_action :set_semester, except: [:new, :create, :index]

  def lottery
    begin
      @lottery = Lottery.new(semester: @semester)
    rescue => e
      lottery_failed!(e)
      return
    end

    unless @lottery.save
      lottery_failed!
      return
    end

    @disabled = params[:disabled].present?
  end

  def act
    unless SemesterStateHelper::TRANSITIONS.include?(params[:transition])
      redirect_to :back, notice: "Semester state transition not found."
      return
    end

    if params[:transition] == "run"
      @lottery = Lottery.find(params[:lottery_id])

      if !@lottery.commit
        redirect_to teacher_semester_path(@semester), notice: "Some records could not be saved properly. Running the lottery again will attempt to assign the remaining students."
        return
      end
    end

    if @semester.send(params[:transition])
      redirect_to teacher_semester_path(@semester), notice: SemesterStateHelper::TRANSITION_SUCCESS[params[:transition]]
    else
      redirect_to :back, notice: "Invalid semester state transition."
    end
  end

  def index
    @semesters = Semester.all
    @enrollment = EnrollmentHelper.semester_enrollment
  end

  def new
    @semester = Semester.new
  end

  def show
    @enrollment = EnrollmentHelper.course_enrollment(@semester)
  end

  def edit
  end

  def create
    @semester = Semester.new(semester_params)

    respond_to do |format|
      if @semester.save
        format.html { redirect_to priorities_manage_teacher_semesters_path, alert: 'Semester was successfully created.' }
        format.json { render :show, status: :created, location: @semester }
      else
        format.html { render :new }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @semester.update(semester_params)
        format.html { redirect_to teacher_semesters_path, notice: 'Semester was successfully updated.' }
        format.json { render :show, status: :ok, location: @semester }
      else
        format.html { render :edit }
        format.json { render json: @semester.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @semester.destroy
    respond_to do |format|
      format.html { redirect_to teacher_semesters_url, error: 'Semester was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    def lottery_failed!(e=nil)
      LotteryError.save!(e)

      redirect_to :back, notice: "We're sorry, something went wrong and we were unable to complete the lottery."
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_semester
      @semester = Semester.find(params[:semester_id] || params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def semester_params
      params.fetch(:semester, {}).permit(:name, :start, :end, :lottery_open, :registration_open)
    end
end
