Spree::UserSessionsController.class_eval do
  after_action :set_current_favourite_product, only: :create

  private
    def set_current_favourite_product
      if spree_user_signed_in?
        favorite = spree_current_user.favorites.find_or_initialize_by(product_id: session[:favorite_product_id])
        favorite && favorite.save
        session[:favorite_product_id] = nil
      end
    end
end

