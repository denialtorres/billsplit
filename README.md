# Instructions

Create two forms (one for splitting equally and the other for splitting unequally) below the group page.

In the equal split form, a user can perform the following:

Select the user who paid the expense.
Select the users between whom the total amount has to be divided.
Add the total amount.
In the unequal split form, a user can perform the following:

Select the user who paid the expense.
Add the total amount.
Add the share of each member.

### Use the parameters passed from the equal split form as follows:

Subtract the expense per person from every person’s arrears and update the row in the expenses table.
For the person who paid the expense, add the total amount paid to their arrears and subtract the expense per person if they checked their name.
If their name is unchecked, simply add the total amount and update the record.
