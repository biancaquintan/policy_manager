# app/controllers/insurance_policies_controller.rb
class InsurancePoliciesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_insurance_policy, only: %i[show update destroy]

  def index
    @insurance_policies = policy_scope(InsurancePolicy)
    render json: @insurance_policies
  end

  def show
    authorize @insurance_policy
    render json: @insurance_policy
  end

  def create
    @insurance_policy = InsurancePolicy.new(insurance_policy_params)
    authorize @insurance_policy

    @insurance_policy.user ||= current_user

    if @insurance_policy.save
      render json: @insurance_policy, status: :created
    else
      render json: { errors: @insurance_policy.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def update
    authorize @insurance_policy

    if @insurance_policy.update(insurance_policy_params)
      render json: @insurance_policy
    else
      render json: @insurance_policy.errors, status: :unprocessable_entity
    end
  end

  def destroy
    authorize @insurance_policy
    @insurance_policy.destroy
    head :no_content
  end

  private

  def set_insurance_policy
    @insurance_policy = InsurancePolicy.find(params[:id])
  end

  def insurance_policy_params
    permitted = [
      :policy_number,
      :start_date,
      :end_date,
      :total_deductible,
      :total_coverage,
      :status
    ]
    permitted << :user_id if InsurancePolicyPolicy.new(current_user, nil).assign_user_id?
    params.require(:insurance_policy).permit(permitted)
  end
end
