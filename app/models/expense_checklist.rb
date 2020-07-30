class ExpenseChecklist < ActiveRecord::Base
  unloadable
  include Redmine::SafeAttributes
  belongs_to :expense
  belongs_to :author, :class_name => "User", :foreign_key => "author_id"

  attr_protected :id if ActiveRecord::VERSION::MAJOR <= 4

  acts_as_event :datetime => :created_at,
                :url => Proc.new {|o| {:controller => 'expenses', :action => 'show', :id => o.expense_id}},
                :type => 'expense expense-closed',
                :title => Proc.new {|o| o.subject },
                :description => Proc.new {|o| "#{l(:field_expense)}:  #{o.expense.subject}" }


  if ActiveRecord::VERSION::MAJOR >= 4
    acts_as_activity_provider :type => "checklists",
                              :permission => :view_checklists,
                              :scope => preload({:expense => :project})
    acts_as_searchable :columns => ["#{table_name}.subject"],
                       :scope => lambda { includes([:expense => :project]).order("#{table_name}.id") },
                       :project_key => "#{Expense.table_name}.project_id"

  else
    acts_as_activity_provider :type => "checklists",
                              :permission => :view_checklists,
                              :find_options => {:expense => :project}
    acts_as_searchable :columns => ["#{table_name}.subject"],
                       :include => [:expense => :project],
                       :project_key => "#{Expense.table_name}.project_id",
                       :order_column => "#{table_name}.id"
  end

  rcrm_acts_as_list

  validates_presence_of :subject
  validates_length_of :subject, :maximum => 512
  validates_presence_of :position
  validates_numericality_of :position


  def self.old_format?(detail)
    (detail.old_value.is_a?(String) && detail.old_value.match(/^\[[ |x]\] .+$/).present?) ||
        (detail.value.is_a?(String) && detail.value.match(/^\[[ |x]\] .+$/).present?)
  end

  safe_attributes 'subject', 'position', 'expense_id', 'is_done', 'is_section'

  def editable_by?(usr = User.current)
    usr && (usr.allowed_to?(:edit_checklists, project) || (author == usr && usr.allowed_to?(:edit_own_checklists, project)))
  end

  def project
    expense.project if expense
  end

  def info
    "[#{is_done ? 'x' : ' '}] #{subject.strip}"
  end

  def add_to_list_bottom
    return unless expense.checklists.select(&:persisted?).map(&:position).include?(self[position_column])
    self[position_column] = bottom_position_in_list.to_i + 1
  end
end
