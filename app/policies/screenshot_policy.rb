class ScreenshotPolicy
  attr_reader :current_user, :model
  
  def initialize(current_user, model)
    @current_user = current_user
    @vn = model
  end

  def new?
    @current_user.admin? or @current_user.mod?
  end

  def edit?
    @current_user.admin?
  end

  def create?
    @current_user.admin? or @current_user.mod?
  end

  def update?
    @current_user.admin? or @current_user.mod?
  end

  def destroy?
    @current_user.admin?
  end

  
   
end