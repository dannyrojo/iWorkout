import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.Sensor;
import Toybox.Math;
import Toybox.System;
import Toybox.WatchUi;

class iWorkoutView extends WatchUi.View {

    //OPTIONAL VARIABLES
    private var _timer1 as Timer.Timer?;  
    private var _hrString as String?;
    //CREATE COUNT VARIABLE
    private var _count1 as Number = 0;
    //CREATE TOTAL DURATION VARIABLES
    private var totalDuration as Number = 0;
    //CREATE CURRENT EXERCISE VARIABLE
    private var currentExercise as String = "Get Ready!";
    
    //CREATE INDEX: TIMERVALUES
    private var timerValues as Array<Number> = [1, 3, 5, 6];

    //CREATE INDEX: EXERCISES
    private var exerciseType as Array<String> = [
        "Running in Place",
        "Jumping Jacks",
        "Crunches",
        "Planking",
    ];
    
    

    //ONMENU STOPTIMER FUNCTION
    public function stopTimer() as Void {
        if (_timer1 != null) {
            _timer1.stop();
        }
    }    
    
    //CALLBACK FUNCTION
    public function callback1() as Void {
        //IF THE COUNTDOWN ENDS
        if (_count1 <= 0){
            
            //STOP THE TIMER
            _timer1.stop();
            
            //AND IF THE TIME PASSED IS MAX
            if (totalDuration >= 50){
                //STOP THE WORKOUT


            }else {
                //RANDOM INDEX: timerValues
                var randomFloat = Math.rand();
                var scaledNumber = 0 + randomFloat / (0x7FFFFFFF / (timerValues.size()) - 0 + 1 + 1);
                var randomIndex = Math.round(scaledNumber);

                //RANDOM INDEX: exerciseType
                var randomFloat2 = Math.rand();
                var scaledNumber2 = 0 + randomFloat2 / (0x7FFFFFFF / (exerciseType.size()) - 0 + 1 + 1);
                var randomIndex2 = Math.round(scaledNumber2);
                currentExercise = exerciseType[randomIndex2];
                
                //ADD UP THE TOTALDURATION
                totalDuration += timerValues[randomIndex];
                
                //DEBUGGING
                System.println(randomIndex);
                System.println(totalDuration);

                //SET COUNT
                _count1 = timerValues[randomIndex];

                //RESTART THE TIMER
                _timer1.start(method(:callback1), 1000, true);} 
        
        
        }else {
            //COUNTDOWN
            _count1--;

            //UPDATE VIEW
            WatchUi.requestUpdate();
        }
    }

    //SENSOR STUFF
    public function onSnsr(sensorInfo as Info) as Void {
        var heartRate = sensorInfo.heartRate;
        if (heartRate != null) {
            _hrString = heartRate.toString() + "bpm";
        } else {
            _hrString = "---bpm";
        }
        WatchUi.requestUpdate();
    }

    //INITALIZE
    function initialize() {
        
        //INITIALIZE SUPERCLASS
        View.initialize();
        
        //SET INITIAL COUNTDOWN VALUE
        //_count1 = 0;

        //DEFAULT STRING: HEARTRATE
        _hrString = "---bpm";  

        //DEFAULT STRING: EXERCISETYPE
        currentExercise = "Get Ready!";

        //ENABLE SENSORS: HEARTRATE
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE] as Array<SensorType>);
        Sensor.enableSensorEvents(method(:onSnsr));

        //CREATE TIMER
        var timer1 = new Timer.Timer();
        timer1.start(method(:callback1), 1000, true);
        _timer1 = timer1;
    }

    
    //LOAD RESOURCES
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));    
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
    }
 

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
