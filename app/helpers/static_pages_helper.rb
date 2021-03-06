module StaticPagesHelper
  def bmi(weight, height, units)
    case units.to_sym
    when :imperial
      703.0 * (weight.to_f / (height.to_f**2))
    when :metric
      weight.to_f / ((height.to_f/100)**2)
    else
      raise ArgumentError.new('Invalid argument given for units')
    end
  end

  def one_rep_max_brzycki(weight, reps)
    weight.to_f * (36.0 / (37.0-reps.to_i))
  end

  def wilks_score(bodyweight, total, units, gender)
    return nil unless units == :lb || units == :kg
    total *= 0.453592909 if units == :lb

    if gender == :male
      male_wilks_coefficient(bodyweight, units) * total
    elsif gender == :female 
      female_wilks_coefficient(bodyweight, units) * total
    else
      raise ArgumentError.new('Invalid argument given for gender')
    end
  end

  private

  MALE_WILKS_COEFFICIENTS = [-216.0475144, 16.2606339, -0.002388645,
    -0.00113732, 7.01863e-6, -1.291e-8]
  FEMALE_WILKS_COEFFICIENTS = [594.31747775582, -27.23842536447,
    0.82112226871, -0.00930733913, 0.00004731582, -0.00000009054]
  private_constant :MALE_WILKS_COEFFICIENTS, :FEMALE_WILKS_COEFFICIENTS

  def male_wilks_coefficient(bodyweight, units)
    return nil unless units == :lb || units == :kg
    bodyweight *= 0.453592909 if units == :lb
    x = MALE_WILKS_COEFFICIENTS.map.with_index do |e,i|
      e * (bodyweight ** i)
    end
    500.0/(x.inject(:+))
  end

  def female_wilks_coefficient(bodyweight, units)
    return nil unless units == :lb || units == :kg
    bodyweight *= 0.453592909 if units == :lb
    x = FEMALE_WILKS_COEFFICIENTS.map.with_index do |e,i|
      e * (bodyweight ** i)
    end
    500.0/(x.inject(:+))
  end

end
