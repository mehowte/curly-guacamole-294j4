class AddContextToQuestion < ActiveRecord::Migration[7.0]
  def change
    add_column :questions, :context, :text
  end
end
