class Form
  attr_reader :params, :errors

  def initialize(params = nil)
    params ||= {}
    @params = Hash[params.to_a.map { |k,v| [k.to_sym, v] }]
    @errors = []
  end
end

class Signup < Form
  def initialize(params)
    super
    p @params
    @errors << "Please enter 'Job Title'" if job_title.empty?
    @errors << "Please select 'Job Type'" if job_type.empty?
    @errors << "Please select 'Company Age'" if company_age.empty?
  end

  def job_title
    (params[:job_title] || "").strip
  end

  def job_type
    values = []
    %w[cofounder freelancer intern parttime permanent].each do |option|
      values << option if params["job_type_#{option}"]
    end
    values
  end

  def company_age
    values = []
    values << 'baby' if params[:company_age_baby]
    values << 'toddler' if params[:company_age_toddler]
    values << 'child' if params[:company_age_child]
    values << 'teenie' if params[:company_age_teenie]
    values << 'adult' if params[:company_age_adult]
    values
  end
end
