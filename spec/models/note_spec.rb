# == Schema Information
#
# Table name: notes
#
#  id                :integer          not null, primary key
#  lecture_title     :string(255)
#  lecture_date      :date
#  comments          :text
#  user_id           :integer
#  created_at        :datetime
#  updated_at        :datetime
#  file_file_name    :string(255)
#  file_content_type :string(255)
#  file_file_size    :integer
#  file_updated_at   :datetime
#  course_id         :integer
#

require 'spec_helper'

describe Note do
  let(:notetaker) { FactoryGirl.create(:notetaker) }
  let(:course) { FactoryGirl.create(:course) }
  before { @note = notetaker.notes.build(
                     file: File.new(Rails.root.join('public', 'assets', 'sample.pdf')),
                     lecture_title: "CHEM 200 intro to hydrogen", 
                     lecture_date: Date.today,
                     comments: "This is the notes for lasjdfkl", 
                     course_id: course.id) }

  subject { @note }

  it { should respond_to(:file) }
  it { should respond_to(:lecture_title) }
  it { should respond_to(:lecture_date) }
  it { should respond_to(:comments) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:course_id) }
  it { should respond_to(:course) }
  its(:course) { should eq course }
  its(:user) { should eq notetaker }

  it { should be_valid }

  it { should have_attached_file(:file) }

  it { should validate_attachment_presence(:file) }

  describe "when user_id is not present" do
   before { @note.user_id = nil }
   it { should_not be_valid }
  end

  describe "when course_id is not present" do
    before { @note.course_id = nil }
    it { should_not be_valid }
  end

  describe "when file is not the correct format" do
   it { should validate_attachment_content_type(:file).
        allowing('application/pdf', 'application/msword').
        rejecting('text/plain', 'text/xml') }
  end

  describe "when lecture title is not present" do
    before { @note.lecture_title = nil }
    it { should_not be_valid }
  end

  describe "with blank lecture title" do
    before { @note.lecture_title = " " }
    it { should_not be_valid }
  end

  describe "when lecture date is not present" do
    before { @note.lecture_date = nil }
    it { should_not be_valid }
  end

  describe "with blank lecture date" do
    before { @note.lecture_title = " " }
    it { should_not be_valid }
  end

  describe "with comments that are too long" do 
   before { @note.comments = "a" * 141 }
   it { should_not be_valid }
  end

end
