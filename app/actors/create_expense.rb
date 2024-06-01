class CreateExpense < Actor
  play BuildExpenses
  play SplitEqualExpenses, if: ->(actor) { actor.action == 'equal' }
  play SplitUnequalExpenses, if: ->(actor) { actor.action != 'equal' }
end
