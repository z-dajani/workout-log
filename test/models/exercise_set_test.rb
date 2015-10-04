require 'test_helper'

class ExerciseSetTest < ActiveSupport::TestCase
  def setup
    @workout = valid_workout(save: true)
    @exercise = valid_exercise(@workout, save: true)
    @set = valid_exercise_set(@exercise)
  end

  test "should be valid" do
    assert @set.valid?, @set.errors.inspect
  end

  test "pounds and reps should be optional" do
    @set.reps = nil
    @set.pounds = nil
    assert @set.valid?, @set.errors.inspect
  end

  test "pounds should not be too large" do
    @set.pounds = 5000
    assert_not @set.valid?, @set.errors.inspect
  end

  test "pounds should be positive or zero" do
    @set.pounds = -0.1
    assert_not @set.valid?, @set.errors.inspect
  end

  test "reps should be positive or zero" do
    @set.reps = -0.1
    assert_not @set.valid?, @set.errors.inspect
  end

  test "reps should not be too large" do
    @set.reps = 1000
    assert_not @set.valid?, @set.errors.inspect
  end

  test "exercise should exist in the db" do
    @set.exercise = Exercise.new
    assert_not @set.valid?
  end

  test "set should be deleted from the db when its exercise is" do
    @set.save
    @set.exercise.destroy
    assert_not ExerciseSet.find_by(id: @set.id)
  end

end