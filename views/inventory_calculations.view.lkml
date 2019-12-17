view: inventory_calculations {

    derived_table: {
      persist_for: "24 hours"
      indexes: ["inventory_id"]
      sql: SELECT inventory.inventory_id,
                MIN(rental.rental_date) as first_rental,
                MAX(rental.rental_date) as last_rental,
                MAX(rental.return_date) as last_return,
                MAX(rental.rental_id) as last_rental_id
        FROM sakila.rental  AS rental
        LEFT JOIN sakila.inventory  AS inventory ON rental.inventory_id = inventory.inventory_id
        group by inventory_id
 ;;
    }

    dimension: inventory_id {
      hidden: yes
      primary_key: yes
      type: number
      sql: ${TABLE}.inventory_id ;;
    }

    dimension: last_rental_id {
      type: number
      sql: ${TABLE}.last_rental_id ;;
    }

    dimension: currently_in_stock {
      type: yesno
      sql:
      DATEDIFF(${last_return_date}, ${last_rental_date}) >= 0
      and ${last_return_date} is not null;;
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

    measure: count {
      hidden: yes
      type: count
    }

    measure: count_currently_in_stock_inventory {
      type: count_distinct
      filters: {
        field: currently_in_stock
        value: "yes"
      }
      sql: ${inventory_id} ;;
    }

    measure: count_of_inventory {
      type: count_distinct
      sql: ${inventory_id} ;;
    }



    set: detail {
      fields: [inventory_id
        , inventory.store_id
        , film.title
        , category.name
        , film.replacement_cost
        , film.rental_rate
      ]
    }
    }
