Deface::Override.new(
  virtual_path: 'spree/products/show',
  name: 'add_favorite_products_after_login',
  insert_after: '[data-hook="product_show"]',
  text: %Q{
    <%= javascript_tag do %>
      <% if spree_user_signed_in? && session[:favorite_product_id].present? %>
        $(document).ready(
          function(){
            $('#mark-as-favorite').trigger('click');
          }
        );
      <% end %>
    <% end %>
  }
)


