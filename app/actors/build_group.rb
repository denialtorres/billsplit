class BuildGroup < Actor
  input :group_params
  input :main_user
  output :group

  def call
    self.group = Group.new(group_params.permit(:name))
    group.users << main_user
  rescue StandardError => e
    fail!(error: "#{e}")
  end
end
