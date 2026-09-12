using E9XSim.modules.CAN;
using System.Text;
using System.Windows;
using System.Windows.Controls;
using System.Windows.Data;
using System.Windows.Documents;
using System.Windows.Input;
using System.Windows.Media;
using System.Windows.Media.Imaging;
using System.Windows.Navigation;
using System.Windows.Shapes;
using System.Windows.Threading;
using System.Collections.ObjectModel;

using E9XSim.modules.INFO_CON;
using E9XSim.protocols.CAN;

namespace E9XSim.mainApp
{
    public partial class MainWindow : Window
    {

        private readonly SimulationEngine _simulation;
        private readonly SimulationRunner _runner;

        private readonly DispatcherTimer _uiTimer;

        public ObservableCollection<ModuleShelfItem> ModuleShelf { get; }
            = new();

        public ObservableCollection<CanLogEntry> CanLog { get; }
            = new();

        public MainWindow(
            SimulationEngine simulation,
            SimulationRunner runner)
        {
            InitializeComponent();

            _simulation = simulation;

            var con = _simulation.GetModule<ConModule>()
                ?? throw new InvalidOperationException(
                    "CON module was not registered.");

            ModuleShelf.Add(
                new ModuleShelfItem(
                    con,
                    "Infotainment",
                    () => new ConWindow(con, _simulation)));

            DataContext = this;

            _runner = runner;

            _simulation.KCan.FrameTransmitted += OnCanFrame;

            _uiTimer = new DispatcherTimer
            {
                Interval = TimeSpan.FromMilliseconds(10)
            };

            _uiTimer.Tick += (_, _) =>
            {
                SimulationTimeText.Text =
                    _simulation.Clock.Time.ToString(@"hh\:mm\:ss\.fff");
            };

            _uiTimer.Start();
        }

        private void Play_Click(object sender, RoutedEventArgs e)
        {
            _runner.Play();
        }

        private void Pause_Click(object sender, RoutedEventArgs e)
        {
            _runner.Pause();
        }

        private void Step_Click(object sender, RoutedEventArgs e)
        {
            _runner.Step();
        }

        private void OnCanFrame(string source, CanFrame frame)
        {
            CanLog.Add(new CanLogEntry
            {
                Time = frame.TimeStamp.TotalSeconds.ToString("F3"),
                Bus = _simulation.KCan.Name,
                Source = source,
                Id = $"0x{frame.Id:X3}",
                Dlc = frame.Dlc,
                Data = BitConverter
            .ToString(frame.Data)
            .Replace("-", " ")
            });

            // Prevent the GUI from eventually keeping millions of rows.
            if (CanLog.Count > 5000)
                CanLog.RemoveAt(0);

            if (BusMonitorGrid.Items.Count > 0)
            {
                BusMonitorGrid.ScrollIntoView(
                    BusMonitorGrid.Items[
                        BusMonitorGrid.Items.Count - 1]);
            }
        }

        private void OpenModule_Click(object sender, RoutedEventArgs e)
        {
            if (sender is Button button &&
                button.Tag is ModuleShelfItem item)
            {
                item.OpenWindow();
            }
        }
    }
}