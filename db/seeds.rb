# frozen_string_literal: true

require 'faker'

# Clear existing data to avoid duplication
User.destroy_all
Role.destroy_all
Biomarker.destroy_all
ReferenceRange.destroy_all
HealthRecord.destroy_all
LabTest.destroy_all
Measurement.destroy_all

# Create Users
puts 'Creating Users...'
10.times do
  User.create!(
    first_name: Faker::Name.first_name,
    last_name: Faker::Name.last_name,
    email: Faker::Internet.unique.email,
    password: 'password'
  )
end

users = User.all

# Assign roles to existing users
puts 'Assign roles to existing users...'
users.each_with_index do |user, i|
  if i.zero?
    user.add_role Role::ADMIN

    next
  end

  if i == 1
    user.add_role Role::DOCTOR

    next
  end

  next unless i == 2

  user.add_role Role::HEALTH_COACH

  next
end

# Assign users to doctors and health coaches
Rails.logger.debug 'Creating Assignments...'
doctors = users.select(&:doctor?)
health_coaches = users.select(&:health_coach?)
clients = users.select(&:user?)

doctors.each do |doctor|
  assigned_clients = clients.sample(3)
  assigned_clients.each do |client|
    Assignment.create!(assignee: doctor, assigned: client)
  end
end

health_coaches.each do |health_coach|
  assigned_clients = clients.sample(3)
  assigned_clients.each do |client|
    Assignment.create!(assignee: health_coach, assigned: client)
  end
end

# Create Biomarkers
puts 'Creating Biomarkers...'
biomarkers = [
  'Glucose',
  'Hemoglobin',
  'Cholesterol',
  'Triglycerides',
  'Vitamin D',
  'LDL Cholesterol',
  'HDL Cholesterol',
  'Insulin',
  'C-Reactive Protein',
  'Calcium',
  'Potassium',
  'Sodium',
  'Iron',
  'Ferritin',
  'Thyroid Stimulating Hormone (TSH)',
  'Free T4',
  'Free T3',
  'Creatinine',
  'Blood Urea Nitrogen (BUN)',
  'Alkaline Phosphatase',
  'AST (SGOT)',
  'ALT (SGPT)',
  'Bilirubin',
  'Albumin',
  'Magnesium'
]
biomarkers.each do |name|
  Biomarker.create!(name: name)
end

biomarker_records = Biomarker.all

# min and max values based on the biomarker
min_max_map = {
  Glucose: [70.0, 99.0],
  Hemoglobin: [13.5, 17.5],
  Cholesterol: [125.0, 200.0],
  Triglycerides: [50.0, 150.0],
  'Vitamin D': [20.0, 50.0],
  'LDL Cholesterol': [0.0, 100.0],
  'HDL Cholesterol': [40.0, 60.0],
  Insulin: [2.6, 24.9],
  'C-Reactive Protein': [0.0, 3.0],
  Calcium: [8.5, 10.5],
  Potassium: [3.5, 5.0],
  Sodium: [135.0, 145.0],
  Iron: [60.0, 170.0],
  Ferritin: [12.0, 300.0],
  'Thyroid Stimulating Hormone (TSH)': [0.4, 4.0],
  'Free T4': [0.8, 1.8],
  'Free T3': [2.3, 4.2],
  Creatinine: [0.6, 1.2],
  'Blood Urea Nitrogen (BUN)': [7.0, 20.0],
  'Alkaline Phosphatase': [44.0, 147.0],
  'AST (SGOT)': [10.0, 40.0],
  'ALT (SGPT)': [7.0, 56.0],
  Bilirubin: [0.1, 1.2],
  Albumin: [3.5, 5.0],
  Magnesium: [1.7, 2.2]
}

# Create ReferenceRanges
puts 'Creating Reference Ranges...'
biomarker_records.each do |biomarker| # rubocop:disable Metrics/BlockLength
  unit = case biomarker.name
         when 'Glucose', 'Cholesterol', 'Triglycerides', 'LDL Cholesterol', 'HDL Cholesterol', 'Iron', 'Bilirubin',
           'Albumin', 'Magnesium', 'Creatinine', 'Blood Urea Nitrogen (BUN)'
           'mg/dL'
         when 'Hemoglobin'
           'g/dL'
         when 'Vitamin D', 'Ferritin'
           'ng/mL'
         when 'Insulin', 'Thyroid Stimulating Hormone (TSH)'
           'µIU/mL'
         when 'Free T4'
           'ng/dL'
         when 'Free T3'
           'pg/mL'
         when 'C-Reactive Protein'
           'mg/L'
         when 'Calcium', 'Potassium', 'Sodium'
           'mEq/L'
         when 'Alkaline Phosphatase', 'AST (SGOT)', 'ALT (SGPT)'
           'U/L'
         else
           'unit'
         end

  # Assign realistic min and max values based on the biomarker
  min_max = case biomarker.name
            when 'Glucose'
              [70.0, 99.0]
            when 'Hemoglobin'
              [13.5, 17.5]
            when 'Cholesterol'
              [125.0, 200.0]
            when 'Triglycerides'
              [50.0, 150.0]
            when 'Vitamin D'
              [20.0, 50.0]
            when 'LDL Cholesterol'
              [0.0, 100.0]
            when 'HDL Cholesterol'
              [40.0, 60.0]
            when 'Insulin'
              [2.6, 24.9]
            when 'C-Reactive Protein'
              [0.0, 3.0]
            when 'Calcium'
              [8.5, 10.5]
            when 'Potassium'
              [3.5, 5.0]
            when 'Sodium'
              [135.0, 145.0]
            when 'Iron'
              [60.0, 170.0]
            when 'Ferritin'
              [12.0, 300.0]
            when 'Thyroid Stimulating Hormone (TSH)'
              [0.4, 4.0]
            when 'Free T4'
              [0.8, 1.8]
            when 'Free T3'
              [2.3, 4.2]
            when 'Creatinine'
              [0.6, 1.2]
            when 'Blood Urea Nitrogen (BUN)'
              [7.0, 20.0]
            when 'Alkaline Phosphatase'
              [44.0, 147.0]
            when 'AST (SGOT)'
              [10.0, 40.0]
            when 'ALT (SGPT)'
              [7.0, 56.0]
            when 'Bilirubin'
              [0.1, 1.2]
            when 'Albumin' # rubocop:disable Lint/DuplicateBranch
              [3.5, 5.0]
            when 'Magnesium'
              [1.7, 2.2]
            else # rubocop:disable Lint/DuplicateBranch
              [0.0, 100.0]
            end

  ReferenceRange.create!(
    biomarker: biomarker,
    min_value: min_max[0],
    max_value: min_max[1],
    unit: unit,
    source: 'DILA'
  )
end

# Create HealthRecords
puts 'Creating Health Records...'
start_day = rand(10).to_i
users.each do |user|
  i = 0
  5.times do
    HealthRecord.create!(
      user: user,
      notes: Faker::Lorem.sentence,
      created_at: Faker::Time.backward(days: start_day + i, period: :morning),
      updated_at: Faker::Time.backward(days: start_day + i, period: :morning)
    )
  end
end

health_records = HealthRecord.all

# Create LabTests
puts 'Creating Lab Tests...'
health_records.each do |health_record|
  20.times do
    biomarker = biomarker_records.sample
    reference_range = ReferenceRange.where(biomarker: biomarker).sample
    LabTest.create!(
      user: health_record.user,
      biomarker: biomarker,
      value: if rand(0..1).zero?
               Faker::Number.decimal(l_digits: 2, r_digits: 2)
             else
               Faker::Number.between(
                 from: min_max_map[biomarker.name.to_sym][0],
                 to: min_max_map[biomarker.name.to_sym][1]
               )
             end,
      unit: reference_range.unit,
      reference_range: reference_range,
      recordable: health_record,
      created_at: health_record.created_at,
      updated_at: health_record.updated_at,
      notes: Faker::Lorem.sentence
    )
  end
end

# Create Measurements
puts 'Creating Measurements...'
measurement_types = { height: 0, weight: 1, chest: 2, waist: 3, hips: 4, wrist: 5 }
weight_unit = { kg: 'kg', lb: 'lb' }
height_unit = { cm: 'cm', ft: 'ft' }

health_records.each do |health_record|
  2.times do
    type, enum_value = measurement_types.to_a.sample
    source = %w[Manual Imported Device].sample # rubocop:disable Performance/CollectionLiteralInLoop
    Measurement.create!(
      user: health_record.user,
      measurement_type: enum_value,
      unit: case type
            when :height, :chest, :waist, :hips, :wrist then height_unit.to_a.sample[0]
            when :weight then weight_unit.to_a.sample[0]
            else height_unit.to_a.sample[0] # rubocop:disable Lint/DuplicateBranch
            end,
      value: Faker::Number.decimal(l_digits: 2, r_digits: 2),
      source: source,
      recordable: health_record,
      notes: Faker::Lorem.sentence
    )
  end
end

puts 'Seeding completed successfully!'

puts "Admin role user credentials: email: \"#{users[0].email}\" and password: \"password\""
puts "Doctor role user credentials: email: \"#{users[1].email}\" and password: \"password\""
puts "HealthCoach role user credentials: email: \"#{users[2].email}\" and password: \"password\""
puts "User role user credentials: email: \"#{users[3].email}\" and password: \"password\""
