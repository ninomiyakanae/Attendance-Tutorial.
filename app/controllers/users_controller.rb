class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_user]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: [:show]
  before_action :admin_or_correct, only: [:show]

  def logged_in_user
   unless logged_in?
    flash[:danger] = "ログインしてください。"
    redirect_to login_url
   end  
  end
  
  def correct_user
  @user = User.find(params[:id])
  redirect_to(root_url) unless @user == current_user
  end

  def index
    @users = User.where.not(id: 1).paginate(page: params[:page]).search(params[:search])
    # redirect_to(root_url) unless @user == current_user
  end

  def show
    @worked_sum = @attendances.where.not(started_at: nil).count
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      log_in @user
      flash[:success] = '新規作成に成功しました。'
      redirect_to @user
    else
      render :new
    end
  end

  def edit
    @user =User.find(params[:id])
  end

  def update
    if @user.update_attributes(user_params)
      flash[:success] = "ユーザー情報を更新しました。"
      redirect_to @user
    else
      render :edit      
    end
  end

  def destroy
    @user.destroy
    flash[:success] = "#{@user.name}のデータを削除しました。"
    redirect_to users_url
  end

  def edit_basic_info
  end

  def edit_one_month
  end
  
  def update_basic_info
    if @user.update_attributes(basic_info_params)
      flash[:success] = "#{@user.name}の基本情報を更新しました。"
    else
      flash[:danger] = "#{@user.name}の更新は失敗しました。<br>" + @user.errors.full_messages.join("<br>")
    end
    redirect_to users_url
  end

  private

  def user_params
   params.require(:user).permit(:name, :email, :department, :password, :password_confirmation, :a_start_at, :a_finish_at)

  end

  def basic_info_params
    params.require(:user).permit(:department, :basic_time, :work_time)
  end  
  
  def basic_work_time
    @a_finish_at -= @a_start_at 
  end  
  
  # def edit_overwork_request
  #     @user = User.find(params[:id])
  #     redirect_to(root_url) unless current_user?(@user)
  #     @first_day = first_day(params[:first_day])
  #     @last_day = @first_day.end_of_month
  #     (@first_day..@last_day).each do |day|
  #       unless @user.attendances.any? {|attendance| attendance.worked_on == day}
  #         record = @user.attendances.build(worked_on: day)
  #         record.save
  #       end
  #     end
  #     @dates = user_attendances_month_date
  #     @worked_sum = @dates.where.not(started_at: nil).count
  #   end
  
end
