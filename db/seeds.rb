require 'faker'

# Clear existing data to avoid duplication
User.destroy_all
Biomarker.destroy_all
ReferenceRange.destroy_all
HealthRecord.destroy_all
LabTest.destroy_all
Measurement.destroy_all

# Create Users
puts "Creating Users..."
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    password: Faker::Internet.password
  )
end

users = User.all

# Create Biomarkers
puts "Creating Biomarkers..."
biomarkers = ["Glucose", "Hemoglobin", "Cholesterol", "Triglycerides", "Vitamin D"]
biomarkers.each do |name|
  Biomarker.create!(name: name)
end

biomarker_records = Biomarker.all

# Create ReferenceRanges
puts "Creating Reference Ranges..."
sources = %w[DILA MSD MCC]
biomarker_records.each do |biomarker|
  sources.sample(2).each do |source|
    ReferenceRange.create!(
      biomarker: biomarker,
      min_value: Faker::Number.between(from: 50.0, to: 100.0),
      max_value: Faker::Number.between(from: 101.0, to: 200.0),
      unit: case biomarker.name
            when "Glucose" then "mg/dL"
            when "Hemoglobin" then "g/dL"
            when "Cholesterol" then "mg/dL"
            when "Triglycerides" then "mg/dL"
            when "Vitamin D" then "ng/mL"
            else "unit"
            end,
      source: source
    )
  end
end

# Create HealthRecords
puts "Creating Health Records..."
users.each do |user|
  2.times do
    HealthRecord.create!(
      user: user,
      notes: Faker::Lorem.sentence
    )
  end
end

health_records = HealthRecord.all

# Create LabTests
puts "Creating Lab Tests..."
health_records.each do |health_record|
  2.times do
    biomarker = biomarker_records.sample
    reference_range = ReferenceRange.where(biomarker: biomarker).sample
    LabTest.create!(
      user: health_record.user,
      biomarker: biomarker,
      value: Faker::Number.decimal(l_digits: 2, r_digits: 2),
      unit: reference_range.unit,
      reference_range: reference_range,
      recordable: health_record,
      created_at: Faker::Time.backward(days: 30, period: :morning),
      updated_at: Faker::Time.backward(days: 30, period: :morning),
      notes: Faker::Lorem.sentence
    )
  end
end

# Create Measurements
puts "Creating Measurements..."
measurement_types = { height: 0, weight: 1, chest: 2, waist: 3, hips: 4, wrist: 5 }

health_records.each do |health_record|
  2.times do
    type, enum_value = measurement_types.to_a.sample
    Measurement.create!(
      user: health_record.user,
      measurement_type: enum_value,
      value: case type
             when :height then Faker::Number.decimal(l_digits: 2, r_digits: 2) # in cm
             when :weight then Faker::Number.decimal(l_digits: 2, r_digits: 2) # in kg
             when :chest then Faker::Number.decimal(l_digits: 2, r_digits: 2) # in cm
             when :waist then Faker::Number.decimal(l_digits: 2, r_digits: 2) # in cm
             when :hips then Faker::Number.decimal(l_digits: 2, r_digits: 2) # in cm
             when :wrist then Faker::Number.decimal(l_digits: 2, r_digits: 2) # in cm
             else Faker::Number.decimal(l_digits: 2, r_digits: 2) # in cm
             end,
      source: %w[Manual Imported Device].sample,
      recordable: health_record,
      notes: Faker::Lorem.sentence
    )
  end
end

puts "Seeding completed successfully!"
