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
  $scope.vinErrors 				= []
  $scope.currentPage 			= 1

  $scope.loadVehicles = ->
  	Vehicle.query({page: $scope.currentPage}, (data) ->
  		console.log(data)
  		$scope.vehicles 		= data.vehicles
  		$scope.totalPages		= data.total_pages
  		$scope.offset				= data.offset
  		$scope.perPage			= data.per_page
  		$scope.totalEntries	= data.total_entries
	  )
  $scope.searchByVin = ->
    $scope.vinErrors 			= []
    vehicle 							= Vehicle.save($scope.newVehicle, (->
    	$scope.lastVehicle	= vehicle
    	$scope.newVehicle 	= {}
    	$scope.vehicles.push(vehicle)
    	console.log(vehicle)), 
    (data) ->
    	$scope.vinErrors 		= data.data.full_error_messages
   	)

  $scope.setLastVehicle = ->
  	$scope.lastVehicle 		= $scope.vehicles.last

  $scope.expandVehicle = (vehicle) ->
  	$scope.lastVehicle 		= Vehicle.get({id: vehicle.id})

  $scope.deleteVehicle = (vehicle) ->
  	console.log(vehicle)
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

  $scope.loadVehicles()
]