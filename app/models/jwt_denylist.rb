class JwtDenylist < ApplicationRecord
  include Devise::JWT::RevocationStrategies::Denylist

  # Straight out of the Devise docs to prevent unauthorized JWT tokens.
  self.table_name = 'jwt_denylist'
end
