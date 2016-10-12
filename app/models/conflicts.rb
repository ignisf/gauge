class Conflicts
  include ActiveModel::Model

  attr_accessor :left, :right

  def conflicts
    TalkPreference.joins('INNER JOIN "selected_talks" AS "left"
                          ON "left"."talk_preference_id" = "talk_preferences"."unique_id"
                          INNER JOIN "selected_talks" AS "right"
                          ON "right"."talk_preference_id" = "talk_preferences"."unique_id"').where(left: {talk_id: @left}, right: {talk_id: @right}).count
  end
end
