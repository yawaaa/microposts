class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favpost, class_name: "Micropost"
end
