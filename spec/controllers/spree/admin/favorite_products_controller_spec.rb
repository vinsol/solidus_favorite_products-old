require 'spec_helper'

describe Spree::Admin::FavoriteProductsController, type: :controller do
  let(:role) { Spree::Role.create!(name: 'user') }
  let(:roles) { [role] }
  let(:product) { mock_model( Spree::Product) }
  let(:proxy_object) { Object.new }

  before(:each) do
    @user = mock_model(Spree::User, generate_spree_api_key!: false)
    allow(@user).to receive(:roles).and_return(proxy_object)
    allow(proxy_object).to receive(:includes).and_return([])

    allow(@user).to receive(:has_spree_role?).with('admin').and_return(true)
    allow(controller).to receive(:spree_user_signed_in?).and_return(true)
    allow(controller).to receive(:spree_current_user).and_return(@user)
    allow(@user).to receive(:roles).and_return(roles)
    allow(roles).to receive(:includes).with(:permissions).and_return(roles)
    allow(controller).to receive(:authorize_admin).and_return(true)
    allow(controller).to receive(:authorize!).and_return(true)

    @favorite_products = double('favorite_products')
    allow(@favorite_products).to receive(:includes).and_return(@favorite_products)
    allow(@favorite_products).to receive(:order_by_favorite_users_count).and_return(@favorite_products)
    @search = double('search', result: @favorite_products)
    allow(@favorite_products).to receive(:search).and_return(@search)
    allow(@favorite_products).to receive(:page).and_return(@favorite_products)
    allow(Spree::Product).to receive(:favorite).and_return(@favorite_products)
  end

  describe "GET index" do
    def send_request
      get :index, params: { page: 1, q: { s: 'name desc' } }
    end

    it "returns favorite products" do
      expect(Spree::Product).to receive(:favorite)
      send_request
    end

    it "searches favorite products" do
      search_params = ActionController::Parameters.new(s: 'name desc')
      expect(@favorite_products).to receive(:search).with(search_params)
      send_request
    end

    it "assigns @search" do
      send_request
      expect(assigns(:search)).to eq(@search)
    end

    context 'when order favorite products by users count in asc order' do
      def send_request
        get :index, params: { page: 1, q: { s: 'favorite_users_count asc' } }
      end

      it "orders favorite products by users count in asc order" do
        expect(@favorite_products).to receive(:order_by_favorite_users_count).with(true)
        send_request
      end
    end

    context 'when order favorite products by users count in desc order' do
      it "orders favorite products by users count in asc order" do
        expect(@favorite_products).to receive(:order_by_favorite_users_count).with(false)
        send_request
      end
    end

    it "paginates favorite products" do
      expect(@favorite_products).to receive(:page).with("1")
      send_request
    end

    it "renders favorite products template" do
      send_request
      expect(response).to render_template(:index)
    end
  end

  describe "#users" do
    before do
      @users = [@user]
      allow(@users).to receive(:page).and_return(@users)
      allow(product).to receive(:favorite_users).and_return(@users)
      @product = product
      allow(Spree::Product).to receive(:find_by).with(:id => product.id.to_s).and_return(@product)
    end

    def send_request
      get :users, params: { id: product.id }, as: :js
    end

    it 'fetches the product' do
      expect(Spree::Product).to receive(:find_by).with(:id => product.id.to_s).and_return(@product)
    end

    it 'fetches the users who marked the product as favorite' do
      expect(product).to receive(:favorite_users).and_return(@users)
    end

    after do
      send_request
    end
  end

  describe "#sort_in_ascending_users_count?" do

    context 'when favorite_user_count asc present in params[q][s]' do
      def send_request
        get :index, params: { page: 1, q: { s: 'favorite_users_count asc' } }
      end

      it "is true" do
        controller.send(:sort_in_ascending_users_count?).should be true
      end

      before do
        send_request
      end
    end

    context 'when favorite_user_count not present in params' do
      def send_request
        get :index, params: { page: 1, q: { s: 'name asc' } }
      end

      it "is false" do
        controller.send(:sort_in_ascending_users_count?).should be false
      end

      before do
        send_request
      end
    end
  end

  describe 'GET users' do
    let(:product) { mock_model(Spree::Product) }
    let(:favorite_product) { mock_model(Spree::Product) }
    let(:favorite_users) { double(ActiveRecord::Relation) }

    def send_request
      get :users, params: { id: product.id }
    end


    before do
      allow(Spree::Product).to receive(:find_by).and_return(product)
      allow(product).to receive(:favorite_users).and_return(favorite_users)
      allow(favorite_users).to receive(:page).and_return(favorite_users)
    end

    it 'is expected to set favorite_users' do
      expect(product).to receive(:favorite_users).and_return(favorite_users)
      send_request
    end
  end
end
