'use strict';

angular.module('Home')

.controller('HomeController',
    ['$scope', '$location', 'HomeService',
    function ($scope, $location, HomeService) {
		$scope.name=localStorage.getItem("name");
		$scope.bills=[];
		$scope.bill_ids_to_be_paid=[];

		//renew token every 5 seconds
		(function renew_token()
		{
			if($location.path()=='/home')
			{
				HomeService.renew_token(function(response) {
					if(response.success) {
						if($location.path()=='/home')
						{
							localStorage.setItem("token", response.token);
							console.log("Token renewed.");

							setTimeout(function()
							{
								renew_token();
							}, 5000);
						}
					} else {
						localStorage.clear();
						$location.path('/#/login');
						console.log("Authentication failed. Redirecting to login page.")
					}
				});
			}

		})();

		//refresh bills every 5 seconds
		(function refresh_bills()
		{
			if($location.path()=='/home')
			{
				HomeService.fetch_bills(function(response) {
					if(response.success && $location.path()=='/home')
					{
						//remember which bills where checked
						var checked=[];
						for(var i=0;i<$scope.bills.length;i++)
						{
							if($scope.bills[i].to_be_paid) {
								checked.push($scope.bills[i].bill_id);
							}
						}

						$scope.bills=response.bills;

						//check them again after updating
						for(var i=0;i<checked.length;i++)
						{
							for(var j=0;j<$scope.bills.length;j++)
							{
								if(checked[i]==$scope.bills[j].bill_id) {
									$scope.bills[j].to_be_paid = true;
								}
							}
						}

						console.log("Bills updated.");

						setTimeout(function()
						{
							refresh_bills();
						}, 5000);
					}
				});
			}

		})();

		//add up total amount of bills checked (to be paid)
		$scope.total = function() {
			if($scope.bills!=null) {
				var t=0;

				for(var i=0;i<$scope.bills.length;i++)
				{
					if($scope.bills[i].to_be_paid) {
						t+=parseFloat($scope.bills[i].amount);
					}
				}

				//2 decimal places
				return t.toFixed(2);
			}
		}

		$scope.pay = function() {
			if($scope.total()==0)
			{
				alert("Please check the bills you want to pay.");
			}
			else
			{
				for(var i=0;i<$scope.bills.length;i++)
				{
					if($scope.bills[i].to_be_paid) {
						$scope.bill_ids_to_be_paid.push($scope.bills[i].bill_id);
					}
				}

				alert("To pay bills " + $scope.bill_ids_to_be_paid);
				$scope.bill_ids_to_be_paid=[];
			}
		}

		$scope.logout = function() {
			$location.path('/#/login');
			localStorage.clear();
			console.log("User logged out.");
		}
    }]);