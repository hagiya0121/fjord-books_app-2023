# frozen_string_literal: true

class ReportsController < ApplicationController
  before_action :set_report, only: %i[show edit update destroy]

  def index
    @reports = Report.order(:id).page(params[:page])
  end

  def show
    @report = Report.find(params[:id])
    @comment = @report.comments.build
    @comments = @report.comments.order(:id).page(params[:page])
  end

  def new
    @report = Report.new
  end

  def edit
    return if current_user == @report.user

    redirect_to @report, alert: t('errors.messages.unauthorized')
  end

  def create
    @report = current_user.reports.build(report_params)

    if @report.save
      redirect_to @report, notice: t('controllers.common.notice_create', name: Report.model_name.human)
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    unless current_user == @report.user
      redirect_to @report, alert: t('errors.messages.unauthorized')
      return
    end

    if @report.update(report_params)
      redirect_to @report, notice: t('controllers.common.notice_update', name: Report.model_name.human)
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if current_user == @report.user
      @report.destroy
      redirect_to reports_url, notice: t('controllers.common.notice_destroy', name: Report.model_name.human), status: :see_other
    else
      redirect_to @report, alert: t('errors.messages.unauthorized')
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(:title, :text)
  end
end
