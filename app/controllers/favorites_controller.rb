class FavoritesController < ApplicationController
  before_action :require_user_logged_in

  def create
    # binding.pry
    favored_post = Micropost.find(params[:favpost_id])
    current_user.favpost(favored_post)
    flash[:success] = "ふぁぼりました"
    redirect_back(fallback_location: root_path) 
  end

  def destroy
    un_favored_post =  User.find(params[:favpost_id])
    current_user.unfavpost(un_favored_post)
    flash[:success] = "お気に入りから削除しました"
    redirect_back(fallback_location: root_path) 
  end
end
