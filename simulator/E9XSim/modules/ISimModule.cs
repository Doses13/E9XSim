using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.modules
{
    public interface ISimModule
    {
        string Name { get; }

        ModuleExecutionState ExecutionState { get; }

        void Step(TimeSpan simulationTime, TimeSpan deltaTime);

    }
}
