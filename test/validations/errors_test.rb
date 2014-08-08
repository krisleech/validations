require 'test_helper'

describe Lotus::Validations::Errors do
  before do
    @errors = Lotus::Validations::Errors.new
  end

  describe '#initialize' do
    it 'is empty by default' do
      @errors.must_be_empty
    end
  end

  describe '#add' do
    it 'adds an error for an attribute' do
      @errors.add(:email, :format, /@/, 'test')
      @errors.wont_be_empty
    end
  end

  describe '#for' do
    it 'returns errors for the given attribute' do
      @errors.add(:email, :format, /@/, 'test')
      @errors.add(:name,  :presence, true, nil)

      @errors.for(:name).must_equal Hash[presence: [true, nil]]
    end
  end

  describe '#each' do
    it 'yields the given block for each error' do
      result = []

      @errors.add(:email, :format, /@/, 'test')
      @errors.add(:email, :confirmation, true, 'test')
      @errors.add(:name,  :presence, true, nil)

      @errors.each do |attribute, validation, expected, actual|
        result << (
          "%{attribute} must match %{validation} (expected %{expected}, was %{actual})" %
          {attribute: attribute, validation: validation, expected: expected, actual: actual}
        )
      end

      result.must_equal [
        "email must match format (expected (?-mix:@), was test)",
        "email must match confirmation (expected true, was test)",
        "name must match presence (expected true, was )",
      ]
    end
  end

  describe '#map' do
    it 'yields the given block for each error' do
      @errors.add(:email, :format, /@/, 'test')
      @errors.add(:email, :confirmation, true, 'test')
      @errors.add(:name,  :presence, true, nil)

      result = @errors.map do |attribute, validation, expected, actual|
        "%{attribute} must match %{validation} (expected %{expected}, was %{actual})" %
          {attribute: attribute, validation: validation, expected: expected, actual: actual}
      end

      result.must_equal [
        "email must match format (expected (?-mix:@), was test)",
        "email must match confirmation (expected true, was test)",
        "name must match presence (expected true, was )",
      ]
    end
  end
end

