module Gaku
  class Exam < ActiveRecord::Base

    include Notes

    has_many :exam_scores
    has_many :exam_portions, :order => :position
    has_many :exam_portion_scores, :through => :exam_portions
    has_many :exam_syllabuses
    has_many :syllabuses, :through => :exam_syllabuses
    has_many :attendances, :as => :attendancable

    belongs_to :grading_method


    validates_presence_of :name
    validates :weight, :numericality => {:allow_blank => true, :greater_than_or_equal_to => 0 }

    attr_accessible :name, :description, :weight,
                    :use_weighting, :is_standalone, :adjustments,
                    :exam_portions_attributes, :grading_method_id,
                    :has_entry_numbers

    accepts_nested_attributes_for :exam_portions


    def self.without_syllabuses
      includes(:syllabuses).where(:is_standalone => false).select {|p| p.syllabuses.length == 0 }
    end

    def total_weight
      exam_portions.inject(0) {|sum, p| sum + p.weight }
    end


    def max_score
      exam_portions.inject(0) {|sum, p| sum + p.max_score }
    end

  end
end


