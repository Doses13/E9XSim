using System;
using System.Collections.Generic;
using System.Text;

namespace E9XSim.mainApp
{
    public sealed class CanLogEntry
    {
        public string Time { get; init; } = "";
        public string Bus { get; init; } = "";
        public string Source { get; init; } = "";
        public string Id { get; init; } = "";
        public int Dlc { get; init; }
        public string Data { get; init; } = "";
    }
}
