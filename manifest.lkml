project_name: "thelook"

constant: currency_format {
  value: "{% if _user_attributes['first_name'] == 'Bryn' %} € {{rendered_value}} {% else %} $ {{rendered_value}} {% endif %}"
}

# test update
