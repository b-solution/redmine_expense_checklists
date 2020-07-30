class CreateExpenseChecklists < ActiveRecord::Migration[5.2]
  def change
      create_table :expense_checklists do |t|
        t.boolean "is_done", default: false
        t.string "subject", limit: 512
        t.integer "position", default: 1
        t.integer "expense_id", null: false
        t.boolean "is_section", default: false

        t.timestamps
      end
  end
end
