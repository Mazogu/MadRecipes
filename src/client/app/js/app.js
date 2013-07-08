// Generated by CoffeeScript 1.6.2
(function() {
  var app;

  app = angular.module('madRecipes', ['ui.bootstrap', 'mongolab']);

  app.config([
    '$routeProvider', function($routeProvider) {
      $routeProvider.when('/', {
        templateUrl: 'partials/recipe.html',
        controller: 'RecipeController'
      });
      $routeProvider.when('/thankyou', {
        templateUrl: 'partials/thankyou.html',
        controller: 'ThankyouController'
      });
      return $routeProvider.otherwise({
        redirectTo: '/'
      });
    }
  ]);


  app.controller('RecipeController', [
    '$rootScope', '$scope', '$location', 'Recipe', function($rootScope, $scope, $location, Recipe) {
      $scope.form = {
        recipeName: '',
        description: '',
        directions: '',
      };
      $scope.ingredient = {
        value: ''
      };
      $scope.ingredients = [];
      $scope.ingredientAdd = function() {
        if ($scope.ingredient.value === '') {
          return;
        }
        $scope.ingredients.push({
          name: $scope.ingredient.value,
          checked: true
        });
        return $scope.ingredient.value = '';
      };
      $scope.ingredientRemove = function(index) {
        return $scope.ingredients.splice(index, 1);
      };
      $scope.ingredientAddDisabled = function() {
        return $scope.ingredient.value === '';
      };

      return $scope.submit = function() {

        $scope.form.submitDate = new Date();
        $scope.form.ingredients = $scope.ingredients;
        Recipe.save($scope.form, function(recipe) {
          $rootScope.recipe = recipe;
          $location.path('/thankyou');
        });
      };
    }
  ]);

  app.controller('ThankyouController', [
    '$rootScope', '$scope', function($rootScope, $scope) {
      $scope.recipeName = $rootScope.recipe.recipeName;
    }
  ]);

}).call(this);