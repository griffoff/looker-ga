connection: "bigquery-prod"

# include all the views
include: "*.view"

# include all the dashboards
include: "*.dashboard"

explore: ga_sessions {
  always_filter: {
    filters: {
      field: date_filter
      value: "last 7 days"
    }
  }
}
