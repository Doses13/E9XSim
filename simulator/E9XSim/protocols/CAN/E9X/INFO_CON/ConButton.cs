using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.protocols.CAN.E9X.INFO_CON
{
    [Flags]
    public enum ConButton : byte
    {
        None    = 0x00,
        Menu    = 0x01,
        Back    = 0x02,
        Option  = 0x04,
        Radio   = 0x08,
        Cd      = 0x10,
        Nav     = 0x20,
        Tel     = 0x40
    }
}
