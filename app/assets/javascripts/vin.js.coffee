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
  		$scope.total_pages	= data.total_pages
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
  	vehicle.$delete( -> 
  		$scope.loadVehicles()
  	)

  $scope.setPage = (page) ->
  	$scope.currentPage = page
  	$scope.loadVehicles()

  $scope.nextPage = ->
  	$scope.currentPage += 1
  	$scope.loadVehicles()

  $scope.previousPage = ->
  	$scope.currentPage -= 1
  	$scope.loadVehicles()

  $scope.loadVehicles()
]