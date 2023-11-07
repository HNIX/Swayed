# This migration comes from rules (originally 20120831173835)
class CreateRuleSets < ActiveRecord::Migration[7.0]
  def change
    create_table :rules_rule_sets do |t|
      t.belongs_to :rule_source, polymorphic: true
      t.string :evaluation_logic

      t.timestamps
    end
  end
end
