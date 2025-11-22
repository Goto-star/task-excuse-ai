class ExcuseRequestsController < ApplicationController
  def new
    @excuse_request = ExcuseRequest.new
  end

  def create
    @excuse_request = ExcuseRequest.new(excuse_request_params)

    # サービスを実行して言い訳を生成
    generated_text = ExcuseGenerator.new(
      task_name: @excuse_request.task_name,
      urgency: @excuse_request.urgency,
      mood: @excuse_request.mood
    ).generate

    @excuse_request.result = generated_text

    if @excuse_request.save
      redirect_to @excuse_request
    else
      flash.now[:alert] = "入力内容に不備があります。"
      render :new
    end
  end

  def show
    @excuse_request = ExcuseRequest.find(params[:id])
  end

  def index
    @excuse_requests = ExcuseRequest.order(created_at: :desc)
  end

  def destroy
    @excuse_request = ExcuseRequest.find(params[:id])
    @excuse_request.destroy
    redirect_to excuse_requests_path, notice: "言い訳リクエストを削除しました。"
  end

  private

  def excuse_request_params
    params.require(:excuse_request).permit(:task_name, :urgency, :mood)
  end
end
