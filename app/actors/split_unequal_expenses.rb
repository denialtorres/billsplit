class SplitUnequalExpenses < Actor
  input :members
  input :group_id
  input :total

  def call
    members.each do |key, value|
      old_row = Expense.where(user_id: key, group_id: group_id).first
      new_row = old_row.update(amount: unequal_share(old_row, value))
    end
  rescue StandardError => e
    fail!(error: "#{e}")
  end

  private

  def unequal_share(old_row, value)
    (old_row.amount.to_f - value.to_f).round(2)
  end
end
