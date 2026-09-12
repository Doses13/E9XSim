using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.modules.CAN
{
    public sealed class VirtualCanBus : ICanBus
    {
        public string Name { get; }

        public event Action<string, CanFrame>? FrameTransmitted;

        public VirtualCanBus(string name)
        {
            Name = name;
        }

        public void Send(string source, CanFrame frame)
        {
            FrameTransmitted?.Invoke(source, frame);
        }
    }
}
