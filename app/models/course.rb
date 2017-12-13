class Course < ApplicationRecord
  default_scope{ order(created_at: :desc) }

  belongs_to :semester
  has_many :sections, class_name: "EventGroup"
  has_many :ballots

  validates :level, presence:  { allow_blank: false, message: "must be specified." },
                    exclusion: { in: ['unspecified'], message: "must be specified." }

  enum level: LevelsHelper::LEVELS

  after_update :shift

  ### methods ###
  def roster
    @roster ||= self.sections.map(&:roster).inject([], :+)
  end

  def waitlist_registrees
    @waitlist_registrees ||= Registree.where(course: self, section: nil)
                             .joins(:student)
                             .order("students.priority DESC", updated_at: :asc)
  end

  def waitlist
    @waitlist ||= waitlist_registrees.map(&:student)
  end

  def all_students
    @all_students ||= roster + waitlist
  end

  def description
    if name
      "#{name} (level #{level})"
    else
      "level #{level}"
    end
  end

  # this is a callback, but also a public method
  def shift; self.sections.each(&:shift); end
end
