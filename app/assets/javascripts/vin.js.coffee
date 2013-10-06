app = angular.module("Fleetio", ["ngResource"])

app.factory "Vehicle", ["$resource", ($resource) ->
  $resource("/vehicles/:id", {id: "@id"}, {update: {method: "PUT"}, 'query': {method: 'GET', isArray: false}} )
]

app.filter "range", ->
  (input, total) ->
    total = parseInt(total)
    i = 0

    while i < total
      input.push i
      i++
    input

@VehicleCtrl = ["$scope", "Vehicle", ($scope, Vehicle) ->
  $scope.vinErrors        = []
  $scope.vehicles         = []
  $scope.newVehicle       = {}
  $scope.currentPage      = 1
  $scope.totalPages       = 0

  # Load vehicles and get paging info
  $scope.loadVehicles = ->
    Vehicle.query({page: $scope.currentPage}, ( (data) ->
      $scope.vehicles     = data.vehicles
      $scope.totalPages   = data.total_pages
      $scope.offset       = data.offset
      $scope.perPage      = data.per_page
      $scope.totalEntries = data.total_entries
    ),
    (data) ->
      $scope.totalPages   = data
    )

  # Search for a vehicle by using the VIN
  $scope.searchByVin = ->
    vehicle               = Vehicle.save($scope.newVehicle, (->
      $scope.lastVehicle  = vehicle
      $scope.newVehicle.vin   = ""
      $scope.vehicles.push(vehicle)
    ), 
    (data) ->
      $scope.vinErrors    = data.data.full_error_messages
    )

  $scope.setLastVehicle = ->
    $scope.lastVehicle    = $scope.vehicles.last

  # Get a vehicle by id
  $scope.expandVehicle = (vehicle) ->
    $scope.lastVehicle    = Vehicle.get({id: vehicle.id})

  $scope.deleteVehicle = (vehicle) ->
    Vehicle.delete( {id: vehicle.id}, -> 
      $scope.loadVehicles()
    )

  $scope.setPage = (page) ->
    $scope.currentPage = page
    $scope.loadVehicles()

  $scope.nextPage = ->
    if $scope.currentPage < $scope.totalPages
      $scope.currentPage += 1
      $scope.loadVehicles()

  $scope.previousPage = ->
    if $scope.currentPage > 1
      $scope.currentPage -= 1
      $scope.loadVehicles()

  $scope.pageInfo = ->
    return "Showing entries " + ($scope.offset + 1) + " - " + 
      (Math.min($scope.offset + $scope.perPage, $scope.totalEntries)) + 
      " of " + ($scope.totalEntries) + " total"

  # Get the current location of the user to get accurate TCO
  $scope.getLocation = ->
    if (navigator.geolocation)
      navigator.geolocation.getCurrentPosition($scope.showPosition);

  # Callback for getLocation. Sets the zip on the page
  $scope.showPosition = (position) ->
    point                   = new google.maps.LatLng(position.coords.latitude, position.coords.longitude);  
    new google.maps.Geocoder().geocode({'latLng': point}, (res, status) ->
      $scope.newVehicle.zip = res[0].formatted_address.match(/,\s\w{2}\s(\d{5})/)[1]
    )

  $scope.loadVehicles()
  $scope.getLocation()
]
