class AddGroupMembers < Actor
  input :team_emails
  input :group

  def call
    emails_array = team_emails.split(',')

    emails_array.each do |email|
      group.users << User.where(email: email) unless already_a_member?(email)
    end
  rescue StandardError => e
    fail!(error: "#{e}")
  end

  private

  def already_a_member?(email)
    group.users.collect { |p| (p[:email]).to_s }.include?(email)
  end
end
