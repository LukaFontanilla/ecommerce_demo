- dashboard: vizext
  title: Viz Extension Demo
  layout: newspaper
  preferred_viewer: dashboards-next
  description: ''
  elements:
  - title: Viz Extension
    name: Viz Extension
    model: thelook
    explore: products
    type: 'tile-extension::app'
    fields: [products.count, products.total_retail_price]
    sorts: [products.count desc]
    limit: 500
    query_timezone: America/Los_Angeles
    row: 0
    col: 8
    width: 25
    height: 16
