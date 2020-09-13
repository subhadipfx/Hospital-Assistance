# Hospital Assistance

## Motivation: 

One of the major problems people often face is finding the right hospital at the right time. This often leads to delay in treatment and in some cases even death. It is also difficult to find an ambulance in emergency situations. This problem has highly elevated in India due to the COVID19 Pandemic. 

## Solution:

We built an app which would show the type and number of beds available for a particular hospital. The updates would be shown real-time and would be maintained by hospital authorities so the app is not centralized. The hospital authorities can modify the bed availability from a software loaded in their machines; They can also modify the category of beds along with the other details. The users can also book ambulance services through the app. When the user tries to book an ambulance service, a request would be sent to the driver end app of the nearby drivers and the driver would then have the option to reject or accept the request.

## Assumptions:

•	Use a location near Kolkata for better results when running the app. The reason being that the app is currently using dummy data from hospitals and the hospitals are based in and around Kolkata, West Bengal, India. The app shows the list of hospitals within a range of 200km. So, users trying to access somewhere far away from Kolkata won’t be able to see the Hospital Lists

•	For the Ambulance part to work perfectly please register a driver and keep the driver app open and then book the ambulance services from the user end. Once the user sends the request to book an ambulance, a pop-up message would be sent to nearby drivers where they can either accept or decline the request.

•	The Hospital End was first done in Laravel, and later the backend was shifted to NodeJS for better performance. However, due to lack of time, we could not complete the front end in REST APIs. One can view the Hospital End from the Laravel part.

•	The screen which should appear after booking the Ambulance is still not complete.


## Future Scope and Modifications:

•	This app can be used worldwide and even after the pandemic. The app will be very useful in countries like India where this problem persisted even before the pandemic.

•	The Ambulance Booking part can be and would be modified for better results.

•	We can incorporate images of hospitals and hospital beds along with the hospital lists which would appear in a new screen.

•	There would be a search bar where the user can search for a particular bed category and the results would be shown accordingly.

•	A pharmacy part might also be included where the user can search and book medicines which would be delivered to their doorsteps.


## Important Links:

•	Hospital Management Panel: https://hospital-helper-demp-1.herokuapp.com/

•	Backend API: https://covid-19-hospital-node.herokuapp.com/

•	Super Admin: admin@super.com

Password: 123456789

•	Admin: admin@admin.com

Password: 123456789

•	Hospital Admin: test@hospital.com

Password: 123456789

•	App User: srijannag123@gmail.com

Password: 123456789

•	YouTube: https://youtu.be/zXeHWyaa2rw


## App Screenshots:
<div class="row">
  <div class="column">
    <img src="https://github.com/subhadipfx/Hospital-Assistance/blob/master/AppScreenshots/login.jpg" alt="Login Page" style="width:100">
  </div>
  <div class="column">
    <img src="https://github.com/subhadipfx/Hospital-Assistance/blob/master/AppScreenshots/login.jpg" alt="Forest" style="width:100">
  </div>
  <div class="column">
    <img src="https://github.com/subhadipfx/Hospital-Assistance/blob/master/AppScreenshots/login.jpg" alt="Mountains" style="width:100">
  </div>
</div>
