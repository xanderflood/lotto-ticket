require 'rails_helper'

RSpec.describe "teacher/registrees/new", type: :view do
  before(:each) do
    @semester = FactoryGirl.create(:finished_lottery).semester
    @course = @semester.courses.first
    @section = @course.sections.first
    assign(:registree, Registree.new(
      student: @student,
      semester: @semester,
      course: @course,
      section: @section))
  end

  it "renders teacher new registree form" do
    render

    assert_select "form[action=?][method=?]", teacher_student_registree_path(@student), "post" do
    end
  end
end
