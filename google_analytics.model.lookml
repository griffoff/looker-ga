- connection: bigquery-prod

- include: "*.view.lookml"       # include all the views
- include: "*.dashboard.lookml"  # include all the dashboards

- explore: ga_sessions
  always_filter:
    date_filter: last 3 days
    

