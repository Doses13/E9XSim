using E9XSim.mainApp;
using E9XSim.modules.INFO_CON;
using System.Configuration;
using System.Data;
using System.Windows;

namespace E9XSim
{
    public partial class App : Application
    {
        public SimulationEngine Simulation { get; private set; } = null;
        public SimulationRunner Runner { get; private set; } = null;

        protected override void OnStartup(StartupEventArgs e)
        {
            base.OnStartup(e);

            Simulation = new SimulationEngine();

            Runner = new SimulationRunner(Simulation);

            MainWindow window = new MainWindow(Simulation, Runner);

            MainWindow = window;
            window.Show();
        }

    }

}
