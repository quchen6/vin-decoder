app = angular.module("Fleetio", ["ngResource"])

app.factory "Vehicle", ["$resource", ($resource) ->
  $resource("/vehicles/:id", {id: "@id"}, {update: {method: "PUT"}})
]

@VehicleCtrl = ["$scope", "Vehicle", ($scope, Vehicle) ->
  $scope.vehicles 				= Vehicle.query( ->
    # $scope.expandVehicle($scope.vehicles.last)
    # console.log($scope.vehicles.last)
  )
  $scope.vinErrors 				= []

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
]