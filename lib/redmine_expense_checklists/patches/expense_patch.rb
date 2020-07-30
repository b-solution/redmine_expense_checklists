# frozen_string_literal: true

module RedmineExpenseChecklists
  module Patches
      module ExpensePatch
        def self.included(base)
          # base.send :include, InstanceMethods

          base.class_eval do

            if ActiveRecord::VERSION::MAJOR >= 4
              has_many :checklists, lambda { order("#{ExpenseChecklist.table_name}.position") }, :class_name => 'ExpenseChecklist', :dependent => :destroy, :inverse_of => :expense
            else
              has_many :checklists, :class_name => 'ExpenseChecklist', :dependent => :destroy, :inverse_of => :expense, :order => 'position'
            end

            accepts_nested_attributes_for :checklists, :allow_destroy => true, :reject_if => proc { |attrs| attrs['subject'].blank? }


            safe_attributes 'checklists_attributes',
                            :if => lambda { |expense, user| (user.allowed_to?(:done_checklists, expense.project) || user.allowed_to?(:edit_checklists, expense.project)) }
          end
        end

      end
    end
end

Expense.send(:include, RedmineExpenseChecklists::Patches::ExpensePatch)
