class RelationshipsController < ApplicationController

  #フォローする
  def create
    user = User.find(params[:user_id])
    current_user.follow(user.id)
    redirect_back(fallback_location: root_path)
  end

   #フォローを外す
  def destroy
    user = User.find(params[:user_id])
    current_user.unfollow(user.id)
    redirect_back(fallback_location: root_path)
  end


end
