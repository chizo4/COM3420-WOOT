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
class Academic < ApplicationRecord
  include EpiCas::DeviseHelper
  devise :trackable
  # :confirmable, :lockable, :timeoutable, and :omniauthable

  has_and_belongs_to_many :sharing, class_name: 'Quiz', join_table: 'sharing_table'

  has_many :quizzes, dependent: :destroy
  has_many :folders, dependent: :destroy

  def name
    [givenname, sn].join(' ')
  end
end
