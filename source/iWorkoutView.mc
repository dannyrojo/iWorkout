import Toybox.Graphics;
import Toybox.Lang;
import Toybox.Timer;
import Toybox.Sensor;
import Toybox.WatchUi;

class iWorkoutView extends WatchUi.View {

    //LOAD TIMER GLOBALS FOR THIS VIEW
    private var _timer1 as Timer.Timer?;
    private var _count1 as Number = (60 *5);

    //HR MONITOR GLOBALS
    private var _hrString as String;

    // GLOBAL FUNCTIONS
    
    // CALLBACK
    public function callback1() as Void {
        _count1--;
        WatchUi.requestUpdate();
    }

    // STOP THE TIMER
    public function stopTimer() as Void {
        if (_timer1 != null) {
            _timer1.stop();
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
        View.initialize();

        //ENABLE SENSORS
        Sensor.setEnabledSensors([Sensor.SENSOR_HEARTRATE] as Array<SensorType>);
        Sensor.enableSensorEvents(method(:onSnsr));

        //STARTUP STRING FOR HEARTRATE
        _hrString = "---bpm";    
    }

    
    // LOAD RESOURCES
    function onLayout(dc as Dc) as Void {
        setLayout(Rez.Layouts.MainLayout(dc));
    
        //CREATE TIMER
        var timer1 = new Timer.Timer();
        timer1.start(method(:callback1), 1000, true);
        _timer1 = timer1;
    
    }

    // Called when this View is brought to the foreground. Restore
    // the state of this View and prepare it to be shown. This includes
    // loading resources into memory.
    function onShow() as Void {
    }

    // VIEW UPDATE
    function onUpdate(dc as Dc) as Void {
        // REDRAW THE LAYOUT
        View.onUpdate(dc);

        // DRAW THE BACKGROUND
        dc.setColor(Graphics.COLOR_BLACK, Graphics.COLOR_BLACK);
        dc.clear();

        // DRAW THE TIMER
        var timerValue = _count1;
        var seconds = timerValue % 60;
        var minutes = timerValue / 60;
        var timerString = minutes + ":" + seconds.format("%02d");
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        var string = timerString;
        dc.drawText((dc.getWidth()/2), (dc.getHeight()/2), Graphics.FONT_MEDIUM, string, Graphics.TEXT_JUSTIFY_CENTER);
        
        //DRAW THE SENSOR
        dc.setColor(Graphics.COLOR_WHITE, Graphics.COLOR_TRANSPARENT);
        dc.drawText(dc.getWidth()/2, 90, Graphics.FONT_LARGE, _hrString, Graphics.TEXT_JUSTIFY_CENTER);
    }
 

    // Called when this View is removed from the screen. Save the
    // state of this View here. This includes freeing resources from
    // memory.
    function onHide() as Void {
    }

}
