class TranslationPostPolicy
  attr_reader :current_user, :model
  
  def initialize(current_user, model)
    @current_user = current_user
  end

  def edit?
    @current_user.admin? or @current_user.mod?
  end

 
  def update?
    @current_user.admin? or @current_user.mod?
  end

  def destroy?
    @current_user.admin? or @current_user.mod?
  end

  
   
end