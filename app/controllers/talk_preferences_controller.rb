class TalkPreferencesController < ApplicationController
  def index
    @talks = Talk.find(:all, from: :halfnarp_friendly, params: {locale: I18n.locale}).to_a.shuffle(random: Random.new(sort_seed))
  end

  def show
    @talk_preference = TalkPreference.find_by hashed_unique_id: params[:id]
    render json: {talk_ids: @talk_preference.talks}
  end

  def create
    @talk_preference = TalkPreference.new talk_preference_params
    @talk_preference.ip_address = current_ip_address

    if @talk_preference.save
      render json: {
               update_url: talk_preference_url(@talk_preference),
               hashed_uid: @talk_preference.hashed_unique_id,
               uid: @talk_preference.id
             }, status: :created
    else
      render status: :unprocessable_entity
    end
  end

  def update
    @talk_preference = TalkPreference.find params[:id]

    if @talk_preference.update talk_preference_params
      render json: {
               update_url: talk_preference_url(@talk_preference),
               hashed_uid: @talk_preference.hashed_unique_id,
               uid: @talk_preference.id
             }
    else
      render status: :unprocessable_entity
    end
  end

  private

  def talk_preference_params
    params.require(:talk_preference).permit(talks: [])
  end
end
