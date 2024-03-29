# If necessary, uncomment the line below to include explore_source.
# include: "thelookai.model.lkml"
view: customer_profile {
  derived_table: {
    datagroup_trigger: ecommerce_etl_modified
    explore_source: order_items {
      column: id { field: users.id }
      column: email { field: users.email }
      column: gender { field: users.gender}
      column: name { field: users.name}
      column: age { field : users.age}
      column: days_as_customer { field: user_order_facts.days_as_customer }
      column: lifetime_orders { field: user_order_facts.lifetime_orders }
      column: lifetime_revenue { field: user_order_facts.lifetime_revenue }
      column: latest_order_date { field: user_order_facts.latest_order_date }
      column: city { field: users.city }
      column: country { field: users.country }
      column: state { field: users.state }
      column: prefered_categories { field: products.prefered_categories }
      column: prefered_brands { field: products.prefered_brands }
      derived_column: p_brands {
        sql: replace(prefered_brands, "|RECORD|", ", ") ;;
      }
      derived_column: p_categories {
        sql: replace(prefered_categories, "|RECORD|", ", ") ;;
      }
      filters: {
        field: users.id
        value: "NOT NULL"
      }
      filters: {
        field: order_items.created_date
        value: "7 days"
      }
    }
  }
  dimension: gender {}
  dimension: id {
    description: ""
    type: number
  }
  dimension: email {
    description: ""
  }
  dimension: days_as_customer {
    label: "Users Facts Days As Customer"
    description: "Days between first and latest order"
    type: number
  }
  dimension: lifetime_orders {
    label: "Users Facts Lifetime Orders"
    description: ""
    type: number
  }
  dimension: lifetime_revenue {
    label: "Users Facts Lifetime Revenue"
    description: ""
    value_format: "$#,##0.00"
    type: number
  }
  dimension: latest_order_date {
    label: "Users Facts Latest Orders"
    description: ""
    type: date
  }
  dimension: city {
    description: ""
  }
  dimension: country {
    description: ""
  }
  dimension: state {
    description: "Users State of Origin in the US"
  }
  dimension: prefered_categories {
    description: ""
    #type: number
  }
  dimension: prefered_brands {
    description: ""
    #type: number
  }
  dimension: p_brands {}
  dimension: p_categories {}
}


view: promo_email {
  derived_table: {
    datagroup_trigger: ecommerce_etl_modified
    sql: SELECT
        ml_generate_text_result['predictions'][0]['content'] AS generated_text,
        ml_generate_text_result['predictions'][0]['safetyAttributes']
          AS safety_attributes,
        * EXCEPT (ml_generate_text_result)
      FROM
        ML.GENERATE_TEXT(
          MODEL  `looker-private-demo.thelook_ecommerce.email_promotion`,
          (
            SELECT
      FORMAT(
        CONCAT(
          'This is one of our most loyal customers. Please write a personalized email for them offering a 15 percent discount from the fictious company TheLook using code LOYAL15. The email should incorporate the following data, representing the customer profile, to personalize the email text. Please use the customers name in the email.'
          , 'Name: %s | Age: %d | State: %s | Days as Customer: %d | Lifetime Revenue: %f'
        )
        , name
        , age
        , state
        , days_as_customer
        , lifetime_revenue
      )
      AS prompt,
      id
      FROM  ${customer_profile.SQL_TABLE_NAME}
      ),
      STRUCT(
      0.2 AS temperature,
      100 AS max_output_tokens)) ;;
  }

  parameter: prompt {
    type: unquoted
    view_label: "Order Items"
    allowed_value: {
      label: "1. Generate Marketing Email for Loyal Customers"
      value: "This is one of our most loyal customers. Please write a personalized email for them offering a 15% discount using code LOYAL15. Incorporate the following data into the personalization of the email."
    }
  }

  dimension: generated_text {
    label: "AI Generated Email"
    description: "Use with the user email in filter"
    view_label: "Users"
    type: string
    sql: JSON_VALUE(${TABLE}.generated_text) ;;
  }

  dimension: id {
    hidden: yes
    primary_key: yes
  }

  filter: gen_ai_email { #### Will need to see we integrate this to the UI in efficient way
    hidden: yes
    description: "If you want to override the email with some user input, use this field"
    type: string
  }

  dimension: gen_ai {
    hidden: yes
    type: string
    sql: {% parameter gen_ai_email %} ;;
  }
}
