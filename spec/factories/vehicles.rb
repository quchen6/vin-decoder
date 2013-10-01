# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :vehicle do
    year 1
    make "MyString"
    model "MyString"
    transmission_type "MyString"
    engine_type "MyString"
    vin "MyString"
  end
end
