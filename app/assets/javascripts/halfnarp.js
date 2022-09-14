(function() {
    function show_status(status) {
        var container = $('.status');
        var span = container.find(status ? '.success' : '.failed');

        container.find('span').hide();
        span.show();
        container.addClass('shown');

        setTimeout(function() {
          container.removeClass('shown');
        }, 3000);
    }

    function toggle_grid(whichDay) {
        var vclasses= ['in-list', 'in-calendar onlyday1', 'in-calendar onlyday2', 'in-calendar onlyday3',
                       'in-calendar onlyday4', 'in-calendar alldays'];
        $('body').removeClass('alldays onlyday1 onlyday2 onlyday3 onlyday4 in-list in-calendar');
        if( whichDay < 0 || whichDay > 5 ) return;
        $('body').addClass(vclasses[whichDay]);
        $('#qrcode').toggleClass('limit', whichDay == 0 );
    }

    function do_the_halfnarp() {
        var halfnarpAPI     = '/talk_preferences';
        var halfnarpPubAPI  = halfnarpAPI + '/';
        var isTouch = (('ontouchstart' in window) || (navigator.msMaxTouchPoints > 0));
        window.all_events = new Object();
        var myuid, mypid, newfriend = new Object();
        var allhours        = ['11','12','13','14','15','16','17','18','19','20','21','22','23','00','01'];

        /* Add poor man's type ahead filtering */
        $.extend($.expr[':'], {
            'containsi': function(elem, i, match, array)
            {
                return (elem.textContent || elem.innerText || '').toLowerCase()
                    .indexOf((match[3] || '').toLowerCase()) >= 0;
            }
        });

        /* Add callback for submit click */
        $('.submit').click( function() {
            var myapi;

            /* Get user's preferences and try to save them locally */
            var ids = $('.selected').map( function() {
                return parseInt($(this).attr('event_id'));
            }).get();
            try {
                localStorage['OpenFest-gauge'] = ids;
                myapi = localStorage['OpenFest-gauge-api'];
            } catch(err) {
                alert('Storing your choices locally is forbidden.');
            }

            /* Convert preferences to JSON and post them to backend */
            var request = {talk_preference: {'selected_talks_attributes': ids.map(function(talk_id) {
                return {"talk_id": talk_id};
            })}};
            if( !myapi || !myapi.length ) {
                /* If we do not have resource URL, post data and get resource */
                $.post( halfnarpAPI, request, function( data ) {
                    try {
                        localStorage['OpenFest-gauge-api'] = data['update_url'];
                        localStorage['OpenFest-gauge-pid'] = mypid = data['hashed_uid'];
                        localStorage['OpenFest-gauge-uid'] = myuid = data['uid'];
                        window.location.hash = mypid;
                    } catch(err) {}
                }, 'json' ).fail(function() {
                    show_status(false);
                });
            } else {
                /* If we do have a resource URL, update resource */
                $.ajax({
                    type: 'PUT',
                    url: myapi,
                    data: request,
                    dataType: 'json',
                }).done(function(data) {
                    localStorage['OpenFest-gauge-uid'] = myuid = data['uid'];
                    if( localStorage['OpenFest-gauge-pid'] ) {
                        window.location.hash = localStorage['OpenFest-gauge-pid'];
                    }
                    show_status(true);
                }).fail(function() {
                  show_status(false);
                });
            }

            /* Tell QRCode library to update and/or display preferences for Apps */
            // $('#qrcode').empty();
            // $('#qrcode').qrcode({width: 224, height: 224, text: request});
            // $('#qrcode').removeClass('hidden');

            /* Export all preferences in ical events */
            // var now = new Date();
            // var calendar = 'BEGIN:VCALENDAR\r\nVERSION:2.0\r\nPRODID:-//events.ccc.de//halfnarp//EN\r\nX-WR-TIMEZONE:Europe/Berlin\r\n';
            // ids.forEach( function(id) {
            //     var item = all_events[id];
            //     var start = new Date(item.start_time);
            //     calendar += 'BEGIN:VEVENT\r\n';
            //     calendar += 'UID:'+myuid+item.event_id+'\r\n';
            //     calendar += 'DTSTAMP:' + now.toISOString().replace(/-|;|:|\./g, '').replace(/...Z$/, 'Z') + '\r\n';
            //     calendar += 'DTSTART:' + start.toISOString().replace(/-|;|:|\./g, '').replace(/...Z$/, 'Z') + '\r\n';
            //     calendar += 'DURATION:PT' + item.duration + 'M\r\n';
            //     calendar += 'LOCATION:' + item.room_name + '\r\n';
            //     calendar += 'URL:http://events.ccc.de/congress/2014/Fahrplan/events/' + item.event_id + '.html\r\n';
            //     calendar += 'DESCRIPTION:' + item.title + '\r\n';
            //     calendar += 'SUMMARY:' + item.abstract.replace(/\n/g, '') + '\r\n';
            //     console.log( 'id:' + id + ' ' + all_events[id] );
            //     console.log( all_events[id].title );
            //     calendar += 'END:VEVENT\r\n';
            // });
            // calendar += 'END:VCALENDAR\r\n';
            // $('.export-url-a').attr( 'href', "data:text/calendar;filename=OpenFest.ics," + encodeURIComponent(calendar) );
            // $('.export-url').removeClass( 'hidden' );
        });

        /* Add handler for type ahead search input field */
        $('#filter').bind('paste cut keypress keydown keyup', function() {
            var cnt = $(this).val();
            if( cnt.length ) {
                $('.event').css('display', 'none');
                $('.event:containsi('+cnt+')').css('display', 'block');
            } else {
                $('.event').css('display', 'block');
            }
        });

        /* Add click handlers for event div sizers */
        $('.vsmallboxes').click( function() {
            $('#qrcode').css( 'margin-bottom', '0' );
            $('body').removeClass('size-medium size-large');
            $('body').addClass('size-small');
        });

        $('.vmediumboxes').click( function() {
            $('#qrcode').css( 'margin-bottom', '62px' );
            $('body').removeClass('size-small size-large');
            $('body').addClass('size-medium');
        });

        $('.vlargeboxes').click( function() {
            $('#qrcode').css( 'margin-bottom', '124px' );
            $('body').removeClass('size-small size-medium');
            $('body').addClass('size-large');
        });

        /* Add de-highlighter on touch interface devices */
        if( isTouch ) {
            $('body').click( function() {
                $('.highlighted').removeClass('highlighted');
            });
        }

        /* Add callbacks for view selector */
        $('.vlist').click( function() { toggle_grid(0);  });
        $('.vday1').click( function() { toggle_grid(1); });
        $('.vday2').click( function() { toggle_grid(2); });
        $('.vday3').click( function() { toggle_grid(3); });
        $('.vday4').click( function() { toggle_grid(4); });
        $('.vdays').click( function() { toggle_grid(5); });

        $('.vlang').click( function() { $('body').toggleClass('languages'); });

        /* Create hour guides */
        $(allhours).each(function(i,hour) {
            var elem = document.createElement('hr');
            $(elem).addClass('guide time_' + hour + '00');
            $('body').append(elem);
            elem = document.createElement('div');
            $(elem).text(hour + '00');
            $(elem).addClass('guide time_' + hour + '00');
            $('body').append(elem);
        });

        /* If we've been here before, try to get local preferences. They are authoratative */
        var selection = [], friends = { 'foo': undefined };
        try {
            selection = localStorage['OpenFest-gauge'] || [];
            friends   = localStorage['OpenFest-gauge-friends'] || { 'foo': undefined };
            myuid     = localStorage['OpenFest-gauge-uid'] || '';
            mypid     = localStorage['OpenFest-gauge-pid'] || '';
        } catch(err) {
        }

        /* Fetch list of lectures to display */
        $.getJSON( halfnarpAPI, { locale: $('html').attr('lang') })
            .done(function( data ) {
                $.each( data, function( i, item ) {
                    /* Save event to all_events hash */
                    all_events[item.event_id] = item;

                    /* Take copy of hidden event template div and select them, if they're in
                       list of previous prereferences */
                    var t = $( '#template' ).clone(true);
                    var event_id = item.event_id.toString();
                    t.addClass('event');
                    t.attr('event_id', item.event_id.toString());
                    t.attr('id', 'event_' + item.event_id.toString());
                    if( selection && selection.indexOf(item.event_id) != -1 ) {
                        t.addClass( 'selected' );
                    }

                    /* Sort textual info into event div */
                    t.find('.title').text(item.title);
                    t.find('.event_type').text(item.event_type);
                    t.find('.abstract').text(item.abstract);

                    /* start_time: 2014-12-29T21:15:00+01:00" */
                    var start_time = new Date(item.start_time);

                    var day  = start_time.getDate()-26;
                    var hour = start_time.getHours();
                    var mins = start_time.getMinutes();

                    /* After midnight: sort into yesterday */
                    if( hour < 10 ) {
                        day--;
                    }

                    t.addClass('small');

                    /* Apply attributes to sort events into calendar */
                    // t.addClass(' room_' + item.room_id + ' duration_' + item.duration + ' day_'+day + ' time_' + (hour<10?'0':'') + hour + '' + (mins<10?'0':'') + mins);
                    if( isTouch ) {
                        t.click( function(event) {
                            if ( $( this ).hasClass('highlighted') ) {
                                $( this ).toggleClass('selected');
                                $('.info').addClass('hidden');
                                $('.submit').click();
                            } else {
                                $('.highlighted').removeClass('highlighted');
                                $( this ).addClass('highlighted');
                            }
                            event.stopPropagation();
                        });

                        $(t).bind('taphold', function(event) {
                            $( this ).toggleClass('selected');
                            $('.info').addClass('hidden');
                            $('.submit').click();
                        });
                    } else {
                        t.click( function(event) {
                            $( this ).toggleClass('selected');
                            $('.info').addClass('hidden');
                            $('.submit').click();
                            event.stopPropagation();
                        });
                    }

                    /* Put new event into DOM tree. Track defaults to 'Other' */
                    var track = item.track_id.toString();
                    var d = $( '#' + track );
                    t.addClass('track_' + track );
                    if( !d.length ) {
                        d = $( '#Other' );
                    }
                    d.append(t);
                    if( newfriend.pid ) {
                        newfriend.prefs.forEach( function( eventid ) {
                            $( '#event_' + eventid ).addClass( 'friend' );
                        });
                    }
                });

                /* Check for a new friends public uid in location's #hash */
                var shared = window.location.hash;
                shared = shared ? shared.substr(1) : '';
                if( shared.length ) {
                    if ( ( friends[shared] ) || ( shared === mypid ) ) {

                    } else {
                        $.getJSON( halfnarpPubAPI + shared, { locale: $('html').attr('lang') })
                            .done(function( data ) {
                                newfriend.pid      = shared;
                                newfriend.prefs    = data.talk_ids;
                                newfriend.prefs.forEach( function( eventid ) {
                                    $( '#event_' + eventid ).addClass( 'friend' );
                                });
                            });
                    }
                }
            });
        $(document).keypress(function(e) {
            if( $(document.activeElement).is('input') || $(document.activeElement).is('textarea') )
                return;
            switch( e.keyCode ) {
            case 48: case 94: /* 0 */
                toggle_grid(5);
                break;
            case 49: case 50: case 51: case 52: /* 1-4 */
                toggle_grid(e.keyCode-48);
                break;
            case 76: case 108: /* l */
                toggle_grid(0);
                break;
            case 68: case 100: /* d */
                toggle_grid(5);
                break;
            }
        });
    }

    $(document).ready(function() {do_the_halfnarp()});
}).call(this);
