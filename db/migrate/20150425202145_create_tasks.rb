class CreateTasks < ActiveRecord::Migration
  def change
    create_table :tasks do |t|
    	t.belongs_to :project
    	t.string :name
    	t.string :description
    	t.integer :difficulty_level

    	t.timestamps
    end
  end
end
