'use strict';

// declare modules
angular.module('Authentication', []);
angular.module('SignUp', []);
angular.module('Home', []);
angular.module('Admin', []);

angular.module('BasicHttpAuthExample', [
    'Authentication',
	'SignUp',
    'Home',
	'Admin',
    'ngRoute',
    'ngCookies'
])

.config(['$routeProvider', function ($routeProvider) {

    $routeProvider
        .when('/login', {
            controller: 'LoginController',
            templateUrl: '/login.html',
            hideMenus: true
        })

		.when('/signup', {
            controller: 'SignUpController',
            templateUrl: '/signup.html',
            hideMenus: true
        })

		.when('/home', {
            controller: 'HomeController',
            templateUrl: '/home.html'
        })

		.when('/admin', {
            controller: 'AdminController',
            templateUrl: '/admin.html'
        })

        .when('/', {
            controller: 'LoginController',
            templateUrl: '/login.html'
        })

        .otherwise({ redirectTo: '/login' });
}])

.run(['$rootScope', '$location', '$cookieStore', '$http',
    function ($rootScope, $location, $cookieStore, $http) {
        $rootScope.$on('$locationChangeStart', function (event, next, current) {

            if (localStorage.getItem("token")!=null) {
				if(localStorage.getItem("admin")) {
					$location.path('/admin');
				}
				else {
					$location.path('/home');
				}
            } else if ($location.path() === '/login' || $location.path() === '/signup') {

			} else{
				$location.path('/login');
				console.log("No login data found. Redirecting to login page.");
			}
        });
    }]);