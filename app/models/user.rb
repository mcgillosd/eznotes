# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  name                   :string(255)
#  email                  :string(255)
#  created_at             :datetime
#  updated_at             :datetime
#  student_id             :string(255)
#  remember_token         :string(255)
#  admin                  :boolean          default(FALSE)
#  note_taker             :boolean          default(FALSE)
#  password_digest        :string(255)
#  password_reset_token   :string(255)
#  password_reset_sent_at :datetime
#  approved               :boolean          default(FALSE)
#

class User < ActiveRecord::Base
   has_many :notes, dependent: :destroy
   has_many :registrations, foreign_key: "user_id", dependent: :destroy
   has_many :registered_courses, through: :registrations, source: :course

   before_save { email.downcase! }
   before_create :create_remember_token

   default_scope -> { order('name ASC') }

   attr_reader :course_tokens
      
   validates :name, presence: true, 
                    length: { maximum: 50 }

   VALID_EMAIL_REGEX = /\A(\w|\-)+\.([\w]+\.)?(\w|\-)+(@mail.mcgill.ca|@mcgill.ca)\z/i
   validates :email, presence: true, 
                     format: { with: VALID_EMAIL_REGEX, 
                        message: " is incorrect format must be of the form firstname.lastname@mail.mcgill.ca" },
                     uniqueness: { case_sensitive: false }

   VALID_ID_REGEX = /\A\d{9}\z/i
   validates :student_id, presence: { message: "ID cannot be blank"} ,
                          format: { with: VALID_ID_REGEX, 
                           message: "ID is incorrect format; must be a 9 digit number" }, 
                          uniqueness: true,
                          length: { is: 9 }

   has_secure_password
   VALID_PASSWORD_REGEX = /\A[^\s']+\z/
   validates :password, length: { minimum: 8 },
   format: { with: VALID_PASSWORD_REGEX, message: " is incorrect format; cannot have any spaces or quotes(')"},
   if: :password_required?


   def course_tokens=(ids)
      self.course_ids = ids.split(",")
   end

   def notetaking_for
      notetaking = []
      registered_courses.each do |course|
         if course.note_taker and course.note_taker == self
            notetaking.push course
         end
      end
      notetaking
   end

   def notes_feed
      Note.where("user_id = ?", id)
   end

   def fall_course_feed
      registered_courses.where("term = ?", "fall")
   end

   def winter_course_feed
      registered_courses.where("term = ?", "winter")
   end

   def summer_course_feed
      registered_courses.where("term = ?", "summer")
   end

   def registered_with?(course)
      registrations.find_by(course_id: course.id)
   end

   def register!(course)
      registrations.create!(course_id: course.id)
   end

   def unregister!(course)
      registrations.find_by(course_id: course.id).destroy!
   end

   def User.new_remember_token
      SecureRandom.urlsafe_base64
   end

   def User.encrypt(token)
      Digest::SHA1.hexdigest(token.to_s)
   end

   def send_password_reset
      generate_reset_token(:password_reset_token)
      self.password_reset_sent_at = Time.zone.now
      save!
      UserMailer.password_reset(self).deliver
   end

   def send_new_registration_message
      UserMailer.new_registration(self).deliver
   end

   def send_assigned_to_course_message(course)
      UserMailer.assign_notetaker(self, course).deliver
   end

   def send_notetaker_assigned(course)
      UserMailer.notify_users(self, course).deliver
   end

   def send_unassigned_from_course_message(course)
      UserMailer.unassign_notetaker(self, course).deliver
   end

   protected

      def password_required?
         !persisted? || !password.nil? || !password_confirmation.nil?
      end

   private

      def create_remember_token
         self.remember_token = User.encrypt(User.new_remember_token)
      end

      def generate_reset_token(column)
         begin
            self[column] = SecureRandom.urlsafe_base64
         end while User.exists?(column => self[column])
      end
end
