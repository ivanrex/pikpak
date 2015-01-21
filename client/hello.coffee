GOOGLE_MAPS_API_URL = 'https://maps.googleapis.com/maps/api/geocode/json?latlng='
GOOGLE_MAPS_API_KEY = '&key=AIzaSyCs7eId7TLd46-tJH-9NeT4KMZHf2qOKzI'

Template.hello.events
    'click button': ->
      MeteorCamera.getPicture {}, (e,r)->
        if e?
          alert (e.message)
        else
          l = Geolocation.latLng()
          if l
            url = GOOGLE_MAPS_API_URL + l.lat + ',' + l.lng + GOOGLE_MAPS_API_KEY
            $.getJSON url, (res)->
              a = res.results[0].formatted_address
              myColl.insert {time:new Date(), pic:r, loc:l, addr:a}
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
  pos:->
    p = Geolocation.latLng()
    if p
      url = GOOGLE_MAPS_API_URL + p.lat + ',' + p.lng + GOOGLE_MAPS_API_KEY
      $.getJSON url, (res)->
        console.log res.results[0].formatted_address
        text = '<p>Current address: ' + res.results[0].formatted_address + '</p>'
        $('#address').html text
    p
