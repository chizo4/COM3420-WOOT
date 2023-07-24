# frozen_string_literal: true

# == Schema Information
#
# Table name: folders
#
#  id          :bigint           not null, primary key
#  name        :string
#  academic_id :bigint           not null
#
# Indexes
#
#  index_folders_on_academic_id  (academic_id)
#
# Foreign Keys
#
#  fk_rails_...  (academic_id => academics.id)
#
require 'rails_helper'

RSpec.describe Folder, type: :model do
  let!(:folder) { build(:folder) }
  let!(:academic) { build(:academic) }

  context 'validating the folder' do
    it 'is valid with all fields' do
      folder.name = 'blah'
      folder.academic = academic
      expect(folder).to be_valid
    end

    it 'is invalid without name' do
      folder.name = nil
      expect(folder).not_to be_valid
    end

    it 'is invalid without associated academic' do
      folder.academic = nil
      expect(folder).not_to be_valid
    end
  end
end
