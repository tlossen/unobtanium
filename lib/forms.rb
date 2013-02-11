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
    @errors << "Please select 'Company Age'" if company_age.empty?
  end

  def job_title
    (params[:job_title] || "").strip
  end

  def company_age
    values = []
    values << 'baby' if params[:company_age_baby]
    values << 'toddler' if params[:company_age_toddler]
    values << 'child' if params[:company_age_child]
    values
  end
end
