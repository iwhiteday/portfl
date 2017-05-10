module UsersHelper
  def sexes_list(sexes = {})
    User.sexes.each {|sex| sexes[sex[1]] = {text: User.human_enum_name(:sex, sex.first), value: sex[1]}}
    sexes
  end

  def preferences_list
    Preference.all
  end
end
