- view: ga_sessions
  sql_table_name: |
      (SELECT * FROM {% table_date_range date_filter titanium-kiln-120918:115907067.ga_sessions_ %})
      
  fields:
  
  - filter: date_filter
    label: "Table Date Range"
    view_label: " Table Date Range"
    type: date


#####################
## User Dimensions
#####################

  - dimension: full_visitor_id
    label: "Full Visitor ID"  
    view_label: "Users"
    type: string
    sql: ${TABLE}.fullVisitorId
  
      
  - measure: users
    label: "Distinct Users"
    view_label: "Users"
    type: count_distinct
    sql: ${full_visitor_id}  

#####################
## Device Dimensions
#####################

  - dimension: browser
    view_label: "Devices"
    type: string
    sql: ${TABLE}.device.browser

  - dimension: browser_version
    view_label: "Devices"
    type: string
    sql: ${TABLE}.device.browserVersion

  - dimension: device_category
    view_label: "Devices"
    type: string
    sql: ${TABLE}.device.deviceCategory
    
  - dimension: device_is_mobile
    view_label: "Devices"
    type: yesno
    sql: ${TABLE}.device.isMobile

  - dimension: operating_system
    view_label: "Devices"
    type: string
    sql: ${TABLE}.device.operatingSystem



#####################
## Session Dimensions
#####################

  - dimension: visit_id
    view_label: "Visits"
    type: number
    sql: ${TABLE}.visitId
    
  - dimension: visit_key
    hidden: true
    sql: |
      CONCAT(${full_visitor_id},' - ',string(${visit_id}))

  - dimension: visit_time_on_site
    view_label: "Visits"
    type: number
    sql: ${TABLE}.totals.timeOnSite

  - dimension: visit_start
    label: "Start"
    view_label: "Visits"
    type: time
    timeframes: [hour, date, week, month, year, day_of_week, hour_of_day, month_number, raw]
    sql: FORMAT_UTC_USEC(${TABLE}.visitStartTime* 1000000)


  - dimension: is_visit
    view_label: "Visits"
    type: number
    sql: ${TABLE}.totals.visits
    
  - dimension: is_bounce
    view_label: "Visits"
    type: number
    sql: ${TABLE}.totals.bounces

  - dimension: hits_in_visit
    view_label: "Visits"
    type: number
    sql: ${TABLE}.totals.hits
    
#####################
## Session Measures
#####################
    
  - measure: visits
    view_label: "Visits"
    type: count_distinct
    sql: ${visit_key}
    

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
  - measure: bounces
    view_label: "Visits"
    type: number
    sql: |
      COUNT(
          CASE
            WHEN ${TABLE}.totals.bounces = 1 AND ${TABLE}.hits.type = "PAGE"
              THEN 1
            ELSE
              NULL
          END
          )


  - measure: bounce_rate
    view_label: "Visits"
    type: number
    sql: ${bounces}/${entrances}
    value_format_name: percent_2


#####################
## Hit dimensions
#####################

  - dimension: hit_key
    hidden: true
    sql: CONCAT(${visit_key}, ' - ', string(${hit_sequence_number}))

  - dimension: hit_page
    view_label: "Hits"
    type: string
    sql: ${TABLE}.hits.page.pagePath
    fanout_on: hits

  - dimension: hit_is_entrance
    view_label: "Hits"
    type: yesno
    sql: ${TABLE}.hits.isEntrance
    fanout_on: hits

  - dimension: hit_is_exit
    view_label: "Hits"
    type: yesno
    sql: ${TABLE}.hits.isExit
    fanout_on: hits

  - dimension: hit_type
    view_label: "Hits"
    type: string
    sql: ${TABLE}.hits.type
    fanout_on: hits 

  - dimension: hit_sequence_number
    view_label: "Hits"
    type: number
    sql: ${TABLE}.hits.hitNumber
    fanout_on: hits

  - dimension: hit_is_interaction
    view_label: "Hits"
    type: yesno
    sql: ${TABLE}.hits.isInteraction
    fanout_on: hits

  - dimension: hit_referer
    view_label: "Hits"
    type: string
    sql: ${TABLE}.hits.referer
    fanout_on: hits

#####################
## Hit measures
#####################

  - measure: hits
    view_label: "Hits"
    type: count_distinct
    sql: ${hit_key}

  - measure: pageviews
    view_label: "Hits"
    sql: |
      COUNT(
        CASE
          WHEN ${hit_type} = "PAGE" THEN 1
          ELSE NULL
        END
        )
    fanout_on: hits 

  - measure: unique_pageviews
    view_label: "Hits"
    type: count_distinct
    sql: ${visit_key}
    filters:
      hit_type: PAGE

  - measure: entrances
    view_label: "Hits"
    sql: |
      COUNT(
        CASE
          WHEN ${hit_type} = "PAGE" AND ${TABLE}.hits.isEntrance = 1 THEN 1
          ELSE NULL
        END
        )
    fanout_on: hits 

  - measure: exits
    view_label: "Hits"
    sql: |
      COUNT(
        CASE
          WHEN ${hit_type} = "PAGE" AND ${TABLE}.hits.isExit = 1 THEN 1
          ELSE NULL
        END
        )
    fanout_on: hits 