# frozen_string_literal: true

# == Schema Information
#
# Table name: academics
#
#  id                 :bigint           not null, primary key
#  current_sign_in_at :datetime
#  current_sign_in_ip :string
#  dn                 :string
#  email              :string           default(""), not null
#  givenname          :string
#  last_sign_in_at    :datetime
#  last_sign_in_ip    :string
#  mail               :string
#  ou                 :string
#  sign_in_count      :integer          default(0), not null
#  sn                 :string
#  uid                :string
#  username           :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#
# Indexes
#
#  index_academics_on_email     (email)
#  index_academics_on_username  (username)
#
require 'rails_helper'

RSpec.describe Academic, type: :model do
  let!(:academic) { build(:academic) }

  context 'validates the academic model' do
    it 'is valid by default' do
      expect(academic).to be_valid
    end
  end
end
