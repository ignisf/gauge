CONFLICTS_VIEW_SQL = <<EOS
CREATE VIEW "conflicts" AS
SELECT      "left"."talk_id" AS left, "right"."talk_id" AS right, COUNT(*) AS "conflicts"
FROM        "selected_talks"                              AS "left"
INNER JOIN  "selected_talks"                              AS "right"
ON          "left"."talk_preference_id" = "right"."talk_preference_id"
WHERE       "left"."talk_id" != "right"."talk_id"
GROUP BY    "left"."talk_id", "right"."talk_id";
EOS

class AddConflictsView < ActiveRecord::Migration[5.0]
  def up
    execute CONFLICTS_VIEW_SQL
  end

  def down
    execute 'DROP VIEW "conflicts"'
  end
end
