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
FactoryBot.define do
  factory :academic do
    sequence(:username) { |i| "user-#{i}" }
    sequence(:email) { |i| "blackhole-#{i}@email.com" }
    sequence(:givenname) { |i| "John-#{i}" }
    sequence(:sn) { |i| "Doe-#{i}" }
  end
end
