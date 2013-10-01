app = angular.module("Fleetio", ["ngResource"])

app.factory "Vehicle", ["$resource", ($resource) ->
  $resource("/vehicles/:id", {id: "@id"}, {update: {method: "PUT"}})
]

@RaffleCtrl = ["$scope", "Vehicle", ($scope, Vehicle) ->
  $scope.vehicles = Vehicle.query()
  
  $scope.addVehicle = ->
    vehicle = Vehicle.save($scope.newVehicle)
    $scope.entries.push(vehicle)
    $scope.newVehicle = {}
]