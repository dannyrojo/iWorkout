import Toybox.Lang;
import Toybox.WatchUi;

class iWorkoutDelegate extends WatchUi.BehaviorDelegate {
    // LOCAL VARIABLE FOR VIEW
    private var _view as iWorkoutView;

    function initialize(view as iWorkoutView) {
        BehaviorDelegate.initialize();
        
        //ALIAS FOR VIEW
        _view = view;
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new iWorkoutMenuDelegate(), WatchUi.SLIDE_UP);
        
        //STOP TIMER
        _view.stopTimer();
        return true;
    }

    

}