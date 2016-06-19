# frozen_string_literal: true

class UserListPresenter
  include Contracts::Core
  include Contracts::Builtin

  Contract User::ActiveRecord_Relation => UserListPresenter
  def initialize(users)
    @users = users.order(:name)
    self
  end

  Contract Func[String, Num => Any] => Any
  def each(&block)
    @users.each do |user|
      block.call user.name, user.repositories.count # rubocop:disable Performance/RedundantBlockCall
    end
  end
end
