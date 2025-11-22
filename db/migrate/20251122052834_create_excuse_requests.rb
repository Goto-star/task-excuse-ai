class CreateExcuseRequests < ActiveRecord::Migration[7.1]
  def change
    create_table :excuse_requests do |t|
      t.string :task_name
      t.string :urgency
      t.integer :mood
      t.text :result

      t.timestamps
    end
  end
end
