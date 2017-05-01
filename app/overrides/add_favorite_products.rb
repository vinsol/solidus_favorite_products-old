Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_favorite_products_after_login',
  insert_after: '[data-hook="product_show"]',
  text: %Q{
    <%= javascript_tag do %>
      <% if spree_user_signed_in? && params[:favorite_product_id].present? && params[:favorite_product_id].eql?(params[:id]) %>
        $(document).ready(
          function(){
            $('#mark-as-favorite').trigger('click');
          }
        );
      <% end %>
    <% end %>
  }
)


