'use strict';

angular.module('Authentication')

.factory('AuthenticationService',
    ['$http', '$cookieStore', '$rootScope', '$timeout',
    function ($http, $cookieStore, $rootScope, $timeout) {
        var service = {};

        service.Login = function (user_name, password, callback) {
			//$http.post('/cgi-bin/razza/billeasy/api/login.py', { user_name: user_name, password: password }, {headers : {'Content-Type': 'x-www-form-urlencoded'}})
			$http.post('http://joshuabalagapo.pythonanywhere.com/api/login', { user_name: user_name, password: password }, {headers : {'Content-Type': 'x-www-form-urlencoded'}})
			.success(function (response) {
                if(!response.success) {
					response.message = 'User name or password is incorrect';
				}
                callback(response);
			});
        };

        return service;
    }])

