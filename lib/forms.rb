class Form
  attr_reader :params, :errors

  def initialize(params = nil)
    params ||= {}
    @params = Hash[params.to_a.map { |k,v| [k.to_sym, v] }]
    @errors = []
  end

  def text_input(name)
    (params[name.to_sym] || "").strip
  end
end

class Signup < Form
  def initialize(params)
    super
    @errors << "Please enter your 3 main Priorities" if priorities.any?(&:empty?)
    @errors << "Please select one or more Company Age" if company_age.empty?
    @errors << "Please enter a Job Title" if job_title.empty?
    @errors << "Please select one or more Job Type" if job_type.empty?
    @errors << "Please enter your 3 main traits" if traits.any?(&:empty?)
    @errors << "Please enter your Favorite Language" if favorite_language.empty?
  end

  def priorities
    [1,2,3].map { |i| text_input("priority_#{i}") }
  end

  def company_age
    %w[baby toddler child teenie adult].map do |option|
      option if params[:"company_age_#{option}"]
    end.compact
  end

  def job_title
    text_input(:job_title)
  end

  def job_type
    %w[cofounder freelancer intern parttime permanent].map do |option|
      option if params[:"job_type_#{option}"]
    end.compact
  end

  def experience
    params[:experience]
  end

  def traits
    [1,2,3].map { |i| text_input("trait_#{i}") }
  end

  def favorite_language
    text_input(:favorite_language)
  end


end
