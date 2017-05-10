//= require jquery
//= require angular
//= require angular-websocket
//= require angular-actioncable
//= require slick-carousel
//= require angular-slick
//= require angular-tag-cloud
//= require ng-sortable
//= require materialize
//= require nouislider
//= require angular-nouislider
//= require angular-devise
//= require js-routes
//= require_self
//= require_tree ./controllers

var app = angular.module("app", ['ngActionCable', 'as.sortable', 'slick', 'nouislider', 'ngTagCloud', 'Devise'])
    .config(function (AuthProvider) {
        AuthProvider.loginPath('/accounts/sign_in.json');
        AuthProvider.resourceName('account')
    });

function parse_url(relative_url) {
    var params = {};
    var splittedUrlsArray = relative_url.split('/');
    for(var i = 1; i < splittedUrlsArray.length; i+= 2) {
        params[splittedUrlsArray[i]] = splittedUrlsArray[i+1];
    }
    return params;
}

function getParameterByName(name, url) {
    if (!url) url = window.location.href;
    name = name.replace(/[\[\]]/g, "\\$&");
    var regex = new RegExp("[?&]" + name + "(=([^&#]*)|&|#|$)"),
        results = regex.exec(url);
    if (!results) return null;
    if (!results[2]) return '';
    return decodeURIComponent(results[2].replace(/\+/g, " "));
}