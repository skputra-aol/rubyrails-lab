class User < ApplicationRecord
  include Devise::JWT::RevocationStrategies::JTIMatcher

  has_many :user_stocks, dependent: :destroy
  has_many :stocks, through: :user_stocks
  has_many :orders, dependent: :destroy
  has_many :transaction_records,
           lambda { |user|
             # Removes default where clause of searching for user_id
             # Since user_id does not exist, cannot create through User.find(n).transaction_records.create!()
             unscope(:where).where(broker: user).or(where(buyer: user))
           }, dependent: :destroy,
           inverse_of: :buyer

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: self

           # Validations
  validates :email, presence: true,
                    uniqueness: true
  validates :username, presence: true
  validates :firstname, presence: false
  validates :lastname, presence: false
  validates :role, presence: false
  validates :balance, numericality: { greater_than_or_equal_to: 0 }

  # Role Inheritance using CanCanCan
  ROLES = %w[buyer broker admin].freeze

  def sufficient_balance?(amount)
    balance >= amount
  end

  def change_balance_by(amount)
    # byebug
    update(balance: balance + amount)
  end

  def role?(base_role)
    ROLES.index(base_role.to_s) <= ROLES.index(role)
  end

end
