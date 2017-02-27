view: ga_sessions {
  sql_table_name: (
      SELECT * FROM
      #MINDTAP
      (SELECT 'MindTap' as ProductPlatform, 'PROD' as Environment, * FROM (select null limit 0)
        ,{% table_date_range date_filter titanium-kiln-120918:115907067.ga_sessions_ %}
        ,{% table_date_range date_filter titanium-kiln-120918:115907067.ga_sessions_intraday_ %})
      #Mindtap Mobile
      ,(SELECT 'MindTap Mobile' as ProductPlatform, 'PROD' as Environment, * FROM (select null limit 0)
        ,{% table_date_range date_filter titanium-kiln-120918:92812344.ga_sessions_ %}
        ,{% table_date_range date_filter titanium-kiln-120918:92812344.ga_sessions_intraday_ %})
      #Mindtap GTM
      ,(SELECT 'MindTap GTM Version' as ProductPlatform, 'PROD' as Environment, * FROM (select null limit 0)
        ,{% table_date_range date_filter titanium-kiln-120918:116451265.ga_sessions_ %}
        ,{% table_date_range date_filter titanium-kiln-120918:116451265.ga_sessions_intraday_ %})
      #SAM
      ,(SELECT 'SAM' as ProductPlatform, 'PROD' as Environment, * FROM (select null limit 0)
        ,{% table_date_range date_filter titanium-kiln-120918:116188121.ga_sessions_ %}
        ,{% table_date_range date_filter titanium-kiln-120918:116188121.ga_sessions_intraday_ %})
      #APLIA
      ,(SELECT 'Aplia' as ProductPlatform, 'PROD' as Environment, * FROM (select null limit 0)
        ,{% table_date_range date_filter titanium-kiln-120918:130709608.ga_sessions_ %}
        ,{% table_date_range date_filter titanium-kiln-120918:130709608.ga_sessions_intraday_ %})
    )
     ;;
     #      #CNOW V7
     #      ,(SELECT 'CNow V7' as ProductPlatform, 'PROD' as Environment, * FROM (select null limit 0)
     #        ,{% table_date_range date_filter titanium-kiln-120918:116197107.ga_sessions_ %}
     #        ,{% table_date_range date_filter titanium-kiln-120918:116197107.ga_sessions_intraday_ %})
     #      #CNOW V8
     #      ,(SELECT 'CNow V8' as ProductPlatform, 'PROD' as Environment, * FROM (select null limit 0)
     #        ,{% table_date_range date_filter titanium-kiln-120918:121361627.ga_sessions_ %}
     #        ,{% table_date_range date_filter titanium-kiln-120918:121361627.ga_sessions_intraday_ %})
     #      #CNOW MindApp
     #      ,(SELECT 'CNow MindApp' as ProductPlatform, 'PROD' as Environment, * FROM (select null limit 0)
     #        ,{% table_date_range date_filter titanium-kiln-120918:121398401.ga_sessions_ %}
     #        ,{% table_date_range date_filter titanium-kiln-120918:121398401.ga_sessions_intraday_ %})
     #      #Mindtap QAD - GTM/GA Combined
     #      ,(SELECT 'MindTap GTM+GA' as ProductPlatform, 'QAD' as Environment, * FROM (select null limit 0)
     #        ,{% table_date_range date_filter nth-station-121323:42084510.ga_sessions_ %}
     #        ,{% table_date_range date_filter nth-station-121323:42084510.ga_sessions_intraday_ %})
     #      #MT4 - Non Prod
     #      ,(SELECT 'MT4' as ProductPlatform, 'QA' as Environment, * FROM (select null limit 0)
     #        ,{% table_date_range date_filter nth-station-121323:125113011.ga_sessions_ %}
     #        ,{% table_date_range date_filter nth-station-121323:125113011.ga_sessions_intraday_ %})



    filter: date_filter {
      label: "Table Date Range"
      view_label: " Table Date Range"
      type: date
    }

    #####################
    ## DataLayer Dimensions
    #####################
    dimension: datalayer_userRole {
      label: "User Role"
      view_label: "Data Layer"
      type: string
      sql: nvl(replace(Upper(JSON_EXTRACT(${TABLE}.hits.customDimensions.value, "$.userRole")), '"', ''), '') ;;
    }

    dimension: datalayer_userSSOGuid {
      label: "User Guid"
      view_label: "Data Layer"
      type: string
      sql: nvl(REPLACE(JSON_EXTRACT(hits.customDimensions.value, "$.userSSOGuid"), '"', ''), 'UNKNOWN') ;;

      link: {
        label: "Analytics Diagnostic Tool"
        url: "https://analytics-tools.cengage.info/diagnostictool/#/user/view/production/userIdentifier/{{ value }}"
      }
    }

    dimension: datalayer_productPlatform {
      label: "Product Platform"
      view_label: "Data Layer"
      type: string
      sql: nvl(replace(Upper(JSON_EXTRACT(${TABLE}.hits.customDimensions.value, "$.productPlatform")), '"', ''), 'UNKNOWN') ;;
    }

    dimension: datalayer_environment {
      label: "Platform Environment"
      view_label: "Data Layer"
      type: string
      sql: nvl(replace(Upper(JSON_EXTRACT(${TABLE}.hits.customDimensions.value, "$.environment")), '"', ''), 'UNKNOWN') ;;
    }

    dimension_group: datalayer_localTime {
      label: "Local Time"
      view_label: "Data Layer"
      type: time
      timeframes: [
        hour,
        date,
        week,
        month,
        year,
        day_of_week,
        hour_of_day,
        month_num,
        raw,
        minute,
        minute15,
        time
      ]
      sql: nvl(replace(Upper(JSON_EXTRACT(${TABLE}.hits.customDimensions.value, "$.localTime")), '"', ''), 'UNKNOWN') ;;
    }

    dimension: datalayer_courseKey {
      label: "Course Key"
      view_label: "Data Layer"
      type: string
      sql: nvl(replace(Upper(JSON_EXTRACT(${TABLE}.hits.customDimensions.value, "$.courseKey")), '"', ''), 'UNKNOWN') ;;
    }

    dimension: datalayer_activityCGI {
      label: "Activity CGI"
      view_label: "Data Layer"
      type: string
      sql: nvl(replace(Upper(JSON_EXTRACT(${TABLE}.hits.customDimensions.value, "$.activityCGI")), '"', ''), 'UNKNOWN') ;;
    }

    #####################
    ## User Dimensions
    #####################

    dimension: full_visitor_id {
      label: "Full Visitor ID"
      view_label: "Users"
      type: string
      sql: ${TABLE}.fullVisitorId ;;
    }

    dimension: user_role {
      label: "User Role"
      view_label: "Users"
      type: string
      sql: nvl(replace(Upper(JSON_EXTRACT(${TABLE}.hits.customDimensions.value, "$.userRole")), '"', ''), '') ;;
    }

    dimension: user_sso_guid {
      label: "User Guid"
      view_label: "Users"
      type: string
      sql: nvl(REPLACE(JSON_EXTRACT(hits.customDimensions.value, "$.userSSOGuid"), '"', ''), 'UNKNOWN') ;;

      link: {
        label: "Analytics Diagnostic Tool"
        url: "https://analytics-tools.cengage.info/diagnostictool/#/user/view/production/userIdentifier/{{ value }}"
      }
    }

    measure: users {
      label: "Distinct Users"
      view_label: "Users"
      type: count_distinct
      sql: ${full_visitor_id} ;;
    }

    #####################
    ## Event Dimensions
    #####################

    dimension: event_category {
      label: "Event Category"
      view_label: "Events"
      type: string
      sql: ${TABLE}.hits.eventInfo.eventCategory ;;
    }

    dimension: event_category_1 {
      label: "Event Category 1"
      view_label: "Events"
      type: string
      sql: COALESCE(CASE WHEN INSTR(${TABLE}.hits.eventInfo.eventCategory, ' - ') > 0 THEN LEFT(${TABLE}.hits.eventInfo.eventCategory, INSTR(${TABLE}.hits.eventInfo.eventCategory, ' - ')) END, ${TABLE}.hits.eventInfo.eventCategory) ;;
    }

    dimension: event_category_2 {
      label: "Event Category 2"
      view_label: "Events"
      type: string
      sql: SUBSTR(${TABLE}.hits.eventInfo.eventCategory, INSTR(${TABLE}.hits.eventInfo.eventCategory, ' - ')) ;;
    }

    dimension: event_action {
      label: "Event Action"
      view_label: "Events"
      type: string
      sql: ${TABLE}.hits.eventInfo.eventAction ;;
    }

    dimension: event_label {
      label: "Event Label"
      view_label: "Events"
      type: string
      sql: ${TABLE}.hits.eventInfo.eventLabel ;;
    }

    dimension: event_value {
      label: "Event Value"
      view_label: "Events"
      type: string
      sql: ${TABLE}.hits.eventInfo.eventValue ;;
    }

    #####################
    ## Device Dimensions
    #####################

    dimension: browser {
      view_label: "Devices"
      type: string
      sql: ${TABLE}.device.browser ;;
    }

    dimension: browser_version {
      view_label: "Devices"
      type: string
      sql: ${TABLE}.device.browserVersion ;;
    }

    dimension: device_category {
      view_label: "Devices"
      type: string
      sql: ${TABLE}.device.deviceCategory ;;
    }

    dimension: device_is_mobile {
      view_label: "Devices"
      type: yesno
      sql: ${TABLE}.device.isMobile ;;
    }

    dimension: operating_system {
      view_label: "Devices"
      type: string
      sql: ${TABLE}.device.operatingSystem ;;
    }

    ########################
    ## Geographic Dimensions
    ########################

    dimension: continent {
      view_label: "Location"
      type: string
      sql: geoNetwork.continent ;;
    }

    dimension: country {
      view_label: "Location"
      type: string
      map_layer_name: countries
      sql: geoNetwork.country ;;
    }

    dimension: region {
      view_label: "Location"
      map_layer_name: us_states
      type: string
      sql: geoNetwork.region ;;
    }

    dimension: location {
      view_label: "Location"
      type: location
      sql_latitude: geoNetwork.latitude ;;
      sql_longitude: geoNetwork.longitude ;;
    }

    #####################
    ## Date/Time
    #####################

    dimension_group: visit_start {
      label: "Visit Start"
      view_label: "Date/Time"
      type: time
      timeframes: [
        hour,
        date,
        week,
        month,
        year,
        day_of_week,
        hour_of_day,
        month_num,
        raw
      ]
      sql: CAST(FORMAT_UTC_USEC(${TABLE}.visitStartTime* 1000000) as TIMESTAMP) ;;
    }

    dimension_group: hit_time {
      label: "Hit"
      view_label: "Date/Time"
      type: time
      timeframes: [
        hour,
        date,
        week,
        month,
        year,
        day_of_week,
        hour_of_day,
        month_num,
        raw,
        minute,
        minute15,
        time
      ]
      sql: CAST(FORMAT_UTC_USEC((${TABLE}.visitStartTime* 1000000) + ${TABLE}.hits.time*1000) as TIMESTAMP) ;;
    }

    dimension: hit_hour {
      label: "Hit Hour"
      view_label: "Date/Time"
      type: number
      sql: ${TABLE}.hits.hour ;;
    }

    #####################
    ## Session Dimensions
    #####################

    dimension: visit_id {
      view_label: "Visits"
      type: number
      sql: ${TABLE}.visitId ;;
    }

    dimension: visit_key {
      hidden: yes
      sql: CONCAT(${full_visitor_id},' - ',string(${visit_id}))
        ;;
    }

    measure: visit_time_on_site_total {
      label: "Time on Site - Total"
      view_label: "Visits"
      type: sum
      sql: ${TABLE}.totals.timeOnSite/86400.0 ;;
      value_format: "h:mm:ss"
    }

    measure: visit_time_on_site_avg {
      label: "Time on Site - Average"
      view_label: "Visits"
      type: average
      sql: ${TABLE}.totals.timeOnSite ;;
    }

    dimension: is_visit {
      view_label: "Visits"
      type: number
      sql: ${TABLE}.totals.visits ;;
    }

    dimension: is_bounce {
      view_label: "Visits"
      type: number
      sql: ${TABLE}.totals.bounces ;;
    }

    dimension: hits_in_visit {
      view_label: "Visits"
      type: number
      sql: ${TABLE}.totals.hits ;;
    }

    #####################
    ## Cengage Platform
    #####################

    dimension: product_platform {
      view_label: "Product Platform"
      label: "Platform name"
      sql: ${TABLE}.ProductPlatform ;;
    }

    #sql: JSON_EXTRACT(hits.customDimensions.value, "$.productPlatform")

    dimension: product_platform_environment {
      view_label: "Product Platform"
      label: "Platform environment"
      sql: REPLACE(JSON_EXTRACT(hits.customDimensions.value, "$.environment"), '"', '') ;;
    }

    dimension: hostname {
      view_label: "Product Platform"
      label: "Domain Name"
      sql: ${TABLE}.hits.page.hostname ;;
    }

    #####################
    ## Session Measures
    #####################

    measure: visits {
      view_label: "Visits"
      type: count_distinct
      sql: ${visit_key} ;;
    }

    #############
    ## BOUNCES
    #############
    # There are 2 ways to count bounces
    ##  1. Count the distinct visist that have totals.bounces = 1. This method requires a count distinct function, which is a statistical appproximation.
    ##  2. Sum the totals.bounces field across hits where hits.type = PAGE and totals.bounces = 1.
    ##      This will fan out the table on hits, but still ensures an accurate count of sessions, because bounced sessions
    ##      by definition contain only one pageview record.
    ##      (We have discovered that 1 in 10,000 visits with totals.pageviews = 1 and totals.bounces = 1
    ##        do contain more than 1 page view hit record, but this introduces a trivial amount of error)

    # VERSION 1
    #   - measure: bounces
    #     type: count_distinct
    #     sql: ${visit_key}
    #     filters:
    #       is_bounce: 1

    # VERSION 2
    measure: bounces {
      view_label: "Visits"
      type: number
      sql: COUNT(
            CASE
              WHEN ${TABLE}.totals.bounces = 1 AND ${TABLE}.hits.type = "PAGE"
                THEN 1
              ELSE
                NULL
            END
            )
         ;;
    }

    measure: bounce_rate {
      view_label: "Visits"
      type: number
      sql: ${bounces}/${entrances} ;;
      value_format_name: percent_2
    }

    #####################
    ## Hit dimensions
    #####################

    dimension: hit_key {
      hidden: yes
      sql: CONCAT(${visit_key}, ' - ', string(${hit_sequence_number})) ;;
    }

    dimension: hit_page {
      view_label: "Hits"
      type: string
      sql: ${TABLE}.hits.page.pagePath ;;
      fanout_on: "hits"
    }

    dimension: hit_is_entrance {
      view_label: "Hits"
      type: yesno
      sql: ${TABLE}.hits.isEntrance ;;
      fanout_on: "hits"
    }

    dimension: hit_is_exit {
      view_label: "Hits"
      type: yesno
      sql: ${TABLE}.hits.isExit ;;
      fanout_on: "hits"
    }

    dimension: hit_type {
      view_label: "Hits"
      type: string
      sql: ${TABLE}.hits.type ;;
      fanout_on: "hits"
    }

    dimension: hit_sequence_number {
      view_label: "Hits"
      type: number
      sql: ${TABLE}.hits.hitNumber ;;
      fanout_on: "hits"
    }

    dimension: hit_is_interaction {
      view_label: "Hits"
      type: yesno
      sql: ${TABLE}.hits.isInteraction ;;
      fanout_on: "hits"
    }

    dimension: hit_referer {
      view_label: "Hits"
      type: string
      sql: ${TABLE}.hits.referer ;;
      fanout_on: "hits"
    }

    #####################
    ## Hit measures
    #####################

    measure: hits {
      view_label: "Hits"
      type: count_distinct
      sql: ${hit_key} ;;
    }

    measure: pageviews {
      type: number
      view_label: "Hits"
      sql: COUNT(
          CASE
            WHEN ${hit_type} = "PAGE" THEN 1
            ELSE NULL
          END
          )
         ;;
      fanout_on: "hits"
    }

    measure: unique_pageviews {
      view_label: "Hits"
      type: count_distinct
      sql: ${visit_key} ;;

      filters: {
        field: hit_type
        value: "PAGE"
      }
    }

    measure: entrances {
      view_label: "Hits"
      sql: COUNT(
          CASE
            WHEN ${hit_type} = "PAGE" AND ${TABLE}.hits.isEntrance = 1 THEN 1
            ELSE NULL
          END
          )
         ;;
      fanout_on: "hits"
    }

    measure: exits {
      view_label: "Hits"
      sql: COUNT(
          CASE
            WHEN ${hit_type} = "PAGE" AND ${TABLE}.hits.isExit = 1 THEN 1
            ELSE NULL
          END
          )
         ;;
      fanout_on: "hits"
    }
  }
