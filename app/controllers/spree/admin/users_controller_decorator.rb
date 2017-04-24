Spree::Admin::UsersController.class_eval do
  def favourite_products
    @favourite_products = @user.favorite_products.page(params[:page]).per(Spree::Config.favorite_products_per_page)
  end
end
