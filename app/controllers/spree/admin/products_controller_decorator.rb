Spree::Admin::ProductsController.class_eval do

  def favourite_users
  @users = @product.favorite_users.page(params[:page]).per(Spree::Config.favorite_users_per_page)
  end
end
