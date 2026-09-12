using E9XSim.mainApp;
using E9XSim.protocols.CAN.E9X.INFO_CON;
using System.Windows;
using System.Windows.Input;

namespace E9XSim.modules.INFO_CON
{
    public partial class ConWindow : Window
    {
        private readonly ConModule _module;
        private readonly SimulationEngine _simulation;

        public ConWindow(
            ConModule module,
            SimulationEngine simulation)
        {
            InitializeComponent();

            _module = module;
            _simulation = simulation;
        }

        private void Button_MouseDown(
            object sender,
            MouseButtonEventArgs e)
        {
            if (sender is not FrameworkElement element)
                return;

            if (element.Tag is not string name)
                return;

            if (TryGetButton(name, out ConButton conButton))
            {
                _module.PressButton(conButton);
                e.Handled = true;
            }
        }

        private void Button_MouseUp(
            object sender,
            MouseButtonEventArgs e)
        {
            if (sender is not FrameworkElement element)
                return;

            if (element.Tag is not string name)
                return;

            if (TryGetButton(name, out ConButton conButton))
            {
                _module.ReleaseButton(conButton);
                e.Handled = true;
            }
        }

        private void Tilt_MouseDown(
            object sender,
            MouseButtonEventArgs e)
        {
            if (sender is not FrameworkElement element)
                return;

            if (element.Tag is not string name)
                return;

            if (TryGetTilt(name, out ConKnobTilt tilt))
            {
                _module.TiltKnob(tilt);
                e.Handled = true;
            }
        }

        private void Tilt_MouseUp(
            object sender,
            MouseButtonEventArgs e)
        {
            _module.ReleaseTilt();
            e.Handled = true;
        }

        private void Knob_MouseWheel(
            object sender,
            MouseWheelEventArgs e)
        {
            int clicks = e.Delta > 0 ? 1 : -1;
            _module.Rotate(clicks);
            e.Handled = true;
        }

        private void Knob_MouseDown(
            object sender,
            MouseButtonEventArgs e)
        {
            _module.PressKnob();
            e.Handled = true;
        }

        private void Knob_MouseUp(
            object sender,
            MouseButtonEventArgs e)
        {
            _module.ReleaseKnob();
            e.Handled = true;
        }

        private static bool TryGetButton(
            string name,
            out ConButton button)
        {
            button = name switch
            {
                "MENU" => ConButton.Menu,
                "BACK" => ConButton.Back,
                "OPTION" => ConButton.Option,
                "RADIO" => ConButton.Radio,
                "CD" => ConButton.Cd,
                "NAV" => ConButton.Nav,
                "TEL" => ConButton.Tel,
                _ => ConButton.None
            };

            return button != ConButton.None;
        }

        private static bool TryGetTilt(
            string name,
            out ConKnobTilt tilt)
        {
            tilt = name switch
            {
                "TILT_UP" => ConKnobTilt.Up,
                "TILT_DOWN" => ConKnobTilt.Down,
                "TILT_LEFT" => ConKnobTilt.Left,
                "TILT_RIGHT" => ConKnobTilt.Right,
                _ => ConKnobTilt.Center
            };

            return name is "TILT_UP"
                or "TILT_DOWN"
                or "TILT_LEFT"
                or "TILT_RIGHT";
        }
    }
}
