class VariablecostValuesController < ApplicationController
  before_action :ensure_correct_user, except: [:new, :index, :create]

  def index
    user = current_user
    @variablecosts = user.variablecosts.all
    @variablecost_values = user.variablecost_values.order("start_time asc")
  end

  def show
  end

  def new
    user = current_user
    @variablecosts = user.variablecosts.all
    @variablecost_value = VariablecostValue.new
  end

  def edit
    user = current_user
    @variablecosts = user.variablecosts.all
  end

  def create
    @variablecost_value = VariablecostValue.new(variablecost_value_params)
    if @variablecost_value.save
      redirect_to variablecost_value_path(@variablecost_value), notice: '登録しました'
    else
      user = current_user
      @variablecosts = user.variablecosts.all
      render 'new'
    end
  end

  def update
    if @variablecost_value.update(variablecost_value_params)
      redirect_to variablecost_value_path(@variablecost_value), notice: "データを更新しました。"
    else
      render 'edit'
    end
  end

  def destroy
	  @variablecost_value.destroy
	  redirect_to month_records_path, notice: "データを削除しました"
  end

  private

  def variablecost_value_params
    params.require(:variablecost_value).permit(:variablecost_id, :content, :start_time, :value, :description, :privacy).merge(user_id: current_user.id, code: 3)
  end

  def ensure_correct_user
    @variablecost_value = VariablecostValue.find(params[:id])
    unless @variablecost_value.user_id == current_user.id
      redirect_to month_records_path
    end
  end

end
