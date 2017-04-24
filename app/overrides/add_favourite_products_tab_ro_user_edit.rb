Deface::Override.new(
  virtual_path: 'spree/admin/users/_tabs',
  name: 'add_favourite_products_tab_user_edit',
  insert_bottom: '[data-hook="admin_user_tab_options"]',
  text: %Q{
    <%= content_tag :li, class: ('active' if current == 'favourite_products') do %>
        <%= link_to Spree.t(:favorite_products,scope: [:admin, :tab]), spree.favourite_products_admin_user_path(@user) %>
      <% end if can?(:admin, Spree::Product) %>
  }
)

