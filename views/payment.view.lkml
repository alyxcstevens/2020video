view: payment {
  sql_table_name: sakila.payment ;;
  drill_fields: [payment_id]

  dimension: payment_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.payment_id ;;
  }

  dimension: amount {
    type: number
    sql: ${TABLE}.amount ;;
    drill_fields: [detail*]
  }

  measure: total_amount {
    type: sum
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }


  measure: average_amount {
    type: average
    sql: ${amount} ;;
    value_format_name: usd
    drill_fields: [detail*]
  }



  dimension: customer_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension_group: last_update {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.last_update ;;
  }

  dimension_group: payment {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.payment_date ;;
  }

  dimension: rental_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.rental_id ;;
  }

  dimension: staff_id {
    type: yesno
    # hidden: yes
    sql: ${TABLE}.staff_id ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      payment_id,
      amount,
      customer.customer_id,
      customer.full_name,
      film.title,
      rental.rental_id
    ]
  }
}
