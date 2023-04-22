class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :question, null: false, index: { unique: true }
      t.string :answer, null: false

      t.timestamps
    end
  end
end
