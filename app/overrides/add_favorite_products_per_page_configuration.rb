Deface::Override.new(
  virtual_path: 'spree/admin/general_settings/edit',
  name: 'add_favorite_products_per_page_configuration',
  insert_after: '[data-hook="admin_general_setting_default_tax_country"]',
  text: %Q{
    <div class="row">
      <div class="col-md-6">
        <div class="form-group" data-hook="admin_general_setting_favorite_products_per_page">
          <%= f.label  Spree.t(:favorite_products_per_page) %>
          <%#= f.text_field :store, :favorite_products_per_page %>
        </div>
      </div>
    </div>
  }
)
