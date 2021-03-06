GOOGLE_MAPS_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='

Template.hello.events
    'click button.switch-mode': ->
      m = (Session.get 'mymode') or 0
      m = !m
      Session.set 'mymode', m

    'click button.take-a-pic': ->
      MeteorCamera.getPicture {}, (e,r)->
        if e?
          alert (e.message)
        else
          l = Session.get 'myloc'
          a = Session.get 'myaddr'
          z = Session.get 'myzip'
          myColl.insert {time:new Date(), pic:r, loc:l, address:a, zip:z}
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
  pos:->
    l = Geolocation.latLng()
    if l
      Session.set 'myloc', l
      url = GOOGLE_MAPS_API_URL + l.lat + ',' + l.lng
      $.getJSON url, (res)->
        if res.status is 'OK'
          a = res.results[0].formatted_address
          z = res.results[1].address_components[0].long_name
          Session.set 'myaddr', a
          Session.set 'myzip', z
        else
           console.log res
    Session.get 'myloc'

  addr:->
    Session.get 'myaddr'

  zip:->
    Session.get 'myzip'

  mode:->
    m = Session.get 'mymode'
    if m
      return "local"
    else
      return "global"

  pictures:->
    m = Session.get 'mymode'
    if m # Global mode
      return myColl.find({}, {sort:{time:-1}})
    else # Local mode
      z = (Session.get 'myzip') or ''
      return myColl.find({zip: z}, {sort:{time:-1}}) if z

