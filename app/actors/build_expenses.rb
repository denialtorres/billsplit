class BuildExpenses < Actor
  input :group_id
  input :payer
  input :total

  def call
    new_expense = retrieve_old_expense
    new_expense.update(amount: new_total(new_expense))
  rescue StandardError => e
    fail!(error: "#{e}")
  end

  private

  def retrieve_old_expense
    Expense.where(user_id: payer.id, group_id: group_id).first
  end

  def new_total(expense)
    expense.amount.to_f + total
  end
end
