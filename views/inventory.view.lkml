view: inventory {
  sql_table_name: sakila.inventory ;;
  drill_fields: [inventory_id]

  dimension: inventory_id {
    primary_key: yes
    type: number
    sql: ${TABLE}.inventory_id ;;
  }

  dimension: film_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.film_id ;;
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

  dimension: store_id {
    type: yesno
    # hidden: yes
    sql: ${TABLE}.store_id ;;
  }

  measure: count {
    type: count
    drill_fields: [inventory_id, film.film_id, store.store_id, rental.count]
  }

  dimension: dashboard_link {
    link: {
      label: "2020 Inventory Dashboard"
      url: "/dashboards/757"
      icon_url: "https://www.pinclipart.com/picdir/big/113-1131563_file-emoji-u1f4fc-svg-vhs-stickers-png-clipart.png"
    }
    link: {
      label: "2020 Revenue Dashboard"
      url: "/dashboards/760"
      icon_url: "https://globis-software.com/wp-content/uploads/Globis_sales_increase.png"
    }
    link: {
      label: "2020 Customer Dashboard"
      url: "/dashboards/763"
      icon_url: "https://owips.com/sites/default/files/clipart/people-clipart/246913/people-clipart-transparent-background-246913-9966598.png"
    }
    sql: 'Dashboard Navigation' ;;

  }

}
