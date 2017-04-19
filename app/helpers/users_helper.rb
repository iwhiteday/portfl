module UsersHelper
  def sexes_list
    User.sexes
  end

  def preferences_list
    Preference.all
  end
end
