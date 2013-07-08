// This is a module for cloud persistance in mongolab - https://mongolab.com
angular.module('mongolab', ['ngResource']).
factory('Recipe', function ($resource) {
    var Resource = $resource('https://api.mongolab.com/api/1/databases/madrecipes/collections/recipes/:id', {
        apiKey: 'ouUCxeHZy3EVBJlriEoIvUEPDK6XR9le'
    }, {
        update: {
            method: 'PUT'
        }
    });

    Resource.prototype.update = function (cb) {
        return Resource.update({
                id: this._id.$oid
            },
            angular.extend({}, this, {
                _id: undefined
            }), cb);
    };

    Resource.prototype.updateSafe = function (patch, cb) {
        Resource.get({id:this._id.$oid}, function(resource) {
            for(var prop in patch) {
                recipe[prop] = patch[prop];
            }
            Recipe.update(cb);
        });
    };

    Resource.prototype.destroy = function (cb) {
        return Resource.remove({
            id: this._id.$oid
        }, cb);
    };

    return Resource;
});