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
    @errors << :position if position.empty?
    @errors << :job_type if job_types.empty?
    @errors << :priorities if priorities.any?(&:empty?)
    @errors << :language if language.empty?
    @errors << :traits if traits.any?(&:empty?)
    @errors << :experience unless experience =~ /^\d+$/
  end

  def result
    Hash[
      position: position,
      job_types: job_types,
      priorities: priorities,
      language: language,
      traits: traits,
      experience: experience.to_i
    ]
  end

  def priorities
    [1,2,3].map { |i| text_input("priority_#{i}") }
  end

  def position
    text_input(:position)
  end

  def job_types
    %w[cofounder freelancer intern parttime permanent remote].map do |option|
      option if params[:"job_type_#{option}"]
    end.compact
  end

  def experience
    text_input(:experience)
  end

  def traits
    [1,2,3].map { |i| text_input("trait_#{i}") }
  end

  def language
    text_input(:language)
  end


end
