using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.modules.CAN
{
    public interface ICanBus
    {
        string Name { get; }

        event Action<string, CanFrame>? FrameTransmitted;

        void Send(string source, CanFrame frame);
    }
}
