FactoryGirl.define do
  factory :arf_report, :class => Scaptimony::ArfReport do |f|
    f.asset
    f.policy
    f.sequence(:digest) { |n| "#{n}1212aa#{n}"}
    date '1973-01-13'
  end
end