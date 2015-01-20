

Template.hello.events
    'click button': ->
      MeteorCamera.getPicture {}, (e,r)->
        if e?
          alert (e.message)
        else
          l = Geolocation.latLng()
          myColl.insert {time:new Date(), pic:r, loc:l}
          uploadCount = (Session.get 'mycount') or 0
          uploadCount += 1
          Session.set 'mycount', uploadCount

    'click img.small-image':(e,t)->
      uploadCount = (Session.get 'mycount') or 0
      if uploadCount > 0
        id = e.target.getAttribute 'data-id'
        myColl.remove id
        Session.set 'mycount', uploadCount - 1
      else
        alert "You cannot delete more pictures than you uploaded (#{uploadCount} pictures)"

Template.hello.helpers
  pictures:->
    myColl.find({}, {sort:{time:-1}})
  position:->
    Geolocation.latLng()

