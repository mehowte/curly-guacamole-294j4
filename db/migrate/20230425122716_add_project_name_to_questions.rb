class AddProjectNameToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :project_name, :string, null: false, default: "book"
    remove_index :questions, :question, unique: true
    add_index :questions, [:project_name, :question], unique: true
  end
end
