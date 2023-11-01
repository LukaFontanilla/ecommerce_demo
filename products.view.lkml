view: products {

  drill_fields: [
    brand,
    category,
    department
  ]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    type: string
    sql: ${TABLE}.category ;;
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  dimension: item_name_link {

    sql:  ${TABLE}.item_name ;;
    html:
      {% assign temp_value = value %}
      <a href="https://self-signed.looker.com:9999/dashboards/6?Retail+Price=%3E500&Item+Name={{temp_value}}" target="_parent">
        <img src="https://www.w3schools.com/images/lamp.jpg" alt="Stickman" width="24" height="39" href="https://self-signed.looker.com:9999/dashboards/6?Retail+Price=%3E500&Item+Name={{temp_value}}"/>
      </a> ;;
  }

  dimension: item_name_link2 {
    sql:  ${TABLE}.item_name ;;
    link: {
      label: "Item name link2"
      url: "https://self-signed.looker.com:9999/dashboards/6?Retail+Price=%3E500&Item+Name={{value}}"
      icon_url: "https://www.w3schools.com/images/lamp.jpg"

    }
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }

  measure: special_count {
    type: count_distinct
    sql: ${id} ;;
    drill_fields: [detail*]
    link: {
      label: "Explore Top 20 Results"
      url: "{{ link }}&limit=20"
    }
  }

  set: detail {
    fields: [id, item_name, rank, retail_price, sku]
  }

  measure: total_retail_price {
    type: sum
    sql: ${retail_price} ;;
  }

  measure: average_retail_price {
    type: average
    sql: ${retail_price} ;;
  }
}
