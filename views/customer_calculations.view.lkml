view: customer_calculations {
  derived_table: {
    persist_for: "24 hours"
    indexes: ["customer_id"]
    sql:SELECT
        rental.customer_id
        , min(rental.rental_date) as first_rental
        , min(rental.return_date) as first_return
        , max(rental.rental_date) as last_rental
        , max(rental.return_date) as last_return
        , count(rental.rental_id) as lifetime_rentals
        , sum(payment.amount) as lifetime_spend
      FROM sakila.rental as rental
      left join sakila.payment as payment on rental.rental_id = payment.rental_id
      group by 1
       ;;
  }

  dimension: customer_id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.customer_id ;;
  }

  dimension: lifetime_rentals {
    type: number
    sql: ${TABLE}.lifetime_rentals ;;
  }

  dimension: lifetime_value {
    type: number
    sql: ${TABLE}.lifetime_spend ;;
    value_format_name: usd
  }

  measure: average_lifetime_value {
    type: average
    sql: ${lifetime_value} ;;
    value_format_name: usd
  }

  dimension: is_currently_late {
    description: "checks to see whether a customer is late or not"
    type: yesno
    sql: datediff(${last_return_date}, ${current_due_date}) > 0 or (${last_return_date} is null and datediff(curdate(),${current_due_date}) > 0) or datediff(${last_rental_date},${last_return_date}) > 0;;
  }

  dimension: lifetime_rentals_tier {
    type: tier
    style: integer
    tiers: [10,20,30,40,50]
    sql: ${lifetime_rentals} ;;
  }

  dimension: lifetime_spend_tier {
    type: tier
    style: integer
    tiers: [50,75,100, 150, 200]
    sql: ${lifetime_value} ;;
  }

  dimension: months_since_first_rental {
    description: "Number of months since a customer's first rental"
    type: number
    sql: TIMESTAMPDIFF(month, ${first_rental_date}, ${rental.rental_date}) ;;
  }

#   dimension: is_within_30_days {
#     hidden: yes
#     type: yesno
#     sql: ${rental.rental_date} between ${first_rental_date} and date_add(${first_rental_date}, INTERVAL 1 month);;
#   }

  dimension_group: last_rental {
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
    sql: ${TABLE}.last_rental ;;
  }

  dimension_group: last_return {
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
    sql: ${TABLE}.last_return ;;
  }

  dimension_group: first_rental {
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
    sql: ${TABLE}.first_rental ;;
  }

  dimension_group: first_return {
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
    sql: ${TABLE}.first_return ;;
  }

  dimension_group: current_due {
    description: "due date for current rental"
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
    sql: date_add(${last_rental_date}, interval 7 day) ;;
  }

#   dimension: late_customer_timeframes {
#     description: "Use this field in combination with the date filter field for dynamic date filtering"
#     suggestions: ["period","previous period"]
#     type: string
#     case:  {
#       when:  {
#         sql: ${current_due_raw} BETWEEN ${rental.filter_start_date_raw} AND  ${rental.filter_end_date_raw};;
#         label: "Period"
#       }
#       when: {
#         sql: ${current_due_raw} BETWEEN ${rental.previous_start_date} AND ${rental.filter_start_date_raw} ;;
#         label: "Previous Period"
#       }
#       else: "Not in time period"
#     }
#   }

  measure: count {
    hidden: yes
    type: count
    drill_fields: [detail*]
  }

#   measure: count_repeat_rental_30 {
#     description: "Number of customers who have ordered a second rental in the first 30 days"
#     type: count_distinct
#     filters: {
#       field: is_within_30_days
#       value: "yes"
#     }
#     sql: ${customer_id} ;;
#   }

  measure: num_late_customer {
    label: "Late Customer Count"
    description: "the current number of late customers"
    type: count_distinct
    filters: {
      field: is_currently_late
      value: "yes"
    }
    sql: ${customer_id} ;;
    drill_fields: [detail*]
  }

  set: detail {
    fields: [
      customer_id,
      customer.last_name,
      customer.first_name,
      store.store_id,
      payment.count,
      rental.count
    ]
  }
}
