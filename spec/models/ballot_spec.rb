require 'rails_helper'

RSpec.describe Ballot, type: :model do
  it 'should reject a ballot whose preferences are not of the appropriate format' do
    semester = FactoryGirl.create(:semester_with_courses, current: true)
    student  = FactoryGirl.create(:student)
    course   = semester.courses.first

    expect { Ballot.new(
        semester: semester,
        course: course,
        student: student,
        preferences: {}).save
      }.to raise_error ActiveRecord::SerializationTypeMismatch

    ballot = Ballot.new(
      semester: semester,
      course: course,
      student: student,
      preferences: [course.section_ids.map {|i| i + 1}])
    expect(ballot.save).to be false
    expect(ballot.errors.keys.include? :preferences).to be true

    ballot = Ballot.new(
      semester: semester,
      course: course,
      student: student,
      preferences: course.section_ids.shuffle)
    expect(ballot.save).to be true
  end
end
