using E9XSim.modules;
using E9XSim.modules.CAN;
using System;
using System.Collections.Generic;
using System.Text;


namespace E9XSim.connection
{
    public sealed class CanTcpBridge : ISimModule, IDisposable
    {
        private readonly ICanBus _bus;  // this a reference
        private readonly CanTcpTransport _transport;

        public string Name => "CIC CAN Bridge";

        public ModuleExecutionState ExecutionState
            => ModuleExecutionState.Running;

        public bool IsConnected
            => _transport.IsConnected;

        public CanTcpBridge(ICanBus bus, int port)
        {
            _bus = bus;
            _transport = new CanTcpTransport(port);

            _bus.FrameTransmitted += OnFrameTransmitted;
        }

        private void OnFrameTransmitted(
            string source,
            CanFrame frame)
        {
            if (source == "CIC")
                return;

            _transport.QueueOutgoing(
                CanTcpPacket.FromCanFrame(frame));  // where does this function live???
        }

        public void Step(
            TimeSpan simulationTime,
            TimeSpan deltaTime)
        {
            while (_transport.TryReceive(out CanTcpPacket packet))
            {
                var frame = packet.ToCanFrame(simulationTime);  // and this function???

                _bus.Send("CIC", frame);
            }
        }

        public void Dispose()
        {
            _bus.FrameTransmitted -= OnFrameTransmitted;

            _transport.Dispose();
        }
    }
}
