class CreateGroup < Actor
  play BuildGroup,
       AddGroupMembers,
       SaveGroup
end
