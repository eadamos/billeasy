'use strict';
 
angular.module('Admin')
 
.controller('AdminController',
    ['$scope', '$location', 'AdminService',
    function ($scope, $location, Admin) {
		//TODO: authenticate first; if fail, log out
		$scope.name=localStorage.getItem("name");
	
		$scope.logout = function() {
			localStorage.clear();
			$location.path('/#/login');
		}		
    }]);