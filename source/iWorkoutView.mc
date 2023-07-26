import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.Sensor;
import Toybox.Attention;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;
import Toybox.UserProfile;

class iWorkoutView extends WatchUi.View {

    //VARIABLE DECLARATIONS
    private var _timer1 as Timer.Timer;  
    private var _hrString as String;
    private var _count1 as Number = 0;
    private var totalDuration as Number = 0;
    private var currentExercise as String = "Get Ready!";
    private var vibeData;
    private var zoneData as Array<Number>;
    private var currentZone as Number = 0;
    private var previousZone as Number = 0;
    private var heartRate as Number = 0;
    private var _bitmap as BitmapResource?;
    private var _bitmapTimer as Timer.Timer?;

   
    //CREATE INDEX: TIMERVALUES IN SECONDS
    private var timerValues as Array<Number> = [30, 60, 90, 120];

    //CREATE INDEX: EXERCISES
    private var exerciseType as Array<String> = [
        "Run in Place",
        "Jumping Jacks",
        "Shadow Box",
        "Burpee",
        "Crunches",
        "Glute Bridge",
        "Plank",
        "Push Ups",
        "Mountain Climbers",
        "Squats",
    ];
    
    //CREATE INDEX: BITMAPS
    private const IMAGES = [$.Rez.Drawables.id_Running,
                            $.Rez.Drawables.id_Jumping,
                            $.Rez.Drawables.id_Boxing,
                            $.Rez.Drawables.id_Burpee,
                            $.Rez.Drawables.id_Crunches,
                            $.Rez.Drawables.id_Glutebridge,
                            $.Rez.Drawables.id_Plank,
                            $.Rez.Drawables.id_Pushups,
                            $.Rez.Drawables.id_Mountainclimbers,
                            $.Rez.Drawables.id_Squats,
                            ] as Array<Symbol>;

    //TIMER CALLBACK
    public function callback1() as Void {
        //IF THE COUNTDOWN ENDS
        if (_count1 <= 0){
            
            //STOP THE TIMER
            _timer1.stop();
            
            //AND IF THE DURATION IS MAXED STOP THE WORKOUT
            if (totalDuration >= 1800){
                //NOTHING
                }
            
            //OTHERWISE START A NEW ITERATION
            else {
                //CREATE A RANDOM INDEX FOR TIMER VALUES
                var randomFloat = Math.rand();
                var scaledNumber = 0 + randomFloat / (0x7FFFFFFF / (timerValues.size()) - 0 + 1 + 1);
                var randomIndex = Math.round(scaledNumber);
                System.println("i1 = " + randomIndex);
                //SET THE TIMER VALUE FOR THIS ITERATION
                _count1 = timerValues[randomIndex];
                
                // AND ADD IT UP TO THE TOTAL
                totalDuration += timerValues[randomIndex];

                //THEN CREATE A RANDOM INDEX FOR EXERCISE TYPES
                var randomFloat2 = Math.rand();
                var scaledNumber2 = 0 + randomFloat2 / (0x7FFFFFFF / (exerciseType.size()) - 0 + 1 + 1);
                var randomIndex2 = Math.round(scaledNumber2);
                System.println("i2 = " + randomIndex2);
                //AND SET THE CURRENT EXERCISE FOR THIS ITERATION
                currentExercise = exerciseType[randomIndex2];

                //ASSIGN AND DRAW THE BITMAP
                _bitmap = WatchUi.loadResource(IMAGES[randomIndex2]) as BitmapResource;
                _bitmapTimer.start(method(:hideBitmap), 5000, false); 

                //START THE TIMER THE TIMER UP AGAIN
                _timer1.start(method(:callback1), 1000, true);} 
                
                //DEBUGGING
                System.println(currentExercise);
                //System.println(totalDuration);
                
        //AND IF THE COUNTDOWN IS STILL GOING
        }else {
            //COUNTDOWN
            _count1--;
            
            //AND UPDATE
            WatchUi.requestUpdate();
        }
    }

    //HEARTRATE CALLBACK
    public function onSnsr(sensorInfo as Info) as Void {
        //GRAB THE HEARTRATE
        heartRate = sensorInfo.heartRate;
        
        //AND IF THE HEARTRATE ISN'T NULL
        if (heartRate != null) {
            
            //CONVERT AND ASSIGN THE STRING
            _hrString = heartRate.toString() + "bpm";

            //AND DETERMINE THE HEARTRATE ZONE
            getZone();
            System.println(currentZone); //DEBUGGING
        }
        //OTHERWISE PRINT THE DEFAULT
        else {
            _hrString = "---bpm";
        }

        //THEN UPDATE
        WatchUi.requestUpdate();
    }

    //DETERMINE THE HRZONE
    public function getZone(){

        //IF THE HEARTRATE ISN'T NULL AND ZONEDATA ISN'T NULL
        if (heartRate != null && zoneData != null){

        //THEN ITERATE THROUGH THE ZONEDATA TO FIND THE CURRENT ZONE    
            for (var i = 0; i < zoneData.size()-1; i++){
                if (heartRate > zoneData[i] && heartRate <= zoneData[i+1]){
                    currentZone = i+ 1;
                    break;
                }
            }
            //UNLESS THE HEART RATE IS OUT OF ZONE (MAY NEED TO UPDATE WITH LOW END)
            if (heartRate > zoneData[zoneData.size()-1] ){
                currentZone = zoneData.size();
            }
        }
        //VIBRATE ON HR CHANGE
        checkZoneChange();
        //AND FINALLY UPDATE
        WatchUi.requestUpdate();
    }

    //VIBRATE ON ZONE CHANGE
    public function checkZoneChange() as Void {
        if (currentZone != previousZone) {
	        vibeData = [];
	        for (var i = 0; i < currentZone; i++){
		        vibeData.add(new Attention.VibeProfile(75,100));
	        }
	    Attention.vibrate(vibeData);
	    previousZone = currentZone;
        }
    }

    //BITMAP HIDE FUNCTION
    public function hideBitmap() as Void {
        _bitmap = null;
        WatchUi.requestUpdate();
    }
    
    //INITALIZE
    function initialize() {
        
        //SET UP DEFAULT DEFINITIONS (MAY BE REDUNDANT)
        //_count1 = 0;
        _hrString = "---bpm";  
        currentExercise = "Get Ready!";

        //INITIALIZE VIEW
        View.initialize();
       
        //GET HEARTRATE ZONES
        zoneData = UserProfile.getHeartRateZones(UserProfile.HR_ZONE_SPORT_GENERIC);
        System.println(zoneData); //DEBUGGING
        
        //ENABLE SENSORS EVENTS
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE] as Array<SensorType>);
        Sensor.enableSensorEvents(method(:onSnsr));

        //START THE TIMER(S)
        var timer1 = new Timer.Timer();
        timer1.start(method(:callback1), 1000, true);
        _timer1 = timer1;

        _bitmapTimer = new Timer.Timer();

    }

    
    //LOAD RESOURCES
    function onLayout(dc as Dc) as Void {
           
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    //VIEW UPDATE
    function onUpdate(dc as Dc) as Void {
        
        //DRAW
        View.onUpdate(dc);

        //DRAW THE BACKGROUND
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        //DRAW THE TIMER STRING
        var timerValue = _count1;
        var seconds = timerValue % 60;
        var minutes = timerValue / 60;
        var timerString = minutes + ":" + seconds.format("%02d");
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var string = timerString;
        dc.drawText((dc.getWidth()/2), (dc.getHeight()/2), Graphics.FONT_MEDIUM, string, Graphics.TEXT_JUSTIFY_CENTER);
        
        //DRAW THE SENSOR STRING
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, 90, Graphics.FONT_LARGE, _hrString, Graphics.TEXT_JUSTIFY_CENTER);

        //DRAW THE CURRENT EXERCISE STRING
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, 60, Graphics.FONT_LARGE, currentExercise, Graphics.TEXT_JUSTIFY_CENTER);

        //ASSIGN BITMAP VARIABLE
        //_bitmap = WatchUi.loadResource(IMAGES[0]) as BitmapResource;

        //DRAW THE BITMAP
        if (_bitmap != null){
        //DEFINE BITMAP POSITION    
        var bx = (dc.getWidth()/2) - (_bitmap.getWidth()/2);
        var by = (dc.getHeight()/2) - (_bitmap.getHeight()/2);
        //AND DRAW    
        dc.drawBitmap(bx, by, _bitmap);}

        

    }
 

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
