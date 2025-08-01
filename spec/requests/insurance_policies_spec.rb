require 'rails_helper'

RSpec.describe "InsurancePolicies", type: :request do
  let(:other_policy) { create(:insurance_policy) }

  describe "GET /insurance_policies" do
    before do
      create_list(:insurance_policy, 3)
    end

    context "when user is admin" do
      let(:admin) { create(:user, :admin) }

      before do
        sign_in admin
        get insurance_policies_path, as: :json
      end

      it "responds with success" do
        expect(response).to have_http_status(:ok)
      end

      it "returns all insurance policies" do
        json = response.parsed_body
        expect(json.length).to eq(3)
      end
    end

    context "when user is operator" do
      let(:operator) { create(:user, :operator) }

      before do
        sign_in operator
        get insurance_policies_path, as: :json
      end

      it "responds with success" do
        expect(response).to have_http_status(:ok)
      end

      it "returns all insurance policies" do
        json = response.parsed_body
        expect(json.length).to eq(3)
      end
    end

    context "when user is client" do
      let(:client) { create(:user, :client) }
      let(:own_policy) { create(:insurance_policy, user: client) }

      before do
        own_policy # garante criação antes da requisição
        sign_in client
        get insurance_policies_path, as: :json
      end

      it "responds with success" do
        expect(response).to have_http_status(:ok)
      end

      it "returns only one insurance policy" do
        json = response.parsed_body
        expect(json.length).to eq(1)
      end

      it "returns insurance policy belonging to the client" do
        json = response.parsed_body
        expect(json.first["user_id"]).to eq(client.id)
      end
    end
  end

  describe "GET /insurance_policies/:id" do
    context "when user is admin" do
      let(:admin) { create(:user, :admin) }

      before do
        sign_in admin
        get insurance_policy_path(other_policy), as: :json
      end

      it "responds with success status" do
        expect(response).to have_http_status(:ok)
      end

      it "responds with JSON content type" do
        expect(response.content_type).to include("application/json")
      end
    end

    context "when user is operator" do
      let(:operator) { create(:user, :operator) }

      before do
        sign_in operator
        get insurance_policy_path(other_policy), as: :json
      end

      it "responds with success status" do
        expect(response).to have_http_status(:ok)
      end
    end

    context "when user is client" do
      let(:client) { create(:user, :client) }
      let(:own_policy) { create(:insurance_policy, user: client) }

      before { sign_in client }

      it "can view own insurance_policy" do
        get insurance_policy_path(own_policy), as: :json
        expect(response).to have_http_status(:ok)
      end

      it "cannot view insurance_policy by others" do
        get insurance_policy_path(other_policy), as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "POST /insurance_policies" do
    let(:valid_params) { { insurance_policy: attributes_for(:insurance_policy) } }

    context "when user is admin" do
      let(:admin) { create(:user, :admin) }

      before { sign_in admin }

      it "creates insurance_policy" do
        expect do
          post insurance_policies_path, params: valid_params, as: :json
        end.to change(InsurancePolicy, :count).by(1)
      end

      it "responds with created status" do
        post insurance_policies_path, params: valid_params, as: :json
        expect(response).to have_http_status(:created)
      end

      it "responds with JSON content type" do
        post insurance_policies_path, params: valid_params, as: :json
        expect(response.content_type).to include("application/json")
      end
    end

    context "when user is operator" do
      let(:operator) { create(:user, :operator) }

      before { sign_in operator }

      it "creates insurance_policy" do
        expect do
          post insurance_policies_path, params: valid_params, as: :json
        end.to change(InsurancePolicy, :count).by(1)
      end

      it "responds with created status" do
        post insurance_policies_path, params: valid_params, as: :json
        expect(response).to have_http_status(:created)
      end
    end

    context "when user is client" do
      let(:client) { create(:user, :client) }

      before { sign_in client }

      it "returns forbidden status" do
        post insurance_policies_path, params: valid_params, as: :json
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "PATCH /insurance_policies/:id" do
    let(:update_params) { { insurance_policy: { status: "canceled" } } }

    context "when user is admin" do
      let(:admin) { create(:user, :admin) }

      before do
        sign_in admin
        patch insurance_policy_path(other_policy), params: update_params, as: :json
      end

      it "responds with success status" do
        expect(response).to have_http_status(:ok)
      end

      it "updates the insurance_policy" do
        expect(other_policy.reload.status).to eq("canceled")
      end
    end

    context "when user is operator" do
      let(:operator) { create(:user, :operator) }

      before do
        sign_in operator
        patch insurance_policy_path(other_policy), params: update_params, as: :json
      end

      it "returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when user is client" do
      let(:client) { create(:user, :client) }
      let(:own_policy) { create(:insurance_policy, user: client) }

      before do
        sign_in client
        patch insurance_policy_path(own_policy), params: update_params, as: :json
      end

      it "returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end

  describe "DELETE /insurance_policies/:id" do
    let!(:policy_to_delete) { create(:insurance_policy) }

    context "when user is admin" do
      let(:admin) { create(:user, :admin) }

      before { sign_in admin }

      it "deletes insurance_policy" do
        expect do
          delete insurance_policy_path(policy_to_delete), as: :json
        end.to change(InsurancePolicy, :count).by(-1)
      end

      it "responds with no_content status" do
        delete insurance_policy_path(policy_to_delete), as: :json
        expect(response).to have_http_status(:no_content)
      end
    end

    context "when user is operator" do
      let(:operator) { create(:user, :operator) }

      before do
        sign_in operator
        delete insurance_policy_path(policy_to_delete), as: :json
      end

      it "returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end

    context "when user is client" do
      let(:client) { create(:user, :client) }
      let(:own_policy) { create(:insurance_policy, user: client) }

      before do
        sign_in client
        delete insurance_policy_path(own_policy), as: :json
      end

      it "returns forbidden status" do
        expect(response).to have_http_status(:forbidden)
      end
    end
  end
end
