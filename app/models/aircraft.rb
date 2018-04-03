class Aircraft < ApplicationRecord
  validates :identifier, presence: true,
    uniqueness: {case_sensitive: false},
    length: { maximum: 10 },
    on: :create

  has_many :fights

end
