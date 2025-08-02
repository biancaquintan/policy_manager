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
    @insurance_policy = current_user.insurance_policies.build(insurance_policy_params)
    authorize @insurance_policy

    if @insurance_policy.save
      render json: @insurance_policy, status: :created
    else
      render json: @insurance_policy.errors, status: :unprocessable_entity
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
    params.require(:insurance_policy).permit(
      :policy_number,
      :start_date,
      :end_date,
      :total_deductible,
      :total_coverage,
      :status
    )
  end
end
