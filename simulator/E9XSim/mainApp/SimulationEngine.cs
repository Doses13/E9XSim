using System;
using System.Collections.Generic;
using System.Text;
using System.Linq;

using E9XSim.modules;
using E9XSim.modules.CAN;
using E9XSim.modules.INFO_CON;
using E9XSim.connection;

namespace E9XSim.mainApp
{
    public class SimulationEngine
    {
        private readonly List<ISimModule> _modules = [];

        public SimulationClock Clock { get; } = new();

        public IReadOnlyList<ISimModule> Modules => _modules;

        public VirtualCanBus KCan { get; }
            = new("K-CAN");

        public SimulationEngine()
        {
            RegisterModule(new CanTcpBridge(KCan, 29536));
            RegisterModule(new ConModule(KCan));
        }

        public void RegisterModule(ISimModule module)
        {
            _modules.Add(module);
        }

        public T? GetModule<T>() where T : class, ISimModule
        {
            return _modules.OfType<T>().FirstOrDefault();
        }

        public void Step(TimeSpan deltaTime)
        {
            Clock.Step(deltaTime);

            foreach (var module in _modules)
            {
                if (module.ExecutionState == ModuleExecutionState.Running)
                {
                    module.Step(
                        Clock.Time,
                        deltaTime);
                }
            }
        }
    }
}
