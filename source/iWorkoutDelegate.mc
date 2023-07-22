import Toybox.Lang;
import Toybox.WatchUi;

class iWorkoutDelegate extends WatchUi.BehaviorDelegate {

    function initialize() {
        BehaviorDelegate.initialize();
    }

    function onMenu() as Boolean {
        WatchUi.pushView(new Rez.Menus.MainMenu(), new iWorkoutMenuDelegate(), WatchUi.SLIDE_UP);
        return true;
    }

}