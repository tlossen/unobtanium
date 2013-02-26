class Form
  attr_reader :target, :params, :errors

  def initialize(target, params = nil)
    @target = target
    params ||= {}
    @params = Hash[params.to_a.map { |k,v| [k.to_sym, v] }]
    @errors = []
  end

  def text_input(name)
    (params[name.to_sym] || "").strip
  end
end

class CandidateForm < Form

  def self.create(target, candidate)
    params = Hash[
      position: candidate.position,
      priority_1: candidate.priorities[0],
      priority_2: candidate.priorities[1],
      priority_3: candidate.priorities[2],
      language: candidate.language,
      trait_1: candidate.traits[0],
      trait_2: candidate.traits[1],
      trait_3: candidate.traits[2],
      experience: candidate.experience.to_s,
      location: candidate.location
    ]
    candidate.job_types.each do |option|
      params[:"job_type_#{option}"] = 1
    end
    new(target, params)
  end

  def initialize(target, params = nil)
    super
    @errors << :position if position.empty?
    @errors << :job_type if job_types.empty?
    @errors << :priorities if priorities.any?(&:empty?)
    @errors << :language if language.empty?
    @errors << :traits if traits.any?(&:empty?)
    @errors << :experience unless experience =~ /^\d+$/
    @errors << :location if location.empty?
  end

  def result
    Hash[
      position: position,
      job_types: job_types,
      priorities: priorities,
      language: language,
      traits: traits,
      experience: experience.to_i,
      location: location
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

  def location
    text_input(:location)
  end

end
