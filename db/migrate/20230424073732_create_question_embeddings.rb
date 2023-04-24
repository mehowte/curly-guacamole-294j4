class CreateQuestionEmbeddings < ActiveRecord::Migration[7.0]
  def change
    create_table :question_embeddings do |t|
      t.string :question, null: false, index: { unique: true }
      t.jsonb :embedding, null: false
      
      t.timestamps
    end
  end
end
