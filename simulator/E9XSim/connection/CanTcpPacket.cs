using E9XSim.modules.CAN;
using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.connection
{
    public readonly record struct CanTcpPacket(
        byte Bus,
        uint Id,
        byte Flags,
        byte Dlc,
        byte[] Data)
    {
        public static CanTcpPacket FromCanFrame(
            CanFrame frame,
            byte bus = 0)
        {
            return new CanTcpPacket(
                Bus: bus,
                Id: frame.Id,
                Flags: 0,
                Dlc: (byte)frame.Dlc,
                Data: frame.Data.ToArray());
        }

        public CanFrame ToCanFrame(
            TimeSpan simulationTime)
        {
            return new CanFrame(
                Id,
                Data.Take(Dlc).ToArray(),
                simulationTime);
        }
    }
}
