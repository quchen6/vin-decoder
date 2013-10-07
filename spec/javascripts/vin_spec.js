var $httpBackend;

describe('Vehicle Controller', function() {
  var $httpBackend, $rootScope, createController, singleVehicle;

  // Load fleetio angular module
  beforeEach(module('Fleetio'));
 
  beforeEach(inject(function($injector) {
    $httpBackend          = $injector.get('$httpBackend');
    $rootScope            = $injector.get('$rootScope');
    var $controller       = $injector.get('$controller');
    createController      = function() {
      return $controller('VehicleCtrl', {$scope: $rootScope});
    };
    singleVehicle         = function() {
      return {id: 1, model: "Nissan", make: "Altima"}
    }

    // Catch all vehicle load queries (index) as it gets called frequently
    $httpBackend.whenGET(/\/vehicles\?page*/).respond({ total_pages: 1, total_entries: 1, offset: 0, per_page: 10,
        vehicles: [singleVehicle()] });

  }));

  describe("query", function(){
    beforeEach(function(){
      $httpBackend.expectGET("/vehicles?page=1")
      ctrl = createController();
      $httpBackend.flush();
    });

    it("loads the vehicles", function(){
      expect($rootScope.vehicles.length).toBe(1);
    });

    it("sets the paging variables", function(){
      expect($rootScope.totalPages)     .toBe(1);
      expect($rootScope.totalEntries)   .toBe(1);
      expect($rootScope.offset)         .toBe(0);
      expect($rootScope.perPage)        .toBe(10);
    });

  });

  describe("searchByVin", function(){
    // Test user enters valid vin
    describe("valid", function(){
      beforeEach(function(){
        createController();
        $httpBackend.flush();

        spyOn($rootScope, 'setLoading')
        spyOn($rootScope, 'setReady')

        $httpBackend.expectPOST("/vehicles").respond(singleVehicle());
        $rootScope.newVehicle = {vin: "123456"}
        $rootScope.searchByVin();
        $httpBackend.flush();
      });

      it("resets new vehicle", function(){
        expect($rootScope.newVehicle.vin).toEqual('');
      });

      it("adds the new vehicle to the list", function(){
        // Should be two because createController 'returns' 1
        expect($rootScope.vehicles.length).toEqual(2);
      });

      it("sets the form status to loading", function(){
        expect($rootScope.setLoading).toHaveBeenCalled()
      });

      it("resets the form status to ready after a successful request", function(){
        expect($rootScope.setReady).toHaveBeenCalled()
      });
    });

    // Test invalid vin
    describe("invalid", function(){
      beforeEach(function(){
        createController();
        $httpBackend.flush();

        spyOn($rootScope, 'setFailed')

        $httpBackend.expectPOST("/vehicles").respond(422, {full_error_messages: ["there was an error"] } );
        $rootScope.newVehicle = {vin: "123456"}
        $rootScope.searchByVin();
        $httpBackend.flush();
      });

      it("sets the error messages", function(){
        expect($rootScope.vinErrors)    .toEqual(["there was an error"]);
      });

      it("sets the form status to failed after a failed request", function(){
        expect($rootScope.setFailed).toHaveBeenCalled()
      });

    });

  });

  describe("expandVehicle", function(){
    beforeEach(function(){
      createController();
      $httpBackend.flush();

      $httpBackend.expectGET(/\/vehicles\/\d+/).respond(singleVehicle());
      $rootScope.expandVehicle(singleVehicle());
      $httpBackend.flush();
    });

    it("sets the vehicle", function(){
      expect($rootScope.lastVehicle.id) .toEqual(singleVehicle().id);
    });

  });

  describe("deleteVehicle", function(){
    it("deletes the vehicle and reloads the list", function(){
      createController();
      $httpBackend.flush();

      $httpBackend.expectDELETE(/\/vehicles\/\d+/).respond(204);
      $httpBackend.expectGET("/vehicles?page=1")
      $rootScope.deleteVehicle(singleVehicle());
      $httpBackend.flush();
    });

  });

  describe("Pagination", function(){

    beforeEach(function(){
      createController();
      $rootScope.totalPages       = 20;
      $rootScope.offset           = 10;
      $rootScope.totalEntries     = 15;
      $rootScope.perPage          = 10;
    });

    it("allows you to go back a page", function(){
      $rootScope.currentPage      = 10;
      $rootScope.previousPage();
      expect($rootScope.currentPage).toEqual(9);
    });

    it("does not allow you to go before the first page", function(){
      $rootScope.currentPage      = 1;
      $rootScope.previousPage();
      expect($rootScope.currentPage).toEqual(1);
    });

    it("allows you to go forward a page", function(){
      $rootScope.currentPage      = 10;
      $rootScope.nextPage();
      expect($rootScope.currentPage).toEqual(11);
    });

    it("does not allow you to go before the first page", function(){
      $rootScope.currentPage      = 20;
      $rootScope.nextPage();
      expect($rootScope.currentPage).toEqual(20);
    });

    it("renders the correct paging info", function(){
      expect($rootScope.pageInfo()).toEqual("Showing entries 11 - 15 of 15 total");
    });
  });

});
