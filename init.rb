Redmine::Plugin.register :redmine_expense_checklists do
  name 'Redmine Expense Checklists plugin'
  author 'Bilel KEDIDI'
  description 'This is a plugin for Redmine'
  version '0.0.1'
  url 'https://www.github.com/bilel-kedidi/redmine_expense_checklists'
  author_url 'https://www.github.com/bilel-kedidi'
end

require 'redmine_expense_checklists/patches/expense_patch'
require 'redmine_expense_checklists/patches/expenses_controller_patch'

class ExpenseHookListener < Redmine::Hook::ViewListener
  include ActionView::Helpers::TagHelper

  render_on :form_expense_bottom, partial: 'expenses/checklist_form'
end

