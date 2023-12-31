"Do the wiggle, man" - Source Unkown

Title: 

    iWorkout

Description:  

    Once a gift to a friend, A Garmin smartwatch that had for a time, been my baby, made it back home to me. This is my attempt to create some specific functionalities that I presume to be unavailable to the stock OS on the watch.   This is my third exercise in coding and the program that I will attempt to create will do the following:

    Create a 30 minute work out plan that will randomize and cycle through a set of exercises.  For example in one 30 minute session the user might be doing jumping jacks for 5 minutes, followed by crunchers for another 5, followed by a 3 minute plank, etc...  Or possibly in the reverse order!

    Possibly included will be 
        1. A starting menu for choosing set types like stationary, or field exercies
        2. A loading animation for each exercise
        3. A countdown timer and heart rate display

Installation:

    Garmin requires the use of the Connect IQ SDK: 
    https://developer.garmin.com/connect-iq/overview/

    and is coded in the MonkeyC using the cIQ APIs.
    https://developer.garmin.com/connect-iq/api-docs/index.html

    The set up process was a little difficult in Linux, so I moved to Windows.  The SDK manager is a little buggy, so if you need any help getting started, feel free to get in touch.

Usage: N/A

License: N/A

Credits: N/A

Contact Information: dannyred365@gmail.com

Update Log:

7/21/23:  Set up was exhuasting!  This is the basic default template for constructing a program for the Vivoactive 3.

7/23/23:  Added a timer and a heart rate sensor.  Achievements unlocked:  MonkeyC API and the ConnectIQ simulator are getting easier to work with.  Learned how to use the manifest. Learned about Callback functions.  Learned abbout formatting strings of numbers using "%02d" Next Steps:  Pay attention to creating re-usable code.  Figure out how to make multiple views and thread them together.  Figure out a menu system.  Create a randomization process for exercises.    

7/23/23:  Added multiple timers to cycle through.  When the timer hits 0, it moves to the next timer.  Achievements unlocked:  Plugging memory leaks by stopping the timers.  Getting more familiar with WatchUi.  Next steps:  Create indices so that multiple files are not needed and can swap through different conditions.  
PARTii: Now it randomly cycles through exercises with a random duration for each.  Achievements:  Learned how to incoporate rand() into MonkeyC, including a scrappy limiter for the numbers (thanks FlowState: https://forums.garmin.com/developer/connect-iq/f/discussion/3673/creating-a-random-number#pifragment-1298=2).  Up Next:  Layout changes (graphics, animations, splash screens, etc).  Vibrate Indicator for Heart Rate Zones.  And later, testing menu coordination and input behavior.

7/24/23:  Added a zone detector and a vibration function.  Achievements:  Incorporating for loops for sleeker code.  Next Steps:  Look at cleaning up the code further and making it more compact and modular.  Animations, graphics, and menus!

7/26/23:  Added graphics.   After hours of coding animations, discovered that my device is incompatiable with an animation layer despite the reference documentation! Yay!  However, Achievements Unlocked:  Introduced to global and project level variables in SDK.  GIMP and FFMPEG as asset tools.  Other resource management.  Next steps:  Add settings and clean up code!