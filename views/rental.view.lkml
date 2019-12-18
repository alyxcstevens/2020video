view: rental {
  sql_table_name: sakila.rental ;;
  drill_fields: [rental_id]

  dimension: rental_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.rental_id ;;
  }

  dimension: customer_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.customer_id ;;
  }

  dimension: inventory_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_id ;;
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

  dimension_group: rental {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      day_of_week
    ]
    sql: ${TABLE}.rental_date ;;
  }

  dimension_group: return {
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
    sql: ${TABLE}.return_date ;;
  }

  dimension_group: due_date {
    description: "Due Date for a Rental"
    type: time
    sql: date_add(${rental_date}, interval 7 day) ;;
  }

  dimension: is_rental_overdue {
    type: yesno
    sql: datediff(${return_date}, ${due_date_date}) > 0
         OR (${return_date} IS NULL AND datediff(CURDATE(), ${due_date_date}) >0) ;;
  }

  dimension: is_movie_rented {
    type: yesno
    sql: ${inventory_calculations.currently_in_stock} = "no" ;;
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
      rental_id,
      inventory.inventory_id,
      customer.customer_id,
      customer.first_name,
      customer.last_name,
      staff.staff_id,
      staff.first_name,
      staff.last_name,
      staff.username,
      payment.count
    ]
  }
}
