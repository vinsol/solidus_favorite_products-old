Deface::Override.new(
  :virtual_path => 'spree/products/show',
  :name => 'add_link_to_mark_product_as_favorite',
  :surround_contents => "h1[itemprop='name']",
  :text => %Q{
    <%= render_original %>
    <% if spree_user_signed_in? && spree_current_user.has_favorite_product?(@product.id) %>
      <%= link_to Spree.t(:unmark_as_favorite), favorite_product_path(id: @product.id), method: :delete, remote: true, class: 'favorite_link button pull-right' %>
    <% else %>
      <%= link_to Spree.t(:mark_as_favorite), favorite_products_path(id: @product.id), method: :post, remote: spree_user_signed_in?, class: 'favorite_link button pull-right' %>
    <% end %>
  }
)
