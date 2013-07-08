checklist = (items) ->
  id = 0
  skills = []
  for item in items
    skills.push {
      name: item
      id: id++
      checked: false
    }
  return skills

selectedItems = (items) ->
  selected = []
  for item in items
    if item.checked then selected.push { name: item.name, id: item.id }
  return selected

app = angular.module('mentorSignUp', ['ui.bootstrap', 'mongolab'])

app.directive 'match', ($parse) ->
  require: 'ngModel'
  link: (scope, elem, attrs, ctrl) ->
    scope.$watch -> 
      $parse(attrs.match)(scope) is ctrl.$modelValue
    , (currentValue) -> ctrl.$setValidity 'mismatch', currentValue

app.config ['$routeProvider', ($routeProvider) ->
  $routeProvider.when('/', {templateUrl: 'partials/form.html', controller: 'FormController'})
  $routeProvider.when('/thankyou', {templateUrl: 'partials/thankyou.html', controller: 'ThankyouController'})
  $routeProvider.when('/signups', {templateUrl: 'partials/signups.html', controller: 'SignupsController'})
  $routeProvider.when('/skillsInventory', {templateUrl: 'partials/skillsInventory.html', controller: 'SkillsInventoryController'})
  $routeProvider.otherwise({redirectTo: '/'})
]

app.controller 'FormController', ['$rootScope', '$scope', '$location', 'Signup', '$http',
($rootScope, $scope, $location, Signup, $http) ->
  $scope.form = 
    email: ''
    emailConfirm: ''
    firstName: ''
    lastName: ''
    company: ''
    title: ''
    zip: ''
    expertise: ''
    other: ''
    kidExperience: false
    tshirtSize: 'Medium'
    backgroundCheck: false

  $scope.mentorSkills = checklist [
    'Arduino / Raspberry Pi / Hardware hacking'
    'CSS'
    'HTML5'
    'JavaScript'
    'Node.js'
    'Scratch'
    'Python'
    'Ruby'
    'PHP'
    'Java'
    'C#'
    'Robotics'
  ]

  $scope.additionalSkill = value: ''
  $scope.additionalSkills = []

  $scope.additionalSkillAdd = ->
    return if $scope.additionalSkill.value is ''
    $scope.additionalSkills.push {name: $scope.additionalSkill.value, checked: true}
    $scope.additionalSkill.value = ''
  
  $scope.additionalSkillRemove = (index) -> $scope.additionalSkills.splice index, 1

  $scope.additionalSkillAddDisabled = -> $scope.additionalSkill.value is ''

  $scope.volunteerOffers = checklist [
    'Mentoring kids on technology'
    'Leading a 4-week exploration on a topic'
    'Donating or reimaging computers'
    'Reaching out to local schools to tell them about CoderDojo Ponce Springs'
    'Supporting events as a volunteer'    
  ]

  $scope.availability = checklist [
    'Sat June 29, 2 - 5 PM'
    'Sat July 13, 2 - 5 PM'
    'Sat July 27, 2 - 5 PM'
    'Sat August 10, 2 - 5 PM'
    'Sat August 24, 2 - 5 PM'
  ]

  $scope.tshirtSizes = [
    'Small'
    'Medium'
    'Large'
    'X-Large'
    'XX-Large'
  ]

  $scope.tshirtSizeSelect = (tshirtSize) ->
    $scope.form.tshirtSize = tshirtSize

  $scope.submit = ->
    $scope.form.mentorSkills = selectedItems $scope.mentorSkills
    $scope.form.volunteerOffers = selectedItems $scope.volunteerOffers
    $scope.form.submitDate = new Date()
    $scope.form.additionalSkills = $scope.additionalSkills

    html = document.getElementById('message').innerHTML

    Signup.save $scope.form, (signup) =>
      $rootScope.signup = signup
      signup.html = html
      $http
        url: '/submit',
        method: 'POST',
        data: signup
      $location.path('/thankyou')
]

app.controller 'ThankyouController', ['$rootScope', '$scope', ($rootScope, $scope) ->
  $scope.name = "#{$rootScope.signup.firstName}"
]  

app.controller 'SkillsInventoryController', ['$rootScope', '$scope', 'Signup', ($rootScope, $scope, Signup) ->
  '''
  signups = [ 
    name: 'Joe Koberg'
    mentorSkills: ['Python', 'C#', 'Ruby', 'CoffeeScript', 'JavaScript', 'PHP', 'Node', 'Android']
    additionalSkills: ['F#', 'Django', 'BitCoin']
  ,
    name: 'Erin Stanfil'
    mentorSkills: ['JavaScript', 'Java', 'Groovy', 'CSS', 'HTML', 'C++']
    additionalSkills: ['Grails']
  ,
    name: 'Josh Gough'
    mentorSkills: ['C#', 'Python', 'CoffeeScript', 'JavaScript', 'CSS', 'HTML',  'PhoneGap']
    additionalSkills: ['AngularJS', 'Backbone', 'Underscore']
  ]
  '''
  Signup.query (signups) ->
    $scope.skillCounts = quantifySkills signups

  quantifySkills = (signups) ->
    skillList = []
    for signup in signups
      if signup.mentorSkills? and _.isArray signup.mentorSkills
        skillList.push _.pluck(signup.mentorSkills, 'name')...
      if signup.additionalSkills? and _.isArray signup.additionalSkills
        skillList.push _.pluck(signup.additionalSkills, 'name')...

    skillCounts = _.reduce skillList.sort(), (counts, skill) ->
      unless counts[skill]? then counts[skill] = 0
      counts[skill]++
      return counts 
    , {}

    skillCounts = _.chain(skillCounts).pairs().sortBy((skillCount) -> -skillCount[1]).value()    

    for value, index in skillCounts
      mentors = findMentorsForSkill value[0], signups
      value[2] = mentors

    return skillCounts  

  findMentorsForSkill = (skill, signups) ->
    mentors = []
    for mentor in signups
      allSkills = []
      allSkills.push _.pluck(mentor.mentorSkills, 'name')...
      allSkills.push _.pluck(mentor.additionalSkills, 'name')...
      skillExists = _.find allSkills, (item) -> item == skill
      if skillExists?
        mentors.push mentor.firstName + ' ' + mentor.lastName
    return mentors
]

app.controller 'SignupsController',  ['$rootScope', '$scope', 'Signup', ($rootScope, $scope, Signup) ->
  queryAll = 
    f: JSON.stringify {
      id:1
      firstName:1
      lastName:1
      email:1
      backgroundCheckAuthorizationReceivedDate:1
      backgroundCheckPassedDate:1
      volunteerOffers:1
    }
    s: JSON.stringify {
      backgroundCheckAuthorizationReceivedDate:1
      backgroundCheckPassedDate:1
      firstName:1
    }
  
  queryMissingSomething = angular.copy queryAll
  queryMissingSomething.q = JSON.stringify $or: [ 
    { backgroundCheckAuthorizationReceivedDate: null }, { backgroundCheckPassedDate: null } 
  ]

  queryVerified = angular.copy queryAll
  queryVerified.q = JSON.stringify $and: [ 
    { backgroundCheckAuthorizationReceivedDate: {$ne: null} }, { backgroundCheckPassedDate: {$ne: null} } 
  ]

  clearSearch = -> $scope.searchTerm = ''
  
  show = (query) ->
    clearSearch()
    $scope.signups = Signup.query query

  $scope.showAll = ->
    show queryAll

  $scope.showMissingSomething = ->
    show queryMissingSomething

  $scope.showVerified = ->
    show queryVerified

  $scope.showMissingSomething()

  refreshList = (updatedItem) ->
    for item, index in $scope.signups        
      if item._id.$oid is updatedItem._id.$oid
        $scope.signups[index] = updatedItem    

  $scope.isBackgroundCheckAuthorizationReceived = (signup) -> signup.backgroundCheckAuthorizationReceivedDate?
  
  $scope.backgroundCheckAuthorizationReceived = (signup) -> 
    signup.updateSafe backgroundCheckAuthorizationReceivedDate: new Date(), refreshList
  
  $scope.backgroundCheckAuthorizationReset = (signup) ->
    signup.updateSafe backgroundCheckAuthorizationReceivedDate: null, refreshList

  $scope.isBackgroundCheckPassed = (signup) -> signup.backgroundCheckPassedDate?
  
  $scope.backgroundCheckPassed = (signup) -> signup.updateSafe backgroundCheckPassedDate: new Date(), refreshList
  
  $scope.backgroundCheckReset = (signup) -> signup.updateSafe backgroundCheckPassedDate: null, refreshList

  $scope.searchByName = (name) ->
    return if name is ''
    queryByName = angular.copy queryAll
    queryByName.q = JSON.stringify $or: [ 
      {firstName: { $regex: name, $options: 'i' }}, 
      {lastName: { $regex: name, $options: 'i' }} 
    ]
    $scope.signups = Signup.query queryByName
]