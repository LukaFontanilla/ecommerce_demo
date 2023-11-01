view: sleep {
  derived_table: {
    sql: SELECT sleep({{ sleep.sleep_seconds._parameter_value  | replace: "'", '' }}) as sleep_dimension
      ;;
  }

  parameter: sleep_seconds {
    description: "How long the query should run (in seconds)"
    required_fields: [sleep_dimension]
    type: number
  }

  dimension: sleep_dimension {
    sql: ${TABLE}.sleep_dimension ;;
  }
}
