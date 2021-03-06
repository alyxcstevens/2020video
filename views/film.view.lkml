view: film {
  sql_table_name: sakila.film ;;
  drill_fields: [film_id]

  dimension: film_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.film_id ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: language_id {
    type: yesno
    # hidden: yes
    sql: ${TABLE}.language_id ;;
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

  dimension: length {
    type: number
    sql: ${TABLE}.length ;;
  }

  dimension: original_language_id {
    type: yesno
    sql: ${TABLE}.original_language_id ;;
  }

  dimension: rating {
    type: string
    sql: ${TABLE}.rating ;;
  }

  dimension_group: release_year {
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
    sql: ${TABLE}.release_year ;;
  }

  dimension: rental_duration {
    type: yesno
    sql: ${TABLE}.rental_duration ;;
  }

  dimension: rental_rate {
    type: number
    sql: ${TABLE}.rental_rate ;;
  }

  dimension: replacement_cost {
    type: number
    sql: ${TABLE}.replacement_cost ;;
  }

  dimension: special_features {
    type: string
    sql: ${TABLE}.special_features ;;
  }

  dimension: title {
    type: string
    sql: ${TABLE}.title ;;

    link: {
      label: "Film Lookup Dashboard"
      url: "/dashboards/761?FIlm%20Title={{ value }}"
      icon_url: "https://cdn3.iconfinder.com/data/icons/video-5/24/VHS-Cassette-512.png"
    }
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      film_id,
      language.language_id,
      language.name,
      film_actor.count,
      film_category.count,
      film_text.count,
      inventory.count
    ]
  }
}
