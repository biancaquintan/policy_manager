# app/controllers/insurance_policies_controller.rb
class InsurancePoliciesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_insurance_policy, only: %i[show edit update destroy]

  after_action :verify_authorized, except: :index
  after_action :verify_policy_scoped, only: :index

  def index
    @insurance_policies = policy_scope(InsurancePolicy)
  end

  def show
    authorize @insurance_policy
  end

  def new
    @insurance_policy = InsurancePolicy.new
    authorize @insurance_policy
  end

  def edit
    authorize @insurance_policy
  end

  def create
    @insurance_policy = current_user.insurance_policies.build(insurance_policy_params)
    authorize @insurance_policy

    if @insurance_policy.save
      redirect_to @insurance_policy, notice: t('insurance_policy.created')
    else
      render :new
    end
  end

  def update
    authorize @insurance_policy
    if @insurance_policy.update(insurance_policy_params)
      redirect_to @insurance_policy, notice: t('insurance_policy.updated')
    else
      render :edit
    end
  end

  def destroy
    authorize @insurance_policy
    @insurance_policy.destroy
    redirect_to insurance_policies_url, notice: t('insurance_policy.destroyed')
  end

  private

  def set_insurance_policy
    @insurance_policy = InsurancePolicy.find(params[:id])
  end

  def insurance_policy_params
    params.require(:insurance_policy).permit(:policy_number, :start_date, :end_date, :status)
  end
end
