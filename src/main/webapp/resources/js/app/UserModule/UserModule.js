'use strict';

angular.module("FlowertyApplication.UserModule", ['ngRoute'])

.config(["$routeProvider", function($routeProvider) {
	$routeProvider
	.when("/users", {
        templateUrl: USER_MODULE_PATH + "user-list.html",
        controller: "UsersListController"
    })
	.when("/useredit", {
		templateUrl: USER_MODULE_PATH + "/user-edit.html",
		controller: "UserActionProcessController"
	})
	.when("/user-remove", {
		templateUrl: USER_MODULE_PATH + "/user-list.html",
		controller: "UserActionProcessController"
	});
}])

.controller("UserActionProcessController", ["$scope", "$http", function($scope, $http) {
	$scope.remove = function(id) {
		$http
			.get("user/remove/" + id)
			.success(function(data, status, headers, config) {
				alert("Remove Ok!");
			})
			.error(function(data, status, headers, config) {
				alert("Remove Error!");
			});
	}
     
    $scope.edit = function(id) {
    	$http
			.get("user/details/" + id)
			.success(function(data, status, headers, config) {
				$scope.userrr = data;
				alert("Edit Ok!" + JSON.stringify({data: data}));
			})
			.error(function(data, status, headers, config) {
				alert("Edit Error!");
			});
    }
    
    $scope.saveContact = function() {
    	alert("Save user ok!");
    }
}])

.controller('UsersListController', function($scope, $http) {

    $scope.users = {
        pages : [],
        pagesCount : 3,
        currentPage : 1,
        usersList : []
    };

    $scope.users.pageClass = function(pageNumber){
        return pageNumber == $scope.users.currentPage ? 'active' : '';
    };

    $scope.users.setPagination = function(){
        $scope.users.pages = [];
        for(var i = 1; i <= $scope.users.pagesCount; i++){
            var obj = {
                value : i
            };
            $scope.users.pages.push(obj);
        }
    };

    $scope.users.getPage = function(pageNumber){
        $scope.users.currentPage = pageNumber;
        $scope.users.getPageFromServer();
        $scope.users.setPagination();
    };

    $scope.users.getPageFromServer = function(){
        var request = $http({
            method: "get",
            url: "user/list/" + $scope.users.currentPage
        });

        request.success(function(data, status, headers, config) {
//            alert( "Response: " + JSON.stringify({data: data}));
            $scope.users.usersList = data;
            $scope.users.pagesCount = 3;
        });

        request.error(function(data, status, headers, config) {
//            alert( "Exception details: " + JSON.stringify({data: data}));
        });
    };

    $scope.users.getPreviousPage = function(){
        if($scope.users.currentPage !== 1){
            $scope.users.currentPage--;
        }
        $scope.users.getPage($scope.users.currentPage);
    };

    $scope.users.getNextPage = function(){
        if($scope.users.currentPage !== $scope.users.pagesCount){
            $scope.users.currentPage++;
        }
        $scope.users.getPage($scope.users.currentPage);
    };

    $scope.users.getPage(1);

})

.controller("SayHelloController", function() {//for test
	alert("I say hello!");
})