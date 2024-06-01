class SplitEqualExpenses < Actor
  input :members
  input :group_id
  input :total

  def call
    members.each do |member|
      old_row = Expense.where(user_id: member, group_id: group_id).first
      new_row = old_row.update(amount: equal_share(old_row))
    end
  rescue StandardError => e
    fail!(error: "#{e}")
  end

  private

  def equal_share(old_row)
    (old_row.amount.to_f - total / members.size).round(2)
  end
end
