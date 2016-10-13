CONFLICTS_FOR_TALK_VIEW_SQL = <<EOS
CREATE VIEW "conflicts_for_talks" AS
SELECT     DISTINCT("left"."talk_id")              AS "talk_id",
           COUNT("right"."talk_preference_id") - 1 AS "conflicts"
FROM       "selected_talks"                        AS "left"
INNER JOIN "selected_talks"                        AS "right"
ON         "left"."talk_id" = "right"."talk_id"
GROUP BY   "left"."id";
EOS

class AddConflictsForTalkView < ActiveRecord::Migration[5.0]
  def up
    execute CONFLICTS_FOR_TALK_VIEW_SQL
  end

  def down
    execute 'DROP VIEW "conflicts_for_talks"'
  end
end
