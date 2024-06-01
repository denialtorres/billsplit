class SaveGroup < Actor
  input :group

  def call
    group.save!
  rescue StandardError => e
    fail!(error: "#{e}")
  end
end
