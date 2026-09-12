using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.modules.CAN
{
    public readonly record struct CanFrame(uint Id, byte[] Data, TimeSpan TimeStamp)
    {
        public int Dlc => Data.Length;
    }
}
