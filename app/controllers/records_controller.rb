class RecordsController < ApplicationController
  before_action :set_start_time
  before_action :set_user
  before_action :income, only: %i[income_day day]
  before_action :fixedcost, only: %i[fixedcost_day day]
  before_action :variablecost, only: %i[variablecost_day day]

  #月の収支合計カレンダー
  def month
    @income_values = @user.income_values.order("start_time asc")
    @fixedcost_values = @user.fixedcost_values.order("start_time asc")
    @variablecost_values = @user.variablecost_values.order("start_time asc")
    @all_values = @income_values + @fixedcost_values + @variablecost_values
  end

  #日の収入合計
  def income_day
  end

  #日の固定費合計
  def fixedcost_day
  end

  #日の支出合計
  def variablecost_day
  end

  #日の収支合計
  def day
    @day_total = @income_value_total - (@fixedcost_value_total + @variablecost_value_total)
  end

  #月の収支グラフ
  def graph_month
    # (1) * = 可変長引数、配列として認識される。    (2) split("-") = 文字列を"-"で分断。(3)Time.local = Time オブジェクトを返す。 (4).all_month = その月の１日から月末まで。(5)where = テーブルから（４）の条件で取得。group_by_month = 月ごとにグループ化
    # @start_time = "2022-02" =>  (1)["2022-02"] => (2)["2022", "02"] =>                (3)2022-02-01 00:00:00 +0000 =>           (4)2022-02-01 00:00:00 +0000..2022-02-28 23:59:59 +0000

    #月の収入額合計
    @in_value_month = @user.income_values.where(start_time: Time.local(*@start_time.split("-")).all_month)#.group_by_month(:start_time)
    #DBで月の合計額を計算
    @income_value_total = @in_value_month.sum(:value)

    #月の固定費額合計
    @fix_value_month = @user.fixedcost_values.where(start_time: Time.local(*@start_time.split("-")).all_month)#.group_by_month(:start_time)
    #DBで月の合計額を計算
    @fixedcost_value_total = @fix_value_month.sum(:value)

    #月の支出額合計
    @var_value_month = @user.variablecost_values.where(start_time: Time.local(*@start_time.split("-")).all_month)#.group_by_month(:start_time)
    #DBで月の合計額を計算
    @variablecost_value_total = @var_value_month.sum(:value)

    @month_total = @income_value_total - (@fixedcost_value_total + @variablecost_value_total)

  end



  private

  def set_start_time
    @start_time = params[:start_time]
  end

  def set_user
    @user = current_user
  end

  def income
    @incomes = @user.incomes.order(created_at: :asc)
    @income_values = @user.income_values.where(start_time: @start_time)
    #DBで合計額を計算
    @income_value_total = @income_values.sum(:value)
  end

  def fixedcost
    @fixedcosts = @user.fixedcosts.order(created_at: :asc)
    @fixedcost_values = @user.fixedcost_values.where(start_time: @start_time)
    #DBで合計額を計算
    @fixedcost_value_total = @fixedcost_values.sum(:value)
  end

  def variablecost
    @variablecosts = @user.variablecosts.order(created_at: :asc)
    @variablecost_values = @user.variablecost_values.where(start_time: @start_time)
    #DBで合計額を計算
    @variablecost_value_total = @variablecost_values.sum(:value)
  end

end
