app = angular.module("Fleetio", ["ngResource"])

app.factory "Vehicle", ["$resource", ($resource) ->
  $resource("/vehicles/:id", {id: "@id"}, {update: {method: "PUT"}})
]

@VehicleCtrl = ["$scope", "Vehicle", ($scope, Vehicle) ->
  $scope.vehicles 				= Vehicle.query( ->
    $scope.setLastVehicle()
  )

  $scope.searchByVin = ->
    vehicle 							= Vehicle.save($scope.newVehicle, ->
    	$scope.lastVehicle	= vehicle
    	$scope.newVehicle 	= {}
    	$scope.vehicles.push(vehicle)
   	)

  $scope.setLastVehicle = ->
  	$scope.lastVehicle 		= $scope.vehicles.last
]