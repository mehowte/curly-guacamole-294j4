class AddAudioSrcUrlToQuestions < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :audio_src_url, :string
  end
end
