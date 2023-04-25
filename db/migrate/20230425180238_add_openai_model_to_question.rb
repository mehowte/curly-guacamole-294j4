class AddOpenaiModelToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :openai_model, :string, null: false, default: "text-davinci-003"
    remove_index :questions, [:project_name, :question], unique: true
    add_index :questions, [:project_name, :question, :openai_model], unique: true
  end
end
