# frozen_string_literal: true

class Admin::UsersController < Admin::ApplicationController
  before_action :set_user, only: %i[show edit update lock unlock resend_confirmation_mail resend_invitation_mail]
  # before_action :set_breadcrumbs, only: %i[new edit create update], if: -> { request.format.html? }

  def index
    prepare_meta_tags title: t(".title")

    @users = User.all
    @users = @users.where("email LIKE ?", "%#{params[:user_email]}%") if params[:user_email].present?
    @users = @users.page(params[:page]).per(params[:per_page])
  end

  def show
    prepare_meta_tags title: @user.email
  end

  def new
    prepare_meta_tags title: t(".title")
    @user = User.new
  end

  def edit
    prepare_meta_tags title: t(".title")
  end

  def create
    @user = User.new(user_params)

    if @user.save
      redirect_to admin_user_url(@user), notice: t(".shared.notice.created")
    else
      prepare_meta_tags title: t("admin.users.new.title")
      render :new
    end
  end

  def update
    if @user.update_without_password(user_params)
      redirect_to admin_user_url(@user), notice: t(".shared.notice.updated")
    else
      prepare_meta_tags title: t("admin.users.edit.title")
      render :edit
    end
  end

  def lock
    unless @user.access_locked?
      @user.lock_access!
    end

    redirect_to admin_user_url(@user), notice: t(".shared.notice.locked")
  end

  def unlock
    if @user.access_locked?
      @user.unlock_access!
    end

    redirect_to admin_user_url(@user), notice: t(".shared.notice.unlocked")
  end

  def resend_confirmation_mail
    if !@user.confirmed? || @user.pending_reconfirmation?
      @user.resend_confirmation_instructions
    end

    redirect_to admin_user_url(@user), notice: t(".shared.notice.sent_confirmation_mail")
  end

  def resend_invitation_mail
    if @user.created_by_invite? && !@user.invited_to_sign_up?
      @user.deliver_invitation
    end

    redirect_to admin_user_url(@user), notice: t(".shared.notice.sent_confirmation_mail")
  end

  private

    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    def set_breadcrumbs
      @_breadcrumbs = [{
                         text: t("layouts.sidebar.admin.users"),
                         link: admin_users_path
                       }]
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.fetch(:user, {}).permit(:email, :password, :password_confirmation)
    end
end
