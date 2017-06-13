class Pin < ActiveRecord::Base
  belongs_to :board
  belongs_to :user
  mount_base64_uploader :pin_content, PinContentUploader
  acts_as_commentable
  acts_as_votable

  after_create :create_slug
  before_destroy :destroy_comments

  private
    def destroy_comments
      self.comments.delete_all
    end

    def create_slug
      $redis.set(self.description, self.id)
    end
end
