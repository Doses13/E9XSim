using E9XSim.protocols.CAN.E9X.INFO_CON;
using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.modules.INFO_CON
{
    public sealed class ConState
    {
        public ushort RotaryPosition { get; set; }
        public bool KnobPressed { get; set; }
        public ConKnobTilt KnobTilt { get; set; } = ConKnobTilt.Center;
        public ConButton ActiveButton { get; set; } = ConButton.None;
    }

    public enum ConKnobTilt
    {
        Center,
        Up,
        Down,
        Left,
        Right
    }
}
