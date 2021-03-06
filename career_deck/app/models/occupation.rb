class Occupation < ApplicationRecord
  # base description and job title from noc_uniques

  has_many :task_skills, primary_key: 'noc_code', foreign_key: 'noc_code'
  has_many :tasks, through: :task_skills
  has_many :skills, through: :task_skills
  has_many :specific_programs, foreign_key: 'noc_code', primary_key: 'noc_code'

  has_and_belongs_to_many :maesd_programs, join_table: :maesd_programs_occupations
  has_many :ouac_university_programs, through: :maesd_programs

  def automation_risk_percentage
    risk = AutomationRisk.find_by(noc_code: noc_code)
    return nil unless risk

    risk.automation_risk.to_f * 100
  end

  def illustrative_job_titles
    JobTitle.where(noc_code: noc_code).pluck(:description_en)
  end

  def ouac_university_program_random
    ouac_university_programs.order("RAND()").first
  end

  def maesd_codes
    cip_codes = SpecificProgram.where(noc_code: noc_code).order(job_count: :desc).pluck(:cip_program_code)

    cip_cat_codes = cip_codes.map { |code| code.split('.')[0] }.uniq
    CipMaesdMap.where(cip_top_code: cip_cat_codes).pluck(:program_code).uniq
  end
end