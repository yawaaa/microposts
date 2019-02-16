class CreateRelationships < ActiveRecord::Migration[5.0]
  def change
    create_table :relationships do |t|
      t.references :user, foreign_key: true
      t.references :follow, foreign_key: { to_table: :users}
      # そのままだとfollow TBLを見に行ってエラー

      t.timestamps
      
      t.index [:user_id, :follow_id], unique: true
      # user_id=follow_id を禁止
    end
  end
end
