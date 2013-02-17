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
    @errors << "Please enter a Job Title" if position.empty?
    @errors << "Please select one or more Job Type" if job_type.empty?
    @errors << "Please enter your 3 main traits" if traits.any?(&:empty?)
    @errors << "Please enter your Favorite Language" if favorite_language.empty?
    @errors << "Please enter your Experience" unless experience =~ /^\d+$/
  end

  def priorities
    [1,2,3].map { |i| text_input("priority_#{i}") }
  end

  def position
    text_input(:position)
  end

  def job_type
    %w[cofounder freelancer intern parttime permanent remote].map do |option|
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
