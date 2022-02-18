class IncomeValue < ApplicationRecord
  belongs_to :user
  belongs_to :income

  validates :start_time, :code, :income_id, presence: true
  validates :value, format: { with: /\A[0-9]+\z/ } #数値半角

end
