class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info]
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy, :edit_basic_info, :update_basic_info, :edit_user]
  before_action :correct_user, only: [:edit, :update]
  before_action :admin_user, only: [:destroy, :edit_basic_info, :update_basic_info]
  before_action :set_one_month, only: [:show]
  before_action :admin_or_correct, only: [:show]
  
    # システム管理権限所有かどうか判定します。

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
    # @items = Item.all
    # respond_to do |format|
    #   format.html
    #   format.csv { send_data Item.to_csv, type: 'text/csv; charset=shift_jis', filename: "items.csv" }
    # end    
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
  
   
  def self.import(file)
    CSV.foreach(file.path, headers: true) do |row|
      user = find_by(id: row["id"]) || new
      user.attributes = row.to_hash.slice(*updatable_attributes)
      user.save
    end
  end      
    
  def self.updatable_attribute
    ["name", "email", "affiliation", "employee_number", "uid",
    "basic_work_time", "designated_work_start_time", "designated_work_end_time",
    "superior", "admin", "password"]
  end   
  
  
 
  def user

   respond_to do |format|
     format.html
     format.csv do |csv|

       users = User.all    

　　　　if params[:started_at][:date].present? && params[:ended_at][:date].present?
         fromdate = params[:ended_at][:date].to_date
         users = users.where(created_at: (params[:started_at])..fromdate.end_of_day)
      end

       csv_data = CSV.generate do |csv|
         header = %w(id name email age)
         csv << header           

         users.each do |user|
           values = [name, email, affiliation, employee_number, uid,
    basic_work_time, designated_work_start_time, designated_work_end_time,
    superior, admin, password]
           csv << values        
         end
       end
       send_data(csv_data, filename: "users.csv")
   end    
  end
  
  # def data
  #   require 'csv'
  #   @path = params[:csv].path
  #   csv = CSV.table("#{@path}", encoding: "Shift_JIS:UTF-8")
  #   @name = csv[:name]
  #   @class = csv[:class]
  #   @score = csv[:score]
  # end  
  
  def data
    require 'csv'
    
    @path = params[:csv].path
    csv = CSV.table("#{@path}", encoding: "Shift_JIS:UTF-8")
    @name = csv[:name]
    @class = csv[:class]
    @score = csv[:score]
    
    @namesize = @name.size.to_i
    
    add1,num1,add2,num2 = 0,0,0,0
    
    for i in 0...@namesize do
      if @class[i] == 1
        add1 += @score[i].to_i
        num1 += 1
      elsif @class[i] == 2
        add2 += @score[i].to_i
        num2 += 1
      end
    end 
    @avg1 = add1 / num1
    @avg2 = add2 / num2
  end
end
