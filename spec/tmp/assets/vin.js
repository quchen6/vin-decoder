(function() {
  var app;

  app = angular.module("Fleetio", ["ngResource"]);

  app.factory("Vehicle", [
    "$resource", function($resource) {
      return $resource("/vehicles/:id", {
        id: "@id"
      }, {
        update: {
          method: "PUT"
        },
        'query': {
          method: 'GET',
          isArray: false
        }
      });
    }
  ]);

  app.filter("range", function() {
    return function(input, total) {
      var i;
      total = parseInt(total);
      i = 0;
      while (i < total) {
        input.push(i);
        i++;
      }
      return input;
    };
  });

  this.VehicleCtrl = [
    "$scope", "Vehicle", function($scope, Vehicle) {
      $scope.vinErrors = [];
      $scope.vehicles = [];
      $scope.newVehicle = {};
      $scope.currentPage = 1;
      $scope.totalPages = 0;
      $scope.loadVehicles = function() {
        return Vehicle.query({
          page: $scope.currentPage
        }, (function(data) {
          $scope.vehicles = data.vehicles;
          $scope.totalPages = data.total_pages;
          $scope.offset = data.offset;
          $scope.perPage = data.per_page;
          return $scope.totalEntries = data.total_entries;
        }), function(data) {
          return $scope.totalPages = data;
        });
      };
      $scope.searchByVin = function() {
        var vehicle;
        return vehicle = Vehicle.save($scope.newVehicle, (function() {
          $scope.lastVehicle = vehicle;
          $scope.newVehicle = {};
          return $scope.vehicles.push(vehicle);
        }), function(data) {
          return $scope.vinErrors = data.data.full_error_messages;
        });
      };
      $scope.setLastVehicle = function() {
        return $scope.lastVehicle = $scope.vehicles.last;
      };
      $scope.expandVehicle = function(vehicle) {
        return $scope.lastVehicle = Vehicle.get({
          id: vehicle.id
        });
      };
      $scope.deleteVehicle = function(vehicle) {
        return Vehicle["delete"]({
          id: vehicle.id
        }, function() {
          return $scope.loadVehicles();
        });
      };
      $scope.setPage = function(page) {
        $scope.currentPage = page;
        return $scope.loadVehicles();
      };
      $scope.nextPage = function() {
        if ($scope.currentPage < $scope.totalPages) {
          $scope.currentPage += 1;
          return $scope.loadVehicles();
        }
      };
      $scope.previousPage = function() {
        if ($scope.currentPage > 1) {
          $scope.currentPage -= 1;
          return $scope.loadVehicles();
        }
      };
      $scope.pageInfo = function() {
        return "Showing entries " + ($scope.offset + 1) + " - " + (Math.min($scope.offset + $scope.perPage, $scope.totalEntries)) + " of " + $scope.totalEntries + " total";
      };
      return $scope.loadVehicles();
    }
  ];

}).call(this);
