class User < ActiveRecord::Base

  enum role: [:user, :vip, :admin]

  after_initialize :set_default_role, if: :new_record?

  devise :database_authenticatable, :registerable, :confirmable, :recoverable,
          :rememberable, :trackable, :validatable

  include Gravtastic
  gravtastic

  has_many :orders

  #scope :with_orders, -> {  orders.present? }
  scope :with_orders, -> { joins('LEFT OUTER JOIN orders ON users.id = orders.user_id') }

  def performance_amount
    DashboardHelper.format_currency(10000)#self.performance.map(&:amount).sum)
  end

  def performance_units
    DashboardHelper.format_unit(10000)#self.performance.map(&:y_val).sum)
  end


private

  def set_default_role
    self.role ||= :user
  end

end