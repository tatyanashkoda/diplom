const CalendarSingleton = (function () {
    let calendarInstance;

    function createCalendar() {
        //Initialize Full Calender
        //and render inside 'calendar' div
        const calendar = $('#calendar').fullCalendar({
            minTime: "07:00:00",
            maxTime: "21:00:00",
            firstDay: 1,
            businessHours: {
                dow: [ 1, 2, 3, 4, 5 ],
                start: '10:00',
                end: '19:00',
            },
            //Toolbar header
            header: {
                left: 'prev,next today',
                center: 'title',
                right: 'agendaDay,agendaWeek,month'
            },
            //Changing text for different buttons
            buttonText: {
                today: 'Today',
                month: 'Month',
                week: 'Week Agenda',
                day: 'Day Agenda',
                list: 'List',
                prevYear: 'Previous Year',
                nextYear: 'Next Year',
                prev: 'Previous',
                next: 'Next'
            },
            //Toolbar footer with previous year and next year controls
            footer: {
                right: 'prevYear, nextYear'
            },

            themeSystem: 'jquery-ui',
            aspectRatio: 2,
            selectable: true,


            //dayClick handler
            select: function (start, end) {
                //alert('a day has been clicked!');
                handleSelect(start, end);
                $("#dialog").dialog();
            },

            //Handle event click
            eventClick: function (calendarEvent, browserEvent, view) {
                handleEventClick(calendarEvent, browserEvent, view);
            },

            //Hanadle drag-drop of event
            eventDrop: function (event, delta, revertFunc) {
                //alert(event.title + " was dropped on " + event.start.format());
                if (!confirm("Are you sure about this change?")) {
                    revertFunc();
                } else {
                    handleEventDrop(event);
                }
            }
        });

        return calendar;
    }

    return {
        getCalendar: function () {
            if (!calendarInstance) {
                calendarInstance = createCalendar();
            }
            return calendarInstance;
        },
    }
})();

const getFreeTime = function (eventsData) {
    const freeTime = [];
    eventsData.forEach(function (event) {
        const newFreeTime = {};
        newFreeTime.start = new Date(event.Start_Time__c).toISOString();
        newFreeTime.end = new Date(event.End_Time__c).toISOString();
        newFreeTime.overlap = false;
        newFreeTime.rendering = 'background';
        newFreeTime.color = '#99ffcc';
        freeTime.push(newFreeTime);
    });

    $('#calendar').fullCalendar('addEventSource', freeTime);
}

const addEvents = function (eventsData) {

    const events = [ ];

    eventsData.forEach(function (event) {
        const newEvent = {};
        newEvent.Id = event.Id;
        newEvent.title = event.Title;
        newEvent.start = new Date(event.StartDateTime).toISOString();
        newEvent.end = new Date(event.EndDateTime).toISOString();
        newEvent.editable = false;
        events.push(newEvent);
    });
    if (events.length > 0) {
        $('#calendar').fullCalendar('removeEventSources');
        $('#calendar').fullCalendar('addEventSource', events);
    }
}



/**
 * This function will be called when the user
 * select a duration from the calendar
 * */
const handleSelect = function (start, end) {
    $('#createContactLastName').val("");
    $('#createStartTime').val(start);
    $('#createEndTime').val(end);
}

/**
 * Prepare an event object to pass to server side remote call
 * */
const prepareEvent = function (title, startTime, endTime, subject, firstName, lastName, email, Id) {
    const calendarEvent = {};
    calendarEvent.Id = Id;
    calendarEvent.Name = title;
    calendarEvent.Start_Time__c = new Date(startTime).getTime();
    calendarEvent.End_Time__c = new Date(endTime).getTime();
    calendarEvent.Subject__c = subject;
    calendarEvent.Contact_First_Name__c = firstName;
    calendarEvent.Contact_Last_Name__c = lastName;
    calendarEvent.Contact_Email__c = email;
    createOrUpdateEvents(JSON.stringify(calendarEvent));
}

/**
 * This method will be called when event is drag and dropped
 * */
const handleEventDrop = function (event) {
    const calendarEvent = {};
    calendarEvent.Id = event.Id;
    calendarEvent.Name = event.title;
    calendarEvent.Start_Time__c = new Date(event.start).getTime();
    calendarEvent.End_Time__c = new Date(event.end).getTime();
    createOrUpdateEvents(JSON.stringify(calendarEvent));
}

/**
 * This code will be executed on page load
 * and will attach necessary listeners
 * */
const attachListners = function () {

    /**
     * Adding submit event listener on newEventForm
     * */
    $('#newEventForm').submit(function (event) {
        const title = $('#createContactLastName').val();
        const startTime = $('#createStartTime').val();
        const endTime = $('#createEndTime').val();
        const subject = $('#createEventSubject').val();
        const firstName =  $('#createContactFirstName').val();
        const lastName =  $('#createContactLastName').val();
        const email =  $('#createContactEmail').val();
        if (new Date(startTime).getTime() > new Date(endTime).getTime()) {
            $("#createStartTime").after('<span style="color:red"><br>Start time must be before End time</span>');
        }
        else{

            prepareEvent(title, startTime, endTime,subject, firstName, lastName, email );
            $("#dialog").dialog("close");

        }
        event.preventDefault();
    });

    /**
     * Adding submit event listener on updateEventForm
     * */
    $('#updateEventForm').submit(function (event) {
        const title = $('#getContactName').val();
        const startTime = $('#updateStartTime').val();
        const endTime = $('#updateEndTime').val();
        const Id = $('#recordId').val();
        if (new Date(startTime).getTime() > new Date(endTime).getTime()) {
            $("#updateStartTime").after('<span style="color:red"><br>Start time must be before End time</span>');
        }
        prepareEvent(title, startTime, endTime, Id);
        event.preventDefault();
    });
}