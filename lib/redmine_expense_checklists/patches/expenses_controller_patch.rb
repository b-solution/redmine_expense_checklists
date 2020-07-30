# frozen_string_literal: true

module RedmineExpenseChecklists
  module Patches
      module ExpensesControllerPatch
        def self.included(base)
          # base.send :include, InstanceMethods

          base.class_eval do

            # helper :expense_checklists
            # include ExpenseChecklistsHelper
          end
        end

      end
    end
end

# ExpensesController.send(:include, RedmineExpenseChecklists::Patches::ExpensesControllerPatch)
